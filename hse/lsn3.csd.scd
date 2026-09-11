Функции и последовательности

Pseries(start, step, length) работает в точности как арифметическая последовательность, создавая для каждой новой ноты линейный прирост параметра

(
[
	Pseries(1, 3, inf).asStream.nextN(100),
	Pseries(1, 0.7, inf).asStream.nextN(100),
].plot;
)



Квадратичный\(f(x) = x^2\) Увеличивается на растущую сумму (+3, +5, +7...) Умеренно ускоряющаяся

В чистом виде «Pquad» паттерна нет, но квадратичный рост легко получить, если взять обычную арифметическую линию (Pseries) и возвести ее в квадрат через .pow(2) или просто ** 2.



Экспоненциальный\(f(x) = 2^x\)  Геометрическая прогрессия Умножается на фиксированное число (*2, *2, *2...) Взрывная (эффект снежного кома)

// Начинаем с 100, умножаем на 1.5 на каждом шаге
Pgeom(start: 100, grow: 1.5, length: 6).asStream.nextN(6);
// Результат: [ 100, 150, 225, 337.5, 506.25, 759.375 ] -> Экспонента


Строим графики в одном окне
(
var steps = 15;
var linearData = Pseries(30, 10, steps).asStream.nextN(steps);
var geomData   = Pgeom(30, 1.21, steps).asStream.nextN(steps);

// 1. Просто кладем два массива в один, БЕЗ .flop
var combinedData = [linearData, geomData];

// 2. Строим график
var plotter = combinedData.plot("Сравнение роста функций");

// 3. Включаем наложение
plotter.superpose = true;

// 4. Задаем цвета для ДВУХ линий (синяя и красная)
plotter.plotColor = [Color.blue, Color.red];

plotter.refresh;
)


!!!
Чтобы начать расхождение (напр., между линейной и эксп. функциями) почти сразу, надо сдвинуть начало (напр., начать с 30 шага).
!!!



А есть ведь функции, которые растут сначала быстро, а потом все медленнее и медленнее?


Да, такие функции и паттерны существуют. В математике этот тип роста называется затухающим, сублинейным или логарифмическим.





==============================================
Огибающие
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


===================================================
           Вложенные паттерны II
===================================================


// p = Pxrand([
// 	Pbind( ... ,
// 		Pbind( ... ,
// 			...
// 	], inf).play;


/////////////////////////////////////
// Ppar and Pspawner


===================================================
          Отложенный старт/ стоп
===================================================
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

lace

x = [ [1, 2, 3], 6, List["foo", 'bar']];
y = x.lace(12);
x.postln;
y.postln;

-> [ [ 1, 2, 3 ], 6, List[ foo, bar ] ]
-> [ 1, 6, foo, 2, 6, bar, 3, 6, foo, 1, 6, bar ]

(1 .. 20).clump(4).lace(20).clump(4)


==============================================
итеграция в VS code
==============================================
/*
vscode-supercollider (originally developed by scztt and maintained via community contributors). It uses the Language Server Protocol (LSP) to communicate directly with SuperCollider (sclang).


FluCoMa Gerard Roma
*/
