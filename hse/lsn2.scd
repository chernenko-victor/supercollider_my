///////////////////////////////////////
// livecoding style
//
// change freq and duration, evaluate region
// to stop change "play" to "stop" and evaluate region

==================================================
     изменение индивидуальных параметров паттерна
===================================================

(
Pbindef(
	\seq2,

		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, Pser([1, 2, Rest(3), 4, Rest(1)] * 0.25, inf).trace,

).play;
)

(
Pbindef(
	\seq2,
	\dur, 1
);
)

(
Pbindef(
	\seq2,
	\freq, Prand(([1, 2, 4, 6, 7] + 60).midicps, inf)
);
)

добавляем новый параметер
(
Pbindef(
	\seq2,
	\amp, Prand(([1, 2, 4, 6, 7] * 0.05), inf)
);
)

Pbindef(\seq2).stop;


Если Pbindef запустить без параметров, звука не будет, у него нет дефолтных настроек

========================================================
           Отладка и тестирование/ Debug
========================================================

1. Чтобы посмотреть значения паттерна во время работы Pbind/ Pdef надо в паттерне включить метод trace

2. график
[1, 2, 22].plot("Some array");
(10, 8..-4).plot("Some array with shortcut", discrete: true);

((10, 8..-4)**0.71).plot("Some nonlinear");

((10, 8..-4)**1.76).plot("Some nonlinear");

Array.geom(5, 1, 3).plot("Geometric progression");

Array.geom(5, 20, 1/3).plot("Geometric regression");


{ SinOsc.ar(440) }.plot(0.01, bounds: Window.screenBounds);


Pser({rrand(-3, 7)}.dup(10), inf).asStream.nextN(10).plot("Pattern from random", discrete: true);

Pser({rrand(-3, 7)}.dup(10), inf).asStream.nextN(10).plot("Pattern from random");


===================================================
Сделаем плавное изменение dur
===================================================

(
Pbindef(
	\seq3,

		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, (
			Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.01, 0.012..1.4)**4, inf)
		).trace,
).stop;
)

Как сделать аккорды?

(
Pbindef(
	\seq5_acc,
		\freq, Ptuple([
			Pseq([60, 62, 64].midicps, inf),
			Pwhite(67, 72, inf).midicps,
			Pseq([Pseries(40, 2, 15)], inf).midicps.trace,
		]),
		\dur, 1,
).stop;
)


(
Pbindef(
	\seq6_step_var,

		\freq, Pseries(40, {rrand(-3, 3)}, inf).midicps.trace,
		\dur, 1,

).stop;
)

===================================================
Как тестировать синты
===================================================

SCLOrkSynths.gui;

Копируем Pbindef из примеров
Если надо, меняем repeat в паттернах


!!!
Обязательно надо сбрасывать предыдущие параметры

Что приводит к непонятному поведению паттерна, часто его заменяют на Pdef (см. ниже)

Pbindef(\kick808).clear;

// Pattern demo
(
Pbindef(\kick808,
	\instrument, "kick808",
	\dur, Pseq([
		3/4, 1/4,
		1/2, 1/2,
		Rest(1/2), 1/2,
		Rest(1/4), 3/4
	], inf) * 0.4,
	\amp, 0.1,
	\rel, 0.7,
	\dist, Pser((0.1, 0.2..1), inf) // здесть бесконечную серю заменили на ограниченную
).stop;
);

Pbindef(\kick808, \amp, 0.1);
Pbindef(\kick808, \dist, Pser((0.1, 0.12..1), inf));


Pbindef(\hihat1).clear;
(
Pbindef(\hihat1,
	\instrument, "hihat1",
	\dur, Pseq([
		1, 1, 1, 1,
		Prand([1, 1, Pn(0.5, 2)], 4)
	], inf) * 0.2,
	\ffreq, Pwhite(7000, 11000),
	\rel, 0.1,
	\amp, 0.3
).stop;
);


===================================================
Вложенные паттерны I
===================================================

(
Pseq([
		1, 1, 1, 1,
		Prand([1, 1, Pn(0.5, 2)], 4)
], inf).asStream.nextN(20)
)


(
Pseq(
	[1, 2, 3, Prand([4, 5, 10, 20], 1)],
	4
).asStream.nextN(20)
)

!!!
частота появления определенного числа в рандоме

(
Pseq(
	[1, Prand([4, 5, 5, 5, 6], 1)],
	8
).asStream.nextN(20)
)

===================================================
Модуляция параметров
===================================================


(
Pbindef(\kick808_4onthefloor,
	\instrument, "kick808",
	\dur, Prand([1, 1, 1, 1, 0.5, Rest(1), Rest(0.5)], inf) * 0.4,
	\amp, 0.1,
	\rel, 0.7,
	\dist, Pser((0.1, 0.2..1), inf) // здесть бесконечную серю заменили на ограниченную
).play;
)

(
Pbindef(
	\kick808_4onthefloor, \pan, Pser((-0.5, -0.25..0.5), inf)
	)
)


(
Pbindef(
	\kick808_4onthefloor, \freq1, Pser((240, 250..440), inf)
	)
)


чтобы вернуть параметр к дефолту, надо присвоить ему значение nil

(
Pbindef(
	\kick808_4onthefloor, \freq1, nil
	)
)


Pbindef(\kick808_4onthefloor).stop;

===================================================
MIDI out
===================================================

Подключаем синт по миди
иди виртуальный миди кабель + DAW + VST


MIDIClient.init;


Смотрим порядковый номер устройства MIDI (нумерация начинается с 0).

m = MIDIOut(1);  // Linux users: MIDIOut(0, MIDIClient.destinations[0].uid)
m.noteOn(0, 60, 60);
m.noteOff(0, 60, 60);


(
~midi_pitch = rrand(60, 80);
m.noteOn(16, ~midi_pitch, rrand(50, 80));
)

m.noteOff(16, ~midi_pitch, 0);

m.allNotesOff(16);


(
Pbindef(\tr_ba_midi,
    \type, \midi,         // Говорим паттерну отправлять MIDI, а не генерировать аудио
    \midiout, m,          // Передаем наш MIDI-выход
    \chan, 0,             // MIDI-канал (0 = 1-й канал)
    \midinote, Pseq([60, 62, 64, 67], inf), // Ноты в формате MIDI (60 = До первой октавы)
    \dur, 0.25,
    \amp, 0.6             // Громкость, которая автоматически пересчитается в Velocity (0-127)
).play;
)

Pbindef(\tr_ba_midi).stop;

(
Pbindef(\tr_ba_cc,
    \type, \midi,
    \midiout, m,          // Ваш текущий MIDI-выход m
    \chan, 0,             // Тот же MIDI-канал

    \midicmd, \control,   // Главное изменение: переключаемся в режим CC!
    \ctlNum, 1,           // Номер контроллера (например, 1 — колесо модуляции, 74 — яркость/cutoff)

    // Значение CC (должно быть строго целым числом в диапазоне от 0 до 127)
    // Используем Pseg, чтобы плавно крутить ручку вверх и вниз
	\control, Pser((32..80), inf).asInteger.trace,          // Обязательно округляем до целых чисел

    \dur, 1            // Как часто отправлять значения (чем меньше шаг, тем плавнее движение)
).play;         // Запускаем по той же сетке, что и ноты
)

Pbindef(\tr_ba_cc).stop;

(
Pbindef(\tr_ba_cc_growl,
    \type, \midi,
    \midiout, m,          // Ваш текущий MIDI-выход m
    \chan, 0,             // Тот же MIDI-канал

    \midicmd, \control,   // Главное изменение: переключаемся в режим CC!
    \ctlNum, 12,           // Номер контроллера (например, 1 — колесо модуляции, 74 — яркость/cutoff)

    // Значение CC (должно быть строго целым числом в диапазоне от 0 до 127)
    // Используем Pseg, чтобы плавно крутить ручку вверх и вниз
	\control, Pser((32..80), inf).asInteger.trace,          // Обязательно округляем до целых чисел

    \dur, 1            // Как часто отправлять значения (чем меньше шаг, тем плавнее движение)
).play;         // Запускаем по той же сетке, что и ноты
)

Pbindef(\tr_ba_cc_growl).stop;


===================================================
Типы данных. Массивы, списки
===================================================

s.plotTree

~midi_pitch1_arr = Array.newClear(10);
~midi_pitch1_arr;
~midi_pitch1_arr[0];
~midi_pitch1_arr[0] = 64;

// ~midi_pitch1_arr

1.class;
~midi_pitch2_arr = [];
~midi_pitch2_arr.class;
// ~x.isKindOf(Float);
/*
У многих базовых типов в SuperCollider есть встроенные быстрые методы для проверки:~x.isNumber — является ли числом.
*/


// List
~midi_pitch3_arr = List[1, 4, 6];
~midi_pitch3_arr.class;



//////////////////////////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution



=========================================
      таймер, квантизация
========================================

~cklk1 = TempoClock.new(1); // beats per seconds
~cklk1.beats;

~cklk1.tempo = 0.77;

(
Pbindef(
	\seq11,
	\dur, 1
).clock_(~cklk1).quant_(1);
)

Pbindef(\seq11).play;

(
Pbindef(
	\seq12,
	\dur, 2,
	\freq, 330,
).clock_(~cklk1).quant_(1);
)

Pbindef(\seq12).play;

Pbindef(\seq11).stop;
Pbindef(\seq12).stop;


(
Pdef(
	\seq1,
	Pbind(
		\freq, 220,
	)
).play(argClock: ~cklk1, quant: 1);
)


(
Pdef(
	\seq2,
	Pbind(
		\freq, 440,
	)
).play(argClock: ~cklk1, quant: 4);
)

Quant

// baseBarBeat

t = TempoClock.new;

t.beatsPerBar = 3;  // error! wrong thread

t.schedAbs(t.nextBar, { t.beatsPerBar_(3) });  // OK


======================================================
    Изменение всего паттерна в реал-тайме
=======================================================

(
Pdef(
	\seq1_lc,
	Pbind(
		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, Pser([1, 2, Rest(3), 4, Rest(1)] * 0.25, inf).trace,
	)
).play;
)


Можно менять отдельные параметры
(
Pdef(\ptrn3_pl,
	Pbind(
		\dur, 0.25,
		\degree, Pdefn(\ptrn3_pl_degree, 3),
	)
).play;
)

(
Pdefn(\ptrn3_pl_degree, 0);
)

Pdef(\ptrn3_pl).stop;
