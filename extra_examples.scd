s.boot;

~clck1 = TempoClock.new(60/60);

~clck1.beats;


================================================
    при изменении проекта синта звучашие экземпляры не меняются
================================================

(
{
	LFTri.ar(220) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \tri_synth__proto).add;
)


~tri_synth1 = Synth(\tri_synth__proto);


(
{
	LFTri.ar(440) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \tri_synth__proto).add;
)

~tri_synth2 = Synth(\tri_synth__proto);

~tri_synth1.free;
~tri_synth2.free;

================================================
    синхронизация с offbeat
================================================
(
Pbindef(\def_seq1,
	\dur, 1
).clock_(~clck1).quant_(1);
)

(
Pbindef(\kick808_float_quant_seq,
	\dur, 1,
	\instrument, "kick808",
	\amp, 0.5,
).clock_(~clck1).quant_(1.5); // задает сетку 1.5 * n, n = 1, 2, 3  ... Так что может и на третьей доле вступить и на 1.5 ))

)

Pbindef(\def_seq1).play;

Pbindef(\kick808_float_quant_seq).play;

Pbindef(\kick808_float_quant_seq).quant = 1.33; // обновится только после рестарта

Pbindef(\kick808_float_quant_seq).quant = Quant.new(quant: 1, phase: 0.5); // Тут он сначала ищет бит кратный значению quant, а потом от него откладывает еще полбита, так что всегда гарантированно запустится в offbeat

// чтобы сдеать phasing, надо 2 клока и одному из них менять темп

Pbindef(\def_seq1).stop;

Pbindef(\kick808_float_quant_seq).stop;
Pbindef(\kick808_float_quant_seq).clear;


================================================
    примеры разных паттернов
================================================
(
Pbindef(\kick808_my,
	// \instrument, "kick808",
	\instrument, "distortedGuitar",
	\freq, [135, 149],
	\dur, Pseq([
		3/4, 1/4,
		1/2, 1/2,
		Rest(1/2), 1/2,
		Rest(1/4), 3/4
	], inf),
	\amp, 0.2,
	/*
	\rel, 0.7,
	\dist, Pseries(0.1, 0.1, 16),
	*/
	\pickPos, Pwhite(0.2, 0.8),
	\muteSus, Pseq([
		    0.15, 0.15, 0.15, 0.15, 0.25, 0, 0.15, 0.15,
		    0.15, 0.3, 0, 0.15, 0.2, 0, 0.15, 0.15], inf),
).clock_(~clck1).quant_(1);
)


Pbindef(\kick808_my).play;
Pbindef(\kick808_my).clear;
Pbindef(\kick808_my).stop;


// ~clck1.tempo_(88/60);
~clck1.tempo_(120/60);



(
Pbindef(\kick808_2_my,
	\instrument, "kick808",
	\dur, Pseq([
		4,
		Rest(2), 2,
		4,
		Rest(2), 2,
	], inf) * 0.4,
	\amp, 0.8,
	\rel, 0.7,
	\dist, Pser((0.1, 0.2..1), inf),
).clock_(~clck1).quant_(1);
);

Pbindef(\kick808_2_my).play;
Pbindef(\kick808_2_my).clear;
Pbindef(\kick808_2_my).stop;



(
Pbindef( \snareOto309_my,
	// \instrument, "snareOto309",
	\instrument, "subBass2",
	\dur, Pseq([2/3, 1/3, 1/3, 1], inf),
	// \freq, 78,
	\amp, 0.5,
	\ctranspose, -20,
	\blend, Pwhite(0.25, 0.75, inf),
	\degree, Pseq([
				-2, -2, -2, -2, 5, -2, -2, -2, 2, 1,
				0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 7,
				-2, -2, -2, -2, 5, -2, -2, -2, 2, 1,
				0, 0, 0, 0, 4, 2, 5, 2, 0, -2], inf),
	/*
	\att, Pwhite(0.01, 0.1),
	\dec, Pwhite(0.01, 0.1),
	\rel, Pwhite(0.05, 0.25),
	\curve, Pwhite(-8, -2),
	\preamp, Pwhite(1.2, 2),
	\filterHarmonic, Pwhite(1.2, 5),
	\oscsHarmonic, Pwhite(1.5, 3),
	\blend, Pwhite(0.333, 0.667),
	\oscsAmp, Pwhite(0.1, 1),
	\noiseRatio, Pwhite(0.3, 0.7),
	\noiseAmp, Pwhite(0.1, 1),
	*/
).clock_(~clck1).quant_(1);
);

Pbindef(\snareOto309_my).play;
Pbindef(\snareOto309_my).clear;
Pbindef(\snareOto309_my).stop;


=============================================

1. Выполните в SuperCollider следующую строчку кода (выделите и нажмите Ctrl+Enter / Cmd+Enter):supercollider

Quarks.install("Bjorklund");

(Для работы этой команды в системе должен быть установлен Git. Если Git нет, SC предложит открыть GUI-менеджер, где можно управлять пакетами).

2. Обязательно перекомпилируйте библиотеку классов, чтобы SuperCollider «увидел» новый объект. Для этого нажмите:
	• Ctrl + Shift + L (на Windows/Linux)
	• Cmd + Shift + L (на macOS)
	• Или через верхнее меню: Language -> Recompile Class Library.


// 1. Сначала загрузи сервер (Ctrl+B или Cmd+B)
s.boot;

// 2. Определяем синтезаторы (SynthDefs)
(
// Чистый синус с ультра-короткой огибающей (главный тон Икэды)
SynthDef(\ikeda_sine, {
    arg freq = 1000, amp = 0.5, pan = 0, att = 0.001, rel = 0.05;
    var env, sig;
    // Огибающая без атаки (сразу в пик) для максимального щелчка
    env = EnvGen.ar(Env.perc(att, rel), doneAction: 2);
    sig = SinOsc.ar(freq);
    sig = sig * env * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;

// Цифровой клик / глитч (эмуляция ошибки чтения диска)
SynthDef(\ikeda_click, {
    arg amp = 0.7, pan = 0, type = 0;
    var env, sig;
    env = EnvGen.ar(Env.perc(0.0001, 0.005), doneAction: 2);
    // Выбираем между чистым импульсом и коротким взрывом белого шума
    sig = Select.ar(type, [
        Impulse.ar(0),
        WhiteNoise.ar
    ]);
    sig = sig * env * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;

// Суб-басовый импульс (качает низ, пока синусы режут слух)
SynthDef(\ikeda_sub, {
    arg freq = 50, amp = 0.8, rel = 0.1;
    var env, sig;
    env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
    sig = SinOsc.ar(freq);
    sig = sig * env * amp;
    Out.ar(0, Pan2.ar(sig, 0)); // Бас строго по центру
}).add;
)

// 3. Запуск генеративного паттерна (Pbindef)
(
// Задаем высокий темп (Икэда любит субделения на сетке 140-160 BPM)
TempoClock.default.tempo = 150 / 60;

// Поток 1: Высокие "данные" и синусоиды
Pbindef(\data_stream,
    \instrument, \ikeda_sine,
    // Выбираем экстремально высокие частоты, почти дата-звук
    \freq, Pseq([8000, 12000, 4000, 15000, Rest(), 10000, Rest(), 16000], inf),
    // Ритмическая сетка: очень мелкие длительности (16-е и 32-е)
    \dur, Pwrand([0.125, 0.25, Rest(0.125)], [0.5, 0.4, 0.1], inf),
    \amp, Pwhite(0.1, 0.4, inf),
    \rel, Pwhite(0.005, 0.04, inf), // ультра-короткие хвосты
    \pan, Pwhite(-1.0, 1.0, inf)     // хаотичное стерео
).play;

// Поток 2: Клик-перкуссия (глючный метроном)
Pbindef(\click_stream,
    \instrument, \ikeda_click,
    \dur, Pbjorklund2(3, 8, inf) / 4, // Бодрые ритмы на основе полиритмов Джона Китса/Бьерклунда
    \type, Pwrand([0, 1], [0.8, 0.2], inf), // чаще чистый клик, реже шум
    \amp, Pwhite(0.3, 0.6, inf),
    \pan, Pseq([-0.8, 0.8], inf) // жесткое панорамирование влево-вправо
).play;

// Поток 3: Математический суб-бас
Pbindef(\sub_stream,
    \instrument, \ikeda_sub,
    \freq, Pseq([45, 55, Rest(), 50, Rest(), 45, Rest(), Rest()], inf),
    \dur, 0.5, // ровные восьмые, создающие структуру
    \rel, Pseq([0.2, 0.05, 0.1], inf),
    \amp, 0.6
).play;
)

// 4. Интерактивное управление "на лету" (как во время лайва)
// Сделай синусы невыносимо быстрыми (32-е ноты):
Pbindef(\data_stream, \dur, 0.0625);

// Подними частоту синусов на грань слышимости:
Pbindef(\data_stream, \freq, Pwhite(14000, 19000, inf));

// Верни структуры назад:
Pbindef(\data_stream, \dur, 0.125, \freq, Pseq([4000, 6000, 8000], inf));

Pbindef(\data_stream, \dur, Pwrand([0.125, 0.25, Rest(0.125)], [0.5, 0.4, 0.1], inf));


Pbindef(\data_stream, \dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], inf));


Pbindef(\sub_stream, \dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], inf));

Pbindef(\sub_stream, \dur, Pbjorklund2(3, 8, inf) / 4);


Pbindef(\data_stream, \dur, Pwalk((1..12)/6, stepPattern: Pser([1, 2], inf), directionPattern: 1));

Pbindef(\sub_stream, \dur, Pbjorklund2(3, 8, inf) / 4);


Pbindef(\data_stream, \freq, Pseq([4000, 6000, 8000], inf));

Pbindef(\data_stream, \freq, Pwalk([(12..1), (9..-3)] * 1000, stepPattern: Pser([1, 2], inf), directionPattern: 1));


(
Pbindef(\data_stream,
	\freq, Pwalk([(12..1), (9..-3)] * 1000, stepPattern: Pser([1, 2], inf), directionPattern: 1)) * Pwalk((2..13), stepPattern: Pser([1, 2], inf), directionPattern: 1);

)


Pbindef(\click_stream, \dur, Pwalk((1..12)/6, stepPattern: Pser([1, 2], inf), directionPattern: 1));


Pbindef(\sub_stream).pause;
Pbindef(\sub_stream).resume;




Pbindef(\sub_stream, \dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], inf));



Pbindef(\sub_stream, \freq, Pseq([45, 55, Rest(), 50, Rest(), 45, Rest(), Rest()], inf));

(
Pbindef(\sub_stream,
	\freq, Pseq(
		(1, 3..17) ++
		(16, 14..1) ++
		[Rest(2)],
		inf
	) * 30
);
)

Pbindef(\data_stream).pause;
Pbindef(\data_stream).resume;


(
Pbindef(\click_stream,
	\dur,
	Pwalk((1..12)/6, stepPattern: Pser([1, 2], inf), directionPattern: 1)
);

)

(
Pbindef(\click_stream,
	\dur,
	Pser([1, Prand([2, Rest(2)], 1), 3, 4, Prand([2, Rest(2)], 1)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)
);

)


(
Pbindef(\data_stream, \dur, Pwalk((1..12)/6, stepPattern: Pser([1, 2], inf), directionPattern: 1));
)

(
Pbindef(\data_stream,
    \dur, Pwalk(
		(1..12) ++ Prand([Rest(1), Rest(1), Rest(3), Rest(6)], 1),
		  stepPattern: Prand([-2, -1, 0, 1, 2], inf),
		  directionPattern: Prand([-1, 1], inf)
	) * 0.05
);
)

\dur, Pwalk(
		(1..12) ++ Prand([Rest(1), Rest(1), Rest(3), Rest(6)], 1),
		  stepPattern: Prand([-2, -1, 0, 1, 2], inf),
		  directionPattern: Prand([-1, 1], inf)
	) * 0.05


Pbindef(\data_stream).play;
Pbindef(\click_stream).play;

// 5. Остановить всё
(
Pbindef(\data_stream).stop;
Pbindef(\click_stream).stop;
Pbindef(\sub_stream).stop;
)
