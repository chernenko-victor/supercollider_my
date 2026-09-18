///////////////////////////////////////
// livecoding style
// изменение параметров без рестарта
//
// change freq and duration, evaluate region
// to stop change "play" to "stop" and evaluate region

==================================================
     изменение индивидуальных параметров паттерна
===================================================

(
Pbindef(
	\seq2,

	\freq, Pser([1, {rrand(2, 6)}, 4] * 220, inf).trace,
		\dur, Pser([1] * 0.25, inf),

).play;
)

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


арифметическая прогрессия с 32 до 80 с шагом 1 записывается в массив
(32..80)


арифметическая прогрессия с 35 до 22 с шагом 2 записывается в массив
(35, 33..22)


График генератора синусоидальной звуковой волны
{ SinOsc.ar(440) }.plot(0.01, bounds: Window.screenBounds);


Серия из 10 случайных чисел, график точками
Pser({rrand(-3, 7)}.dup(10), inf).asStream.nextN(10).plot("Pattern from random", discrete: true);

asStream "запускает" работу паттерна
nextN(10) выводит в массив первые 10 значений

Pser({rrand(-3, 7)}.dup(10), inf).asStream.nextN(10).plot("Pattern from random");

===================================================
      модификация последовательности (секвенции)
===================================================

Сделаем плавное изменение dur
(
Pbindef(
	\seq3,

		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, (
			Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)
		).trace,
).play;
)


Такой прием называется "модуляция"

Pser([1, 2, Rest(3), 4, Rest(2)], inf).asStream.nextN(10).plot("Rythm pattern", discrete: true);

Pser((0.1, 0.105..0.65)**4, inf).asStream.nextN(50).plot("Rythm pattern", discrete: true);

(
(Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)).asStream.nextN(70).plot("Rythm pattern", discrete: true);
)


Как сделать аккорды?
(
Pbindef(
	\seq5_acc,
		\freq, Ptuple([
			Pseq([60, 62, 64].midicps, inf),
			Pwhite(67, 72, inf).midicps,
			Pseq([Pseries(40, 2, 15)], inf).midicps,
		]).trace,
		\dur, 1,
).play;
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

разннобразие внутри секвенции
(
Pseq(
	[1, 2, 3, Prand([4, 5, 10, 20], 1)],
	4
).asStream.nextN(20)
)


повторение значения N раз
Pn(0.5, 2).asStream.nextN(2)

(
Pseq([
		1, 1, 1, 1,
		Prand([Pn(1, 3), Pn(0.5, 2)], 4)
], inf).asStream.nextN(20)
)

!!!
частота появления определенного числа в рандоме

(
Pseq(
	[1, Prand([4, 5, 5, 5, 6], 1)],
	8
).asStream.nextN(20)
)

чем больше раз повторяется элемент в Prand, тем чаще он появляется в результате
Но остальные элементы тоже появляются, просто реже.

===================================================
              Модуляция параметров
===================================================

скопируем паттерн из kick808 из библиотеки SCLOrkSynths и заменим ограниченное время исполнения на inf

(
Pbindef(\kick808_4onthefloor,
	\instrument, "kick808",
	\dur, Prand([1, 1, 1, 1, 0.5, Rest(1), Rest(0.5)], inf) * 0.4,
	\amp, 0.1,
	\rel, 0.7,
	\dist, Pser((0.1, 0.2..1), inf) // здесь бесконечную серю заменили на ограниченную
).play;
)

панорамирование
(
Pbindef(
	\kick808_4onthefloor, \pan, Pser((-0.5, -0.25..0.5), inf)
	)
)


основной тон
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
m.noteOn(0, 63, 60);
m.noteOff(0, 63, 60);


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

(
Pbindef(\tr_ba_midi,
	\dur, Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.01, 0.012..1.4)**4, inf)
);
)


Pbindef(\tr_ba_midi).stop;

(
Pbindef(\tr_ba_cc,
    \type, \midi,
    \midiout, m,          // Ваш текущий MIDI-выход m
    \chan, 0,             // Тот же MIDI-канал

    \midicmd, \control,   // Главное изменение: переключаемся в режим CC!
    \ctlNum, 1,           // Номер контроллера (например, 1 — колесо модуляции, 74 — яркость/cutoff)

    // Значение CC (должно быть целым числом в диапазоне от 0 до 127)
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

    // Значение CC (должно быть целым числом в диапазоне от 0 до 127)
    // Используем Pseg, чтобы плавно крутить ручку вверх и вниз
	\control, Pser((32..80), inf).asInteger.trace,          // Обязательно округляем до целых чисел

    \dur, 1            // Как часто отправлять значения (чем меньше шаг, тем плавнее движение)
).play;         // Запускаем по той же сетке, что и ноты
)

Pbindef(\tr_ba_cc_growl).stop;


===================================================
            Типы данных. Массивы, списки
===================================================

~midi_pitch1_arr = Array.newClear(10); // создаем пустой массив длиной 10
~midi_pitch1_arr.postln; // вывод массива в консоль
~midi_pitch1_arr[0].postln; // значение по умолчанию
~midi_pitch1_arr[0] = 64; // присвоение значение первому элементу

1.class; // отобразить тип данных
~midi_pitch2_arr = [];
~midi_pitch2_arr.class;
// ~x.isKindOf(Float);
/*
У многих базовых типов в SuperCollider есть встроенные быстрые методы для проверки:~x.isNumber — является ли числом.
*/


// List
~midi_pitch3_arr = List[1, 4, 6];
~midi_pitch3_arr.class;

В список можно добавлять новые эл-ы, в массив нельзя, он фиксированной длины
~midi_pitch1_arr3 = Array.newClear(10);


.do(<функция>) применяет функцию к каждому элементу массива

(
~midi_pitch1_arr3.do({
	arg ...args; // все входные параметры сохраняются в массив args
	// args[0] - значение, args[1] - индекс элемента
	// args.postln;
	~midi_pitch1_arr3[args[1]] = args[1] * 2 + rrand(0, 3) // изменим каждый элемент
});
)

// массивы можно складывать и умножать на число
~dur_arr = Array.rand(5, 1, 6) * 0.25;

// объединение 2-х массивов в один
~dur_arr = ~dur_arr ++ ([Rest(1), Rest(2), Rest(4)] * 0.25)


~dur_arr_nonclassic = ~dur_arr.scramble;

// неклассическая модификация ритмики
(
~dur_arr_nonclassic.do({
	arg ...args;
	~dur_arr_nonclassic[args[1]] = args[0] * (1 + (args[0] * 0.05))
});
)


Функция как объект с входами и выходами
(
~get_rnd_dur = {
	arg dur_arr;// this is input
	var result = -1; // default value for variable
	dur_arr.size.postln;
	result = dur_arr.choose; // get random value from array
	result; // last string is output, for multuple output use array
};
)

~get_rnd_dur.(~dur_arr_nonclassic); // вызов функции

//////////////////////////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear
// Разная частотность появления случайных элементов

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution



=========================================
         таймер, квантизация
========================================

~cklk1 = TempoClock.new(1); // beats per seconds

~cklk1.beats;

~cklk1.tempo = 1;

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
           Изменение параметра паттерна Pdef
=======================================================

Pdef тоже можно использовать для изменения в реал-тайме отдельных параметров
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


======================================================
         функция как синтезатор
=======================================================

окно показывает активные экземпляры синтов
s.plotTree;

(
{
	arg freq = 440;
	(
		SinOsc.ar(freq)
		+ (SinOsc.ar(freq * 2) / 2)
		+ (SinOsc.ar(freq * 3) / 3)
		+ (SinOsc.ar(freq * 4) / 4)
		+ (SinOsc.ar(freq * 5) / 5)
	) / 5;
}.play;
)

Нет названия, чтобы использовать в паттерне



// define synths
(
{
	arg freq = 440;
	(
		SinOsc.ar(freq)
		+ (SinOsc.ar(freq * 2) / 2)
		+ (SinOsc.ar(freq * 3) / 3)
		+ (SinOsc.ar(freq * 4) / 4)
		+ (SinOsc.ar(freq * 5) / 5)
	) / 5;
}.asSynthDef(fadeTime: 0.1, name: \test_synth).add;
)

~test_synth_exempl1 = Synth(\test_synth, args: [\freq, 110 + (10.rand * 200)]);
~test_synth_exempl1.release();


Теперь можно использовать в паттерне

Pbindef(\seq3).clear;

(
Pbindef(
	\seq3,
	    \instrument, \test_synth,
		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, (
			Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.01, 0.012..1.4)**4, inf)
		).trace,
).play;
)

Задание для самостоятельной работы
1. Подключите виртуальный или железный синтезатор, который управляется по MIDI.
2. В дополнение к партиям прежнего задания сделайте партию для внешнего синтезатора, меняйте ее с помощью Pbundef. Запишите синтезатор, сведите его с ранее записанными партиями внутренних синтов SuperCollider.

Виртуальный MIDI кабель для Windows: loopMidi https://www.tobias-erichsen.de/software/loopmidi.html
Для Mac: IAC-драйвер, есть в системе по умолчанию, устанавливать не надо.
Настройка: 1.	Откройте на Mac приложение «Настройка Audio-MIDI» (Audio MIDI Setup).
2. В верхнем меню нажмите Окно -> Показать MIDI-студию (или нажмите Cmd + 2).
3. В появившемся окне найдите иконку красного цвета с надписью Драйвер IAC (IAC Driver) и кликните по ней дважды.
4. В открывшихся свойствах обязательно поставьте галочку «Устройство подключено» (Device is online).
5. Ниже в блоке «Порты» по умолчанию уже будет создан один порт (обычно Bus 1)
6. Нажмите Применить (Apply).

https://drive.google.com/file/d/1UiAw8ub-4__yRIHRc1eUYwBciLQpIwGJ/view?usp=sharing