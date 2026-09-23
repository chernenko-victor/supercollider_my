SCLOrkSynths.gui; // загружаем библиотеку

// Паттерны
// https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.html

===================================================
           Вложенные паттерны II
===================================================

~clck3 = TempoClock.new(120/60);


(
Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq([1, 1, 1,
		Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
	], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).clock_(~clck3).play;
)

// вывод первых 10 значений паттерная в консоль
Prand([1, Rest(1/2), 2, Rest(1/4)], inf).asStream.nextN(10);

Pbindef(\seq3).stop;

Pbindef(\seq3).clear; // обнуляет предыдущие изменения

// меняем только один из параметров
(
Pbindef(
	\seq3,
	\amp, 0.8
)
)

// Prand внутри Pseq
// три фиксированные длительности и одна рандомная
(
Pbindef(
	\seq3,
	\dur, Pseq([
		1,
		1,
		1,
		Prand(
		  [1, Rest(1), Rest(1/2)], 1
		)
	], inf).trace
)
)

// вложенные паттерны должны быть конечными
// иначе до них дойдет очерень и дальше не продвинется

// половина длительностей рандомная
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

// Pseq внутри Prand
// случайный вибор секвенции
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
			Pbind(
				\instrument, \distortedGuitar,
				\degree, Pseq([0, 2, 4, 6], 3)),
			    \dur, Pseq([Pn(1/8, 3), 1/2, 1/8, 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, 3/8, 3/8, 3/8, 1/2]),
			Pbind(\degree, Prand([0, 0.1, 1, 1.1] + 2, 5)),
			Pbind(
				\instrument, \FMRhodes1,
				\degree, Pseries({rrand(0, 7) - 8}, 1, {rrand(5, 15)}),
				\dur, Pxrand((1 .. 5) * 0.25, inf)
			),
		], inf
	);
).stop;
)


Pseq([Pn(1/8, 3), 1/2, 1/8, 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, 3/8, 3/8, 3/8, 1/2]).asStream.nextN(10)

/////////////////////////
//
// random sequence without repeats
// Pshuf: Shuffles an array once and repeats that specific shuffled order.

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
			], 1),
			2,
			4,
			6], inf
		).trace;
	),
).stop;
)


// Как смотреть результат работы паттернов (иногда не работает, но в 95% работает)
//
// .asStream - covert pattern to stream
// .nextN(100) - covert stream to array with 100 elements
// .plot - show array with indexies on horizontal axis and elements' values on vertical

Prand([0, 2, 4, 6, 8], inf).asStream.nextN(1000).histo.plot; // Histogram  shows the number of occurrences of each element in array [0, 2, 4, 6, 8]. Compare with:



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


Фольклорный оттенок

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

// более "хитрый" ритм уменьшает впечатление фольклорности
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


Также разннобразное движение снимает фольклорность
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

/*
Задание для самостоятельной работы

1. Подключите виртуальный или железный синтезатор, который управляется по MIDI.

2. а) Сделайте партию для внешнего синтезатора, меняйте ее с помощью Pbundef.
б) Напишите несколько паттернов с вложенными паттернами
в) Напишите несколько паттернов для 1-2 синтов из библиотеки SCLOrkSynths, запишите в аудио файл
в) Запишите синтезатор, сведите его с записанными партиями синтов SCLOrkSynths.
*/