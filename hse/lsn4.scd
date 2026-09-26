SCLOrkSynths.gui; // загружаем библиотеку


===================================================
          Синтез звука
===================================================

(
{
	SinOsc.ar()

}.play;
)
Какие недостатки у такого синтезатора?

...

Быстрый конструктор синта
(
{
	SinOsc.ar();
}.asSynthDef(fadeTime: 0.1, name: \my_first_synth__proto).add;
)

(
Pbindef(
	\seq3,
	// \instrument, "kick808",
	\instrument, \my_first_synth__proto,
	\dur, Pseq([1, 1, 1,
		Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
	], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).clock_(~clck3).play;
)

Pbindef(\seq3).stop;


(
Pbindef(\freq_seq_decreas, \instrument, \my_first_synth__proto);
)


Рандом в синтах
Rand  It generates this when the SynthDef first starts playing, and remains fixed for the duration of the synth's existence.

LFTri

LFPulse

LFSaw

(
{
	SinOsc.ar(Rand(1, 5) * 220);
}.asSynthDef(fadeTime: 0.1, name: \sin_freq_rnd__proto).add;
)

Pbindef(\seq3, \instrument, \sin_freq_rnd__proto);

Pbindef(\seq3).stop;


Параметры в паттернах
...


(
{
	arg freq = 440;
	SinOsc.ar(freq);
}.asSynthDef(fadeTime: 0.1, name: \my_first_synth__proto).add;
)



Ручной запуск
...

~my_first_synth1 = Synth(\my_first_synth__proto);

~my_first_synth1.run(0);
~my_first_synth1.run(1);

~my_first_synth1.release(0.2);

~my_first_synth1.set(\freq, rrand(1, 5) * 220);


Отображение экземпляров синта
s.plotTree;

Отображение проектов (прототипов) синтов
SynthDescLib.global.browse;

=============================================================
// CAUSION: Always limit amplitude before listening sounds!
// =============================================================

(
{
	arg freq = 440, amp = 0.4; // two inputs
	var sig = SinOsc.ar(freq) * amp;
	sig = sig + (SinOsc.ar(2 *freq) * amp/2);
	sig = sig + (SinOsc.ar(3 *freq) * amp/3);
	sig = sig + (SinOsc.ar(4 *freq) * amp/4);
	Limiter.ar( // just for safety: limit loud sounds to -0.4 dB
		sig, // audio signal
		level: dbamp(-0.4)
	);
}.asSynthDef(fadeTime: 0.1, name: \sin_synth_proto).add;
)

FreqScope.new();

~my_first_synth1 = Synth(\sin_synth_proto);

~my_first_synth1.run(0);
~my_first_synth1.run(1);

~my_first_synth1.release(0.2);

~my_first_synth1.set(\amp, 0.9);

~my_first_synth1.set(\freq, rrand(1, 5) * 220);


Как можно конструировать звук. Аддитивный.
...


======================================================
                  вложенные паттерны III
=======================================================


(
Pxrand(
	[
		Pbind(
			\instrument, \sin_synth_proto,
			\freq, Pser([1, 2, 3] * 110, inf).trace,
			\dur, Pser([1, 2, 3], 4)),
		Pbind(
			\instrument, \default,
			\freq, Pser([1, 2, 3] * 440, inf).trace,
			\dur, Pser([1, 2, 3] * 0.25, 4))
	],
	10
).play;
)


(
Pser(
	[
		Pbindef(
			\seq1_in_prand,
			\instrument, \sin_synth_proto,
			\freq, Pser([1, 2, 3] * 110, inf).trace,
			\dur, Pser([1, 2, 3], 4)
		),
		Pbindef(
			\seq2_in_prand,
			\instrument, \default,
			\freq, Pser([1, 2, 3] * 440, inf).trace,
			\dur, Pser([1, 2, 3] * 0.25, 4)
		)
	],
	inf
).play;
)

(
Pbindef(
	\seq1_in_prand,
	\freq, Pser([3, 2, 1] * 110, inf).trace,
)
)

======================================================
                  Типы движения
=======================================================

1. Монотонное в одну сторону. Когда доходит до конца, начинается снова

Pbindef(\prophet5pwmStrings).clear;

(
Pbindef(\prophet5pwmStrings,
	\instrument, "prophet5pwmStrings",
	// \note, Pseq([0, 3, 8, 7, 5, 8, 7, 3], inf),
	\note, Pseq((1, 3..14), inf),
	\ctranspose, -12,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], 1),
	\lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	\lforate, Pn(Pseries(2, 1, 11), inf),
	\rq, Pn(Pseries(0.9, -0.1, 5), inf)
).play;
);


1a С переменным шагом
Pwalk((1..12), stepPattern: Pser([1, 2], inf), directionPattern: 1).asStream.nextN(17)


Pbindef(\prophet5pwmStrings).clear;

(
Pbindef(\prophet5pwmStrings,
	\instrument, "prophet5pwmStrings",
	\note, Pwalk((12..1), stepPattern: Pser([1, 2], inf), directionPattern: 1),
	\ctranspose, -12,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], 1),
	\lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	\lforate, Pn(Pseries(2, 1, 11), inf),
	// \lforate, Pwalk((2..13), stepPattern: Pser([1, 2], inf), directionPattern: 1),
	\rq, Pn(Pseries(0.9, -0.1, 5), inf),
).play;
);

Pwalk((2..13), stepPattern: Pser([1, 2], inf), directionPattern: 1).asStream.nextN(15)


2. Возвратное.  Когда доходит до конца, идет в обратную сторону. Такое поведение характерно для периодической функции

(1, 3..17)++(16, 14..1)
Pseq((1, 3..17)++(16, 14..1), inf).asStream.nextN(30).plot;

Pwalk((1..12), stepPattern: Pseq([1, 2], inf), directionPattern: Pseq([-1, 1], inf)).asStream.nextN(28).plot


Pwalk((1..12), stepPattern: Pseq([1, 2], inf), directionPattern: Pseq([-1, 1], inf)).asStream.nextN(28).plot;


Очень симметричное движение быстро утомляет, так что хорошо делать ускорение или замедление каких-то параметров, напр., темпа. Будет "двойное впечатление": повторение и развитие.

Pbindef(\dist_guit_seq1).clear;

(
Pbindef(
	\dist_guit_seq1,
	    \instrument, "distortedGuitar",
	    \freq, (
		Pwalk(
			(1..12),
			stepPattern: Pseq([1, 2], inf),
			directionPattern: Pseq([-1, 1], inf)
		)
		+ 48).midicps.trace,
	    // \dur, 1,

	    \dur, (
			Pser([1, Prand([2, Rest(2)], 1), 3, 4, Prand([2, Rest(2)], 1)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)
		),

).clock_(~clck3).play;
)

Pbindef(\dist_guit_seq1).stop;


3. Хаотичное

Pwalk((1..12), stepPattern: Prand([-2, -1, 0, 1, 2], inf), directionPattern: Prand([-1, 1], inf)).asStream.nextN(17)


Pbindef(\rodes_seq4).clear;

(
Pbindef(
	\rodes_seq4,
	    \instrument, "everythingRhodes",
	    \freq, (
		Pwalk(
			(1..12),
			stepPattern: Pseq([1, 2], inf),
			directionPattern: Pseq([-1, 1], inf)
		)
		+ 48).midicps,
		\dur, Pwalk(
		  (1..12),
		  stepPattern: Prand([-2, -1, 0, 1, 2], inf),
		  directionPattern: Prand([-1, 1], inf)
	) * 0.05
,
).clock_(~clck3).play;
)

Pbindef(\rodes_seq4).stop;

==========================================
       Функции и последовательности
==========================================

Pseries(start, step, length) работает в точности как арифметическая последовательность, создавая для каждой новой ноты линейный прирост параметра

(
[
	Pseries(1, 3, inf).asStream.nextN(100),
	Pseries(1, 0.7, inf).asStream.nextN(100),
].plot;
)


функция совмещения графиков:
(
~plot_2_graph = {
	arg data1_arr, data2_arr;

	var combinedData = [data1_arr, data2_arr];
	var plotter = combinedData.plot("Сравнение роста функций");
	plotter.superpose = true;
	plotter.plotColor = [Color.blue, Color.red];
	plotter.refresh;
}
)

(
~plot_2_graph.(
	Pseries(1, 3, inf).asStream.nextN(100),
	Pseries(1, 0.7, inf).asStream.nextN(100)
);
)


Квадратичный\(f(x) = x^2\) Увеличивается на растущую сумму (+3, +5, +7...) Умеренно ускоряющаяся

В чистом виде «Pquad» паттерна нет, но квадратичный рост легко получить, если взять обычную арифметическую линию (Pseries) и возвести ее в квадрат через .pow(2) или просто ** 2.


(
~plot_2_graph.(
	Pseries(1, 3, inf).asStream.nextN(10),
	Pseries(1, 0.7, inf).pow(2).asStream.nextN(10)
);
)

// Pseries(1, 0.7, inf).asStream.nextN(10).plot


Pbindef(\prophet5pwmStrings).clear;

(
Pbindef(\prophet5pwmStrings,
	// \instrument, "prophet5pwmStrings",
	\freq, Pn(Pseries(440, 20, 10), inf).trace,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], inf),
	// \lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	// \lforate, Pn(Pseries(2, 1, 11), inf),
	// \rq, Pn(Pseries(0.9, -0.1, 5), inf),
).play;
);


440.pow(1/2)
(
Pbindef(\prophet5pwmStrings,
	\freq, Pn(Pseries(21, 1, 10).pow(2), inf).trace,
)
)

(
Pbindef(\prophet5pwmStrings,
	\freq, Pn(Pseries(440, 20, 10), inf).trace,
)
)

Pbindef(\prophet5pwmStrings).stop;



Экспоненциальный\(f(x) = 2^x\)  Геометрическая прогрессия Умножается на фиксированное число (*2, *2, *2...) Взрывная (эффект снежного кома)

// Начинаем с 100, умножаем на 1.5 на каждом шаге
Pgeom(start: 100, grow: 1.5, length: 6).asStream.nextN(6);
// Результат: [ 100, 150, 225, 337.5, 506.25, 759.375 ] -> Экспонента


Но сначала экспонента растет медленно
(
var steps = 15;
~plot_2_graph.(
	Pseries(1, 10, steps).asStream.nextN(steps),
	Pgeom(1, 1.21, steps).asStream.nextN(steps)
);
)

450/440

Pbindef(\prophet5pwmStrings).clear;

(
Pbindef(\prophet5pwmStrings,
	\freq, Pn(Pseries(440, 10, 10), inf).trace,
    \amp, 0.1,
	\dur, 0.5,
).play;
);


Pgeom(start: 440, grow: 1.022, length: 10).asStream.nextN(10);

(
Pbindef(\prophet5pwmStrings,
	\freq, Pn(
		Pgeom(
			start: 440,
			grow: 1.022,
			length: 10
		),
		inf
	).trace,
);
)


// Lets make Angine de Poitrine ))
(
Pbindef(\prophet5pwmStrings,
	\dur, Prand([
	  Pser([1, Rest(1/2), 3/4, 1/4, Rest(1/4)], 7),
	  Pser([1/2, 1/3, Rest(1/2), 2/3, 1/4, 1/4, 1/4, Rest(3/2)], 9)
    ], inf) * 0.25
);
)


// попробуем множитель 2.pow(1/12)
(
Pbindef(\prophet5pwmStrings,
	\freq, Pn(
		Pgeom(
			start: 440,
			grow: 2.pow(1/12),
			length: 10
		),
		inf
	).trace,
);
)

Pbindef(\prophet5pwmStrings).stop;


Pbindef(\amp_seq).clear;
(
Pbindef(
	\amp_seq,
	\instrument, "prophet5pwmStrings",
	\freq, 440,
	\amp, Pn(Pseries(0.05, 0.05, 20)).trace,
	\dur, 0.25
).play;
)
Pbindef(\amp_seq).stop;


(
Pbindef(\amp_seq,
	\amp, Pn(Pgeom(0.05, 1.18, 18)).trace
)
)

(
Pbindef(\amp_seq,
	\amp, Pn(Pseries(0.05, 0.05, 20)).trace,
)
)

Pgeom(0.05, 1.18, 18).asStream.nextN(18);


Децибел - это логарифм отношения двух величин, т.е. экспоненцияальной функции. Логарифм "приводит" экспоненту к почти линейной зависимости. Можно прибавлять, а не умножать.

SPL (Sound Pressure Level), уровень звукового давления. Измеряется эта величина в децибелах (дБ) и показывает, насколько громким является звук.

Формула уровня звукового давления (SPL) использует множитель 20

L_p = 20 * log10 (p / p_0)

где p_0 = 20 мкПа — порог слышимости человека.


Правило «10 децибел»
Увеличение на 10 дБ SPL воспринимается человеком как увеличение громкости в 2 раза (это равенство справедливо для средних частот и средней громкости).

•	+1 дБ — минимально заметное изменение громкости, которое тренированное ухо едва может уловить в идеальных условиях.
•	+3 дБ — отчетливо заметное изменение громкости для любого человека. Физически это требует удвоения мощности усилителя (двукратного увеличения Ватт).
•	+6 дБ — сильное увеличение громкости. Физически это означает удвоение звукового давления (Паскалей).
•	+10 дБ — субъективно воспринимается человеком как увеличение громкости ровно в 2 раза. Физически для этого требуется увеличить мощность усилителя примерно в 10 раз!



!!!
Чтобы начать расхождение (напр., между линейной и эксп. функциями) почти сразу, надо сдвинуть начало (напр., начать с 30 шага).
!!!
(
var steps = 15;
~plot_2_graph.(
	Pseries(30, 10, steps).asStream.nextN(steps),
	Pgeom(30, 1.21, steps).asStream.nextN(steps)
);
)



Функции, которые растут сначала быстро, а потом все медленнее и медленнее:
Степенная с показателем меньше 1, логарифм.

(
~plot_2_graph.(
	Pseries(1, 0.2, inf).asStream.nextN(30),
	Pseries(1, 1, inf).pow(1/2).asStream.nextN(30)
);
)


// Pn(Pseries(440.pow(2), 10000, 12).pow(1/2)).asStream.nextN(12)

Pbindef(\freq_seq_decreas).clear;
(
Pbindef(
	\freq_seq_decreas,
	\instrument, "prophet5pwmStrings",
	\freq, Pn(Pseries(440.pow(2), 10000, 12).pow(1/2)),
	\amp, 0.4,
	\dur, 0.25,
	\legato, 0.2,
).play;
)

// временно остановить
Pbindef(\freq_seq_decreas).pause;

// перезапустить с момента остановки
Pbindef(\freq_seq_decreas).resume;


Pbindef(\freq_seq_decreas).stop;



(
~plot_2_graph.(
	Pseries(1, 1, inf).log.asStream.nextN(30),
	Pseries(1, 1, inf).pow(1/2).asStream.nextN(30)
);
)



Убывающие функции

(
~plot_2_graph.(
	Pseries(1, -0.01, inf).asStream.nextN(50),
	Pseries(1, 0.05, inf).pow(-1).asStream.nextN(50)
);
)

(
Pbindef(\freq_seq_decreas,
	\freq, Pn(Pgeom(660, 0.85, 12)).trace
)
)

...


============================================
             придумываем свою функцию
============================================
(
~sin_my = {
	arg in;
	sin(2 * in) / 10;
}
)

~sin_my.(Pseries(1, 0.01, inf).asStream.nextN(1000)).plot;

(
~plot_2_graph.(
	Pseries(1, 3, inf).asStream.nextN(10),
	~sin_my.(Pseries(1, 0.7, inf).asStream.nextN(10))
);
)


// можно просто функции в паттерне использовать
~limit = 10;

(
Pbind(
	\freq, Pfunc({
		~limit = rrand(1, 10);
	}).trace,
).play;
)

(
Pbind(
	\freq, Pfunc({
		rrand(1, ~limit) * 220;
	}).trace,
).play;
)


=======================================================
               Построение графиков онлайн
=======================================================

wolfram mathematica online plot https://www.wolframalpha.com/examples/mathematics/plotting-and-graphics


======================================================
                   Масштабирование
 ======================================================

Pbindef(\scale_seq).clear;
(
Pbindef(\scale_seq,
	\freq, Pser([1, 2, 3, 4], inf).linlin(1, 4, 440, 880).trace,
).play;
)

/*
.linlin(inMin, inMax, outMin, outMax, clip: 'minmax')
.linexp(inMin, inMax, outMin, outMax, clip: 'minmax')
.explin(inMin, inMax, outMin, outMax, clip: 'minmax')
.expexp(inMin, inMax, outMin, outMax, clip: 'minmax')
*/

===================================================
            MIDI In
===================================================

(
var notes, on, off;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
    notes[num] = Synth(\default, [\freq, num.midicps,
        \amp, veloc * 0.00315]);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    notes[num].release;
});

q = { on.free; off.free; };
)

(
~cc1 = MIDIFunc.cc({|val, ccNum, chan, src|
    val.postln; //this totally works!
    // ~synth.set(\cc1, val / 127);
}, ccNum:1);
)

// when done:
q.value;


управлять синтезатором который работает в pattern
надо в шину направлять

// 2. Создаем шину для управления (например, для частоты среза фильтра)
~cutoffBus = Bus.control(s, 1);
~cutoffBus.set(800); // начальное значение

// 3. Создаем MIDIFunc для чтения CC-сообщений
// Замените ccNum на номер вашей ручки/ползунка на MIDI-контроллере
MIDIFunc.cc({ |val, num, chan, src|
    // Масштабируем значение MIDI (0-127) в диапазон частоты фильтра (200 - 10000 Гц)
    var freq = val.linexp(0, 127, 200, 10000);
    ~cutoffBus.set(freq);
}, ccNum: 1); // 1 — это обычно колесо модуляции (ModWheel)


~pattern = Pbind(
    \instrument, \pattMidi,
    \dur, 0.25,
    \degree, Pseq([0, 2, 4, 7, 4, 2], inf),
    // Привязываем аргумент синтезатора к нашей MIDI-шине:
    \fftCutoff, ~cutoffBus.asMap,
    \amp, 0.15
).play;


===================================================
          Отложенный старт/ стоп
===================================================


~form_clck = TempoClock.new(1);

// method "sched" of "TempoClock" object starts function after N seconds
// TempoClock -> sched(N, { function })
// If last string of function returns number M, function will be retarted after M seconds
(
~form_clck.sched(3, {
	"bang".postln;
});
)

(
~metro_part2 = TempoClock.new(2); // metronome for "drum2_part" to 2 beat per second (PBS)

~metro_form.sched(30, {
	"Start B".postln;
	// after 30 beats from begin

	// start part2
	~drum2_part = Pbind(
		\instrument, \oneclap_thor,
	).play(~metro_part2);
});

~metro_form.sched(90, {
	~metro_form.stop;
	~drum2_part.stop;
	"End of piece".postln;
});
)


Этот пример проигрывает ноты ровно 4 бита, а затем останавливается, даже если последовательность нот могла бы продолжаться дальше.

~clck3 = TempoClock.new(120/60);

(
Pfindur(4,
  Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq(
		[
			1,
				Pxrand([Rest(1/4), 1/2, 2/3, Rest(2/3)], 2),
			1,
			Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
		], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
  )
).play(~clck3);
)

~clck3.tempo = 2;


===================================================
          Различные случайные распределения
===================================================

///////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

(
~plot_2_graph.(
	Pwhite(0, 7, inf).asStream.nextN(1000).histo,
	Pwhite(0, 7, inf).asStream.nextN(1000).histo
);
)

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

(
~plot_2_graph.(
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo,
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo
);
)


Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution


// linear disributions
Plprand(0, 7, inf).asStream.nextN(1000).histo.plot;


(
~plot_2_graph.(
	Pwhite(0, 7, inf).asStream.nextN(1000).histo,
	Plprand(0, 7, inf).asStream.nextN(1000).histo
);
)


Phprand(0, 7, inf).asStream.nextN(1000).histo.plot;


// use it for contrast between of parts of musical form
//
// part A
(
Pbind(
	\degree, Phprand(1, 10, inf).trace,
).play;
)

// part B
(
Pbind(
	\degree, Plprand(1, 10, inf).trace,
).play;
)


// gaussian (normal) distribution
Pgauss(4, 1, inf).asStream.nextN(1000).histo.plot;


(
~plot_2_graph.(
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo,
	Pgauss(4, 1, inf).asStream.nextN(1000).histo
);
)


Pexprand(0.01, 7.0, inf).asStream.nextN(1000).histo.plot;


Pgbrown(0.01, 7.0, 0.05, inf).asStream.nextN(1000).histo.plot(discrete: true); // make some plots to see different forms of the distribution

{1.0.linrand }.dup(10000).histo(1000).plot(discrete: true); // function repeats 10000 times, linear distribution

{1.0.bilinrand }.dup(10000).histo(1000).plot(discrete: true); // gaussian-like distribution


==============================================
             Огибающие в паттернах
==============================================
(
Pbind(
    \note, Env(
            levels: [0, 0.1, 0.2, 0.3] * 12,
            times: [0.1, 0.1, 0.1] * 20,
            curve: 8,
		    loopNode: 1
        ),
    \dur, 0.1
).play;
)
// не повторяется

(
Pbind(
    \note, Pseg(Pseq([1, 5], inf), Pseq([4, 1], inf), \linear),
    \dur, 0.1
).play;
)

// это не работает, поскольку Pseg связан с таймером, а plot работает в своем режиме
Pseg(Pseq([1, 5], inf), Pseq([4, 1], inf), \linear).asStream.nextN(10).plot("Pattern from random");


================================================
              Повторение
================================================

(
Pdef(
	\arithm,
	Pbind(
		\dur, Pclutch(
			Prand(((1..5)**2*0.1) ++ Rest(1), inf),
			0.7.coin.binaryValue
		).trace,
	),
).stop;
)


~test_clk = TempoClock.new(1);
~test_clk.beats;

(
Pdef(\test_ptrn_pl,
	Pbind(
		\degree, Prand(
			// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
			//([0, 0, 0, 0] + {rrand(1, 7)}),
			//(1 .. 20).clump(4),
			(1 .. 20).clump(4).lace(20).clump(4),
			inf
		),
		\dur, Prand((1 .. 6) * 0.25, inf),
		\strum, Pwhite(0.05, 0.5, inf),
		\legato, Pexprand(0.1, 1, inf),
		// \instrument, \cheappiano,
		\scale, Scale.choose,
		\amp, Pexprand(0.001, 0.3, inf),
	).trace
).play(~test_clk);
)

~test_clk.tempo = 0.3

(
Pdef(\test_ptrn_pl).stop;
~test_clk.stop;
)

=============================================
         lace, clump
=============================================

x = [ [1, 2, 3], 6, List["foo", 'bar']];
y = x.lace(12);
x.postln;
y.postln;

-> [ [ 1, 2, 3 ], 6, List[ foo, bar ] ]
-> [ 1, 6, foo, 2, 6, bar, 3, 6, foo, 1, 6, bar ]

(1 .. 20).clump(4).lace(20).clump(4)



//////////////////////////////////
//
//      Envelopes
==============================================
               Огибающие
==============================================



(
Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).test;
)

(
Env.perc(
	).plot;
)

(
Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).plot;
)

// using it in synth
(
{
	arg attk = 0.05, rel = 0.1;
	WhiteNoise.ar(0.1) * Env.perc(
		attackTime: attk,
		releaseTime: rel
	).kr(doneAction: 2); // kr(doneAction: 2) turns Envelope on and off correctly
}.asSynthDef(name: \noise__proto).add; // no need for fadeTime
)

// see waveform
(
{
	arg attk = 0.05, rel = 0.1;
	WhiteNoise.ar(0.1) * Env.perc(
		attackTime: attk,
		releaseTime: rel
	).kr(doneAction: 2);
}.plot(0.2);
)

~noise = Synth(\noise__proto); // try


(
Pdef(
	\noise__pl,
	Pbind(
		\instrument, \noise__proto,
		\dur, 0.25,
		\attk, Pdefn(
			\attk_at_noise__pl,
			Pwhite(0.01, 0.1, inf)
		),
	)
).play;
)


// change attack by sinus
~clck1 = TempoClock.new(1);

(
Pdefn(
	\attk_at_noise__pl,
	Pfunc({
		sin(~clck1.beats).linlin(-1, 1, 0.01, 0.1);
	})
	)
)

Масштабирование
Pbindef(\scale_seq).clear;
(
Pbindef(\scale_seq,
	\freq, Pser([1, 2, 3, 4], inf).linlin(1, 4, 440, 880).trace,
).play;
)

/*
.linlin(inMin, inMax, outMin, outMax, clip: 'minmax')
.linexp(inMin, inMax, outMin, outMax, clip: 'minmax')
.explin(inMin, inMax, outMin, outMax, clip: 'minmax')
.expexp(inMin, inMax, outMin, outMax, clip: 'minmax')
*/

// gate start-stop

(
{
	arg gate = 1, freq = 440;
	var feedback_mod = LFNoise2.kr(1) * 1.9;
	SinOscFB.ar(freq, 0.1 * 2 * 3.14 * feedback_mod) * 0.2 *
	Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).kr(doneAction: 2, gate: gate);
}.asSynthDef(name: \fb_sin_adsr__proto).add;
)

~fb_sin_adsr__proto = Synth(\fb_sin_adsr__proto); // start
~fb_sin_adsr__proto.set(\freq, 220); // change
~fb_sin_adsr__proto.set(\freq, 880);


~fb_sin_adsr__proto.set(\gate, 0); // stop
// ~fb_sin_adsr__proto.release(); gives same effect


///////////////////////////
// "iterable" data types

[1, 10, 100].class;     // Вернет: Array

List[1, 10, 100].class; // Вернет: List


~arr1 = [1, 10, 100];
(
~arr1.do({
	arg ...args_arr;
	args_arr.postln;
});
)

(
~midi_seq_arr = Array.fill(10, {
	arg i;
	i*2 + 60;
});
)

(
Pdef(
	\add_synth_percussion__play,
	Pbind(
		\instrument, \add_synth_percussion_proto,
		\midinote, Pseq(~midi_seq_arr, 1),
	)
).quant_(1).play;
)


(
{
	arg freq;
	10* Mix.fill(5, {
		arg i;
		Resonz.ar(
			WhiteNoise.ar(0.1),
			freq * (i + 1),
			bwr: 0.01,
		)
	});
}.asSynthDef(fadeTime: 0.3, name: \substr_example__proto).add;
)


(
Pdef(
	\substr_example__play,
	Pbind(
		\instrument, \substr_example__proto,
		\midinote, Pdefn(
			\substr_example_at_midinote, Pseq(~midi_seq_arr, inf)
		).trace,
		\dur, Pdefn(\substr_example_at_dur, 0.5),
	)
).quant_(1).play;
)

(
Pdefn(
	\substr_example_at_midinote,
	Pfunc({
			~midi_seq_arr.choose;
		})
)
)

{~midi_seq_arr.choose}.dup(1000).histo.plot;

//////////////////////////////////
//
//      discrete random distribution


// we want 2nd and 5th number to have a higher probability
~midi_seq1_arr = [1, 2, 4, 5, 7, 9];
~midi_seq1_weigth_arr = [10, 20, 30, 10, 10, 30].normalizeSum;


{~midi_seq1_arr.choose}.dup(1000).histo.plot; // equal discrete  distr

{~midi_seq1_arr.wchoose(~midi_seq1_weigth_arr)}.dup(1000).histo.plot; // weighted discrete distr

~midi_seq1_arr.scramble; // change elements which will appear more frequently


//////////////////////////////////
//
//      markov chain

// we want dictr that "remember" step before this
// it's "contitional random"

/*
markov table

   A   B   C   D
A  10  20  30  10 // C appears after A more frequently then D
B  10  10  20  30
C  30  10  10  20
D  20  30  10  10

Values [A, B, C, D] are in an array. We want Markov process say us index of next elemet by index of current element.

Markov process (MP) find current value in the vertical list, then takes its index. Then MP brings correspondent string - it becomes array of weigth. With "windex" function MP finds index of next element, it's like "wchoose" but returns an index itself.
*/

(
~dur_arr = [1,   2,   4 ,  6] * 0.25; // our elements

~curr_index = 0; // default value

~markov_arr = [
	[10,  20,  30,  10].normalizeSum,
	[10,  10,  20,  30].normalizeSum,
	[30,  10,  10,  20].normalizeSum,
	[20,  30,  10,  10].normalizeSum
];
)

(
~curr_index = ~markov_arr[~curr_index].windex; // get next index and save it
~dur_arr[~curr_index]; // get next elenemt by this index
)


(
Pdef(
	\fb_sin__player,
	Pbind(
		\instrument, \fb_sin__proto,
		// \freq, Pser([1, 2, 4, 1] * 440, inf),
		\degree, Pdefn(
			\degree_at_fb_sin__player,
			Pser([1, 2, 4, 1], inf)
		),
		\dur, Pfunc({
			~curr_index = ~markov_arr[~curr_index].windex;
			~dur_arr[~curr_index];
		}),
		\legato, 0.8,
	)
).play;
)

//////////////////////////////////////////////////
// array - for store "things" of the same type
// like MIDI sequence or patterns

// We can make array by place "things" in [] separated by comma
(
~test_arr  = [
	Pbind(),
	Pbind(
		\dur, 0.5,
    ),
	Pbind(
		\degree, [0, 2, 4]
	)
    ]
)

// show all "things" in array
(
~test_arr.do({
	arg item;
	item.postln;
})
)


// take one "thing" from array by index
// arrays are zero-based
~test_arr[1].play;
~test_arr[2].play;

// lets make TempoClock.sched to turn on/ off patterns
...
...


// ==========================================
//             types of musical texture
//             типы музыкальной фактуры
// ==========================================

// melody
(
Pbind(
	\instrument, \var_saw_proto,
	\degree, Prand((0..8), inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(((1..6) ++ [Rest(2), Rest(4)]) * 0.25, inf),
).play;
)

// accords
(
Pbind(
	\instrument, \sin_sum_proto,
	// \degree, Prand((0..8), inf).clump(3),
	\degree, Ptuple([
		Prand((-3..4), inf),
		Pseq([5, 7, 8], inf),
		Prand((8..12), inf),
	], inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(([2, 4, 6] ++ [Rest(2)]), inf),
).play;
)

// line movement
(
Pbind(
	\instrument, \var_saw_proto,
	\note, Pwalk((1..12), 1, 1, 7).trace, // chromatic movement, up direction
	// \note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7), // up-down direction
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace, // step variation
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace, // random direction
	\amp, Pwalk((1..8) * 0.1, 1, Prand([-1, 1]), 3),
	\dur, 0.25,
).play;
)



///////////////////////////////////////
//
//       feedback, chaos
//
////////////////////////////////////////

// but for using in patterns we must make it synth
(
{
	arg freq = 440; // inputs of synth
	// we can send values from Pbind by arg's name
	// for ex., \freq, 220,

	var feedback_mod = LFNoise2.kr(1) * 1.9;
	SinOscFB.ar(freq, 0.1 * 2 * 3.14 * feedback_mod ) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \fb_sin__proto).add;
)


(
// as a frequency control
{ SinOsc.ar(
	HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	)*800+900
)
* 0.04 ! 2 }.scope();
)

LatoocarfianL

(
{
HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	);
}.scope;
)

FBSineC

{ SinOsc.ar(Lag.ar(LorenzL.ar(MouseX.kr(1, 200)), 3e-3)*800+900)*0.4 }.play(s);

{ SinOsc.ar(StandardL.ar(40, MouseX.kr(0.9, 4))*800+900)*0.4 }.play(s);


Logistic


//////////////////////////
//
// Change data between synth by Bus.control


// ....

//////////////////////////
//
// Change data between synth by OSC


s.boot;

// Создаем синт, который отсылает значение генератора 10 раз в секунду (Impulse.kr)
(
x = {
    // var freq = LFNoise2.kr(10).range(200, 1000); // Генерируем случайную частоту
	var freq =
	  HenonC.ar(
		0.3,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	  )*800+900
    ;

    // Отправляем 'freq' на клиент по команде '/my_frequency'
    SendReply.kr(Impulse.kr(10), '/my_frequency', freq);
    // SinOsc.ar(freq) * 0.1;
}.play;
)

// Регистрируем OSC-обработчик на клиенте
(
~oscFunc = OSCFunc({ |msg|
    var frequency = msg[3]; // Значения начинаются с 3-го индекса
    ("Полученное значение частоты:" + frequency).postln;
	~additive_example1.set(\freq, frequency);
}, '/my_frequency').add;
)

// Очистка
~oscFunc.free;
x.free;


~additive_example1 = Synth(\additive_example__proto, args: [\freq, 220 + (10.rand * 20)]);


~additive_example1.set(\freq, 220 + (10.rand * 20));


~additive_example1.release;

//////////////////////////

(
{ SinOsc.ar(StandardL.ar(40, MouseX.kr(0.9, 4))*800+900)*0.4 }.asSynthDef(fadeTime: , name: \standard_control__proto).add;
)


/////////////////////////

NetAddr.langPort;

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off

~substr_example = Synth(\additive_example__proto, args: [\freq, 440]);


(
// 1. Слушатель ТОЛЬКО для высоты тона первого синтезатора
OSCdef(\pitchListener, { |msg|
    // var pitchValue = msg[3]; // Берем полезные данные
	var freq;
	freq = msg.midicps;
	freq.postln;
	~substr_example.set(\freq, freq);
    // "Синтезатор 1 сменил ноту на: %".format(pitchValue).postln;
    // Здесь ваш код для изменения паттерна или графики

}, '/synth1/pitch'); // Жестко привязан к этому пути


// 2. Слушатель ТОЛЬКО для громкости второго синтезатора
OSCdef(\ampListener, { |msg|
    var ampValue = msg[3]; // Берем полезные данные

    "Синтезатор 2 сменил громкость на: %".format(ampValue).postln;
    // Здесь ваш код управления громкостью

}, '/synth2/amp'); // Жестко привязан к этому пути
)

~substr_example.release;

//////////////////////////////
//
// OSC send


~remote_port = 65535
~remote_ip = 1.2.3.4

// send message to remote
b = NetAddr.new(~remote_ip, ~remote_port);    // create the NetAddr
b.sendMsg("/fader1", 0.5);
b.free;


//////////////////////////////
//
// legato, arpeggiato (strum)

~test_clk = TempoClock.new(1);
~test_clk.beats;

(
Pdef(\test_ptrn_pl,
	Pbind(
		\degree, Prand(
			// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
			//([0, 0, 0, 0] + {rrand(1, 7)}),
			//(1 .. 20).clump(4),
			(1 .. 20).clump(4).lace(20).clump(4),
			inf
		),
		\dur, Prand((1 .. 6) * 0.25, inf),
		\strum, Pwhite(0.05, 0.5, inf),
		\legato, Pexprand(0.1, 1, inf),
		// \instrument, \cheappiano,
		\scale, Scale.choose,
		\amp, Pexprand(0.001, 0.3, inf),
	).trace
).play(~test_clk);
)

~test_clk.tempo = 0.3

(
Pdef(\test_ptrn_pl).stop;
~test_clk.stop;
)

================================================
дополнения
================================================

(
{
	"test fork".postln;
	3.wait;

	rrand(1, 11).postln;
	Pdef(\test_ptrn_pl,
		Pbind(
			\degree, Prand(
				// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
				//([0, 0, 0, 0] + {rrand(1, 7)}),
				(1 .. 20).clump(4),
				inf
			)
		).trace
	).play;
	10.wait;

	"end function fork".postln;
	Pdef(\test_ptrn_pl).stop;
}.fork;
)

================================


нельзя использовать индекс, который больше или равен размера массива
чтобы не проверять, можно вместо [] использовать методы:
.clipAt(index)
.wrapAt(index)
.foldAt(index)


rotate(n: 1) // перестановка элементов в массиве

.reshape( ... shape) //

.windex //Interprets the array as a list of probabilities which should sum to 1.0 and returns a random index value based on those probabilities.



==============================================
итеграция в VS code
==============================================
/*
vscode-supercollider (originally developed by scztt and maintained via community contributors). It uses the Language Server Protocol (LSP) to communicate directly with SuperCollider (sclang).


FluCoMa Gerard Roma
*/
