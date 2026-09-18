SCLOrkSynths.gui;


===================================================
           Вложенные паттерны II
===================================================

Pbindef(\seq3).clear;

~clck3 = TempoClock.new(120/60);

(
Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq([1, 1, 1, Rest(1)], inf),
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).clock_(~clck3).play;
)

Pbindef(\seq3).stop;

(
Pbindef(
	\seq3,
	\amp, 0.8
)
)

(
Pbindef(
	\seq3,
	\dur, Pseq([1, 1, 1, Prand([1, Rest(1), Rest(1/2)], 1)], inf).trace
)
)


(
Pbindef(
	\seq3,
	\dur, Pseq([
		1,
		Prand([1/2, 1/4, 3/4, Rest(1/4)], 2),
		1,
		Prand([1, Rest(1), Rest(1/2), 1/2], 1)
	], inf).trace
)
)

(
Pbindef(
	\seq3,
	\dur, Prand([
		Pseq([1, 1, 1, Rest(1)], {rrand(1, 3)}),
		Pseq([1/2, Rest(1/4), 1/4, 1/2, 3/4, Rest(1/4)], 2),
		Pseq([Rest(3/4), 1/8, 1/4, Rest(2/3), 3/8, 1/4], 1),
	], inf).trace;
)
)

Случайность на уровне формы
// p = Pxrand([
// 	Pbind( ... ,
// 		Pbind( ... ,
// 			...
// 	], inf).play;

(
Pdef(\movements4_ptrn_pl,
	Pxrand(
		[
			Pbind(\degree, Pseq([0, 2, 4, 6], 3)),
			Pbind(\degree, Prand([0, 0.1, 1, 1.1] + 2, 5)),
			Pbind(
				\degree, Pseries({rrand(0, 7) - 8}, 1, {rrand(5, 15)}),
				\dur, Pxrand((1 .. 5) * 0.25, inf)
			),
		], inf
	);
).stop;
)

/////////////////////////
//
// random sequence without repeats
// Pshuf: Shuffles an array once and repeats that specific shuffled order.


/////////////////////////////////////
// Ppar and Pspawner


Вариация числа голосов
(
Pdef(
	\seq_rand,
	Pbind(
		\degree, Pseq(
			[Prand([
				Pseq([-2, -4, -6], 1),
				0,
				1,
				1.1,
				Pseq([-1.1, -3.1, -5.1, -6], 1),
				Ptuple([
					Pwhite(6, 15, 1),
					Pwhite(-3, 5, 1)
				], 6) // аакорды
			], 1), 2, 4, 6], inf
		).trace;
	),
).stop;
)


Последовательно из нескольких источников
Place(#[1, [2,5], [3, 6]], inf).asStream.nextN(10);

(
Place(#[1, [[2, -2], 5], [3, 6]], inf).asStream.nextN(10);
)

(
Place([
	Prand((1, 3..12), 1), // случайная нота
	[[2, -2], 5], // аакорд, в след. раз 5 ступень
	[
		Ptuple([
			Pwhite(-10, -5, 1),
			Pwhite(-15, -10, 1)
		], 2),
		3
	] // случаный аакорд, в следующий раз 3 ступень
  ], inf).asStream.nextN(20);
)


Фольклор

Pbindef(\weird_seq1).clear;
(
Pbindef(
   \weird_seq1,
   \dur, 0.25
).play;
)

(
Pbindef(
	\weird_seq1,
	\degree,
	Place([
	Prand((1, 3..12), 1), // 1st voice
	[[2, -2], 5], // 2nd voice
	[
		Ptuple([
			Pwhite(-10, -5, 1),
			Pwhite(-15, -10, 1)
		], 2),
		3
	] // 3rd voice
  ], inf)
);
)

(
Pbindef(
   \weird_seq1,
	\dur, Prand([
		Pser([1/2, 1, 1/2, 3/2, 3, 1, Rest(3)], 1) * 0.25,
		Pser([1, 1, 1, Rest(3/2), 1/3, 2/3, 2/3, Rest(3)], 1) * 0.25,
	], inf)
)
)

Pbindef(\weird_seq1).stop;


Разннобразное движение снимает фольклорность
(
Pdef(\movements3_ptrn_pl,
	Pbind(
		\degree, Prand([
			Prand((0 .. 7) + 12, rrand(5, 10)), //random high
			Prand((0 .. 7), rrand(5, 10)), //random middle
			Prand((0 .. 7) - 12, rrand(5, 10)), //random low
			Pseries({rrand(0, 7)}, 1, {rrand(5, 15)}), // step up
			Pseries({rrand(0, 7)}, -1, {rrand(5, 15)}), // step down
			Prand(

					[
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					]

				, rrand(5, 10)
			), // pedal
		], inf).trace,
		\dur, 0.25
	);
).stop;
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

Сравним:
Pn(Pseries(0.0, 0.025, 7), inf).asStream.nextN(10)
и
Pseries(0.0, 0.025, inf).asStream.nextN(10)


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

Pwalk((1..12), stepPattern: Pseq([1, 2], inf), directionPattern: Pseq([-1, 1], inf)).asStream.nextN(28)


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


функция совмещения графиков

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

Pbindef(\prophet5pwmStrings).clear;

(
Pbindef(\prophet5pwmStrings,
	// \instrument, "prophet5pwmStrings",
	\freq, Pn(Pseries(21, 1, 10).pow(2), inf).trace,
	// \note, Pwalk((12..1), stepPattern: Pser([1, 2], inf), directionPattern: 1),
	// \ctranspose, -12,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], 1),
	\lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	\lforate, Pn(Pseries(2, 1, 11), inf),
	\rq, Pn(Pseries(0.9, -0.1, 5), inf),
).play;
);

2.pow(1/12)
440.pow(1/2)

Pn(Pseries(440, 1, 10), inf).asStream.nextN(20)

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
	// \instrument, "prophet5pwmStrings",
	\freq, Pn(Pseries(440, 10, 10), inf).trace,
	// \note, Pwalk((12..1), stepPattern: Pser([1, 2], inf), directionPattern: 1),
	// \ctranspose, -12,
	\amp, 0.1,
	\dur, 0.5,
	// \lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	// \lforate, Pn(Pseries(2, 1, 11), inf),
	// \rq, Pn(Pseries(0.9, -0.1, 5), inf),
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


Децибел - это логарифм отношения двух величин, т.е. экспоненцияальной функции. Логарифм "приводит" экспоненту к почти линейной зависимости. Можно прибавлять, в не умножать.

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

Pbindef(\freq_seq_decreas).pause;
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


Построение графиков онлайн
wolfram mathematica online plot https://www.wolframalpha.com/examples/mathematics/plotting-and-graphics



===================================================
          Синтез звука
===================================================


{SinOsc.ar()}.play;

Какие недостатки у такого синтезатора?

...

Быстрый конструктор синта
(
{
	SinOsc.ar();
}.asSynthDef(fadeTime: 0.1, name: \my_first_synth__proto).add;
)


(
Pbindef(\freq_seq_decreas, \instrument, \my_first_synth__proto);
)


Рандом в синтах
Rand  It generates this when the SynthDef first starts playing, and remains fixed for the duration of the synth's existence.

(
{
	SinOsc.ar(Rand(1, 5) * 220);
}.asSynthDef(fadeTime: 0.1, name: \sin_freq_rnd__proto).add;
)

Pbindef(\freq_seq_decreas, \instrument, \sin_freq_rnd__proto);



Параметры в паттернах
...


Ручной запуск
...

~my_first_synth1 = Synth(\my_first_synth__proto);

~my_first_synth1.run(0);
~my_first_synth1.run(1);

~my_first_synth1.release(0.2);

~my_first_synth1.set(\freq, 330);


Отображение экземпляров синта
s.plotTree;

Отображение проектов (прототипов) синтов
SynthDescLib.global.browse;


Как можно конструировать звук. Аддитивный.
...




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

/*MIDIFunc.cc({|val, ccNum, chan, src|
    val.postln; //this totally works!
    ~synth.set(\cc1, val / 127);
}, ccNum:1);*/

q = { on.free; off.free; };
)

// when done:
q.value;

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


==============================================
Огибающие
==============================================





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
