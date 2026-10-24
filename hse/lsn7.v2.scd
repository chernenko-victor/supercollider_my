Pbind().play;

===================================================
            MIDI In
===================================================

выполните весь регион, чтобы подключить внешнее midi устройство и объявить функции для обработки нот
(
var notes, on, off;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // массив для экземпляров синта

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
	notes[num] = Synth(\fb_sin_adsr__proto, [\freq, num.midicps,
        \amp, veloc * 0.00315]); // синт из прошлого занятия
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    notes[num].release;
});

q = { on.free; off.free; };
)


для обработки сообщений от контроллера номер 2
(
~cc1 = MIDIFunc.cc({|val, ccNum, chan, src|
    val.postln;
	// можно управлять параметрами звучащего синта
    // ~synth.set(\cc1, val / 127);
	// или другими процессами, например, работой паттернов
}, ccNum:2);
)

Подоключите контроллер (если нет железного, можно использовать TouchOSC + виртуальный миди-кабель), настройте управление на контроллер номер 2

// отключение функций
(
q.value;
~cc1.free;
)


======================================

Чтобы управлять параметрами синта, можно использовать коммутацию типа send
в collider называется шина (Bus)


// Создаем шину для управления (например, для частоты среза фильтра)
~cutoffBus = Bus.control(s, 1);
~cutoffBus.set(800); // начальное значение


делаем проект синта

(
SynthDef(\moogSynth, {
    arg outBus = 0, cutoffBus, freq = 110, amp = 0.3, gate = 1;
    var sig, cutoffEnv, env;

	env = Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).kr(doneAction: 2, gate: gate);

    // Читаем значение из управляющей шины
    cutoffEnv = In.kr(cutoffBus, 1);

    sig = Saw.ar(freq);

    // Используем значение из шины для управления частотой среза
    // Ограничиваем диапазон от 20 до 20000 Гц
    sig = LPF.ar(sig, cutoffEnv.clip(20, 20000));

	// Отправляем аудио в выходную шину
	// при подключении звукового устройства к collider
	// автоматически создается аудио-шина с ID = 0
	Out.ar(outBus, [sig * amp * env, sig * amp * env]);
}).add;
)

// Запускаем синтезатор и передаем ему шину
~mySynth = Synth(\moogSynth, [\cutoffBus, ~cutoffBus, \freq, 80]);

// Теперь меняйте значение в шине
~cutoffBus.set(200);
~cutoffBus.set(2000);

// Передача из другого синта
~lfo = { SinOsc.kr(0.5).exprange(200, 4000) }.play(outbus: ~cutoffBus);

// отключение синта
(
~mySynth.release();
~lfo.free;
)


============================================
используем шины для управления синтом по миди контроллеру

(
// Создаем MIDIFunc для чтения CC-сообщений
// Замените ccNum на номер вашей ручки/ползунка на MIDI-контроллере
~cutoffBusMidi = MIDIFunc.cc({ |val, num, chan, src|
    // Масштабируем значение MIDI (0-127) в диапазон частоты фильтра (200 - 10000 Гц)
    var freq = val.linexp(0, 127, 200, 10000);
	freq.postln;
    ~cutoffBus.set(freq);
}, ccNum: 2); //
)

Включим синт
~mySynth = Synth(\moogSynth, [\cutoffBus, ~cutoffBus, \freq, 80]);


Крутим миди ручку


Выключаем синт
~mySynth.free;


=========================================
Запустим синт в паттерне
(
~pattern = Pbind(
    \instrument, \moogSynth,
    \dur, 1,
    \degree, Pseq([0, 2, 4, 7, 4, 2], inf),
	\cutoffBus, ~cutoffBus,
    \amp, 0.3
).play;
)


Крутим миди ручку


Освобождаем ресурсы
(
~pattern.stop;
~cutoffBusMidi
)


=========================================
другой вариант использования шины

Можно привязать шину к входному параметру синта (а не читать внутри синта значение из шины)


(
SynthDef(\moog2__proto, {
    arg
	  outBus = 0,
	  cutoff = 400, // теперь это обычный параметер, а не шина
	  freq = 110,
	  amp = 0.3,
	  gate = 1
	;
    var sig, env;

	env = Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).kr(doneAction: 2, gate: gate);

    sig = Saw.ar(freq);

    // Используем значение из шины для управления частотой среза
    // Ограничиваем диапазон от 20 до 20000 Гц
    sig = LPF.ar(sig, cutoff.clip(20, 20000));

	// Отправляем аудио в выходную шину
	// при подключении звукового устройства к collider
	// автоматически создается аудио-шина с ID = 0
	Out.ar(outBus, [sig * amp * env, sig * amp * env]);
}).add;
)

~moog2 = Synth(\moog2__proto);

// Привязываем аргумент cutoff к нашей шине ~cutoffBus
~moog2.set(\cutoff, ~cutoffBus.asMap);

теперь при изменении шины будет меняться параметр работающего экземпляра

// Теперь меняйте значение в шине
~cutoffBus.set(200);
~cutoffBus.set(2000);


~moog2.release();


===============================================
                    audio bus
===============================================

s.plotTree; // будем следить за экземплярами синтов


// мастер-трек с финальной обработкой
(
~master_send = Bus.audio(s, 2);

SynthDef(\master_proto, {
	arg
	    limit_lvl_db = -0.7
	  , thresh = 0.5
	  , slopeBelow = 1
	  , slopeAbove = 1
	  , compressor_out_lvl_db = 0
	;
	var in, out, master_send_lvl_db = 0, out_bus = 0, in_bus = 100;
	in = In.ar(~master_send, 2);
	// in = In.ar(in_bus, 2);
	in = Compander.ar(
		  in: in
		, control: in
		, thresh: thresh
		, slopeBelow: slopeBelow
		, slopeAbove: 1.0
		, clampTime: 0.01
		, relaxTime: 0.1
		, mul: dbamp(compressor_out_lvl_db)
	);
	out = Limiter.ar(in, dbamp(limit_lvl_db));
	out = LeakDC.ar(out);
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;
)

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

(
SynthDef(\sin_fm, {
	arg freq = 440, amp =0.2, feedback = 0.1;
	var sig, env;
	env = Env.perc().kr(doneAction: 2);
	sig = SinOscFB.ar(freq: freq, feedback: feedback) * amp * env;
	Out.ar(~master_send, [sig, sig]); // направляем выход не напрямую в аудокарту, а на мастер-трек
}).add;
)


~sin_fm1 = Synth(\sin_fm);

Экземпляры синта добавляются сверху мастера, потому что \master_proto добавлен (.add) до добавления \sin_fm
Это принципиально, иначе сигнал не будет правильно прочитан из шины.

========================================

Самостоятельная работа:

Сделайте запуск/ остановку паттернов по определенным значениям контроллера

Пример:
0 - запустить паттерн1
1 - запустить паттерн2
2 - остановить паттерн1
3 - поменять ритмику паттерна2
....
....