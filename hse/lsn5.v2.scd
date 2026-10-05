SCLOrkSynths.gui; // загружаем библиотеку  и сервер

s.plotTree; // окно для отображения экземпляров синтов


так тоже можно, но не получится использовать в паттернах
(
{
	LFTri.ar() * 0.2;
}.play;
)

// угадайте какой будет результат в supercilloder ))
1 + 2 * 3


надо для арифм. операций расставлять все скобки
(
{
	arg freq = 440, amp = 0.4; // два входа
	var sig = SinOsc.ar(freq) * amp; // меняем амплитуду
	// добавляем гармоники
	sig = sig + (SinOsc.ar(2 *freq) * amp/2);
	sig = sig + (SinOsc.ar(3 *freq) * amp/3);
	sig = sig + (SinOsc.ar(4 *freq) * amp/4);
	sig.scope;
	Limiter.ar( // на всяк случай лимитируем выход по -0.4 dB
		sig, // входной сигнал
		level: dbamp(-0.4) // переводми децибелы в rms
	);
}.asSynthDef(fadeTime: 0.1, name: \sin_synth_proto).add;
)

asSynthDef - метод для автодополнения функции до синта
add - метод для добавления проекта синта на сервер

теперь его можно юзать в паттернах

а можно вызывать отдельно
~sin_synth1 = Synth(\sin_synth_proto);
~sin_synth1.set(\freq, 330);
~sin_synth1.set(\amp, 0.2);
~sin_synth1.release(0.3);


Можно сделать свой паттерн

~clk1 = TempoClock.new(120/60);

~clk1.beats;

(
~clk1.sched(0, {
	var next_start = rrand(0.005, 0.01);
	~sin_synth1.release(0.03);
	~sin_synth1 = Synth(\sin_synth_proto, args: [\freq, 200 + 200.rand]
	);

	next_start;
});
)



======================================================
                  Типы движения
=======================================================

генератор массивов
(1, 3..14)


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
	\note, Pwalk((12..1), stepPattern: Pser([1, 2, 2], inf), directionPattern: 1).trace,
	\ctranspose, -12,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], 1),
	\lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	\lforate, Pn(Pseries(2, 1, 11), inf),
	// \lforate, Pwalk((2..13), stepPattern: Pser([1, 2], inf), directionPattern: 1),
	\rq, Pn(Pseries(0.9, -0.1, 5), inf),
).play;
);

// cosmic sounds ))
Pwalk([(12..1), (9..-3)], stepPattern: Pser([1, 2], inf), directionPattern: 1)

Pwalk((2..13), stepPattern: Pser([1, 2], inf), directionPattern: 1).asStream.nextN(15)


2. Возвратное.  Когда доходит до конца, идет в обратную сторону. Такое поведение характерно для периодической функции

(1, 3..17)++(16, 14..1)
Pseq((1, 3..17)++(16, 14..1), inf).asStream.nextN(30).plot;

Pwalk((1..12), stepPattern: Pseq([1, 2], inf), directionPattern: Pseq([-1, 1], inf)).asStream.nextN(28).plot


Pwalk((1..12), stepPattern: Pseq([1, 2], inf), directionPattern: Pseq([-1, 1], inf)).asStream.nextN(28).plot;


Очень симметричное движение быстро утомляет, так что хорошо делать ускорение или замедление каких-то параметров, напр., темпа. Будет "двойное впечатление": повторение и развитие.


~clck3 = TempoClock.new(120/60);
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
		(1..12) ++ Prand([Rest(1), Rest(1), Rest(3), Rest(6)], 1),
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

Зачем вообще нужны функции, которые растут быстрее линейной?
Возьмем частоты в герцах: 100, 200, 1000, 2000

200/100  //= 2 это октава
2000/1000 // = 2 это тоже октава

200 - 100
2000 - 1000

Вывод
Чтобы производить то же самое слуховое впечатление:
1. разница между величинами наверху диапазона должна быть больше, чем внизу
2. чем "выше" по диапазону, тем больше должна становиться эта разница. При движении "вверх" разница должна увелививаться

Посмотрим на график

(
var steps = 15;
~plot_2_graph.(
	Pseries(1, 10, steps).asStream.nextN(steps),
	Pgeom(1, 1.5, steps).asStream.nextN(steps)
);
)

За один и тот же шаг линейная функция (арифметическая прогрессия) прибавляет оду и ту же величину.

За один и тот же шаг экпонента (геометрическая прогрессия) прибавляет все большую и болюшую величину.

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


2.pow(1/12)

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

Почему корень 12 степерни из 2 звучит так знакомо?


===========================================
По экпоненте устроено не только восприятие частоты, но и восприятие амплитуды

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


Децибел - это логарифм отношения двух величин, т.е. логарифм от экспоненциальной функции. Логарифм "приводит" экспоненту к почти линейной зависимости. Можно прибавлять, а не умножать.

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

==========================================

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

=============================================

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

и т.д ...


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

Очень важный приием в композиции. Все параметрызвука имеют пределы, в которых мы воспринимаем их на слух. А математические функции моут принимать какие угодно значения. Чаще всего приходится масштабировать их в нужный нам диапазон частот, длительностей и т.д.

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


// ======================================================
//             генераторы сигналов, визуализация
//             waveforms, visualization
// ========================================== ===========

// Универсальные генераторы, используются как в кач-ве LFO, так и на звуковой частоте
(
{
	LFTri.ar(440) * 0.2;
}.scope();
)

В спектре идеальной треугольной волны (triangle wave) содержатся только нечетные гармоники, а их амплитуды убывают обратно пропорционально квадрату их номера.


Чередование фаз: В ряде Фурье для треугольной волны знаки гармоник чередуются: \(1, -1/9, 1/25, -1/49...\) Это означает, что каждая последующая нечетная гармоника инвертирована по фазе на 180° относительно предыдущей.

график
(
{
	LFTri.ar(4) * 0.2;
}.plot(5);
)

Спектр
FreqScope.new;

Сравнимс результатом аддитивного синтеза:
(
{
	arg freq = 440, amp = 0.4; // два входа
	var sig = SinOsc.ar(freq) * amp; // меняем амплитуду
	// добавляем гармоники
	sig = sig + (SinOsc.ar(3 *freq) * amp/(3.pow(2)));
	sig = sig + (SinOsc.ar(5 *freq) * amp/(5.pow(2)));
	sig = sig + (SinOsc.ar(7 *freq) * amp/(7.pow(2)));
	sig.scope;
	Limiter.ar( // на всяк случай лимитируем выход по -0.4 dB
		sig, // входной сигнал
		level: dbamp(-0.4) // переводми децибелы в rms
	);
}.asSynthDef(fadeTime: 0.1, name: \my_tri__proto).add;
)

~my_tri = Synth(\my_tri__proto);
~my_tri.free;

// LFSaw
В спектре восходящей пилообразной волны (sawtooth wave) присутствуют абсолютно все гармоники — как четные, так и нечетные, а их амплитуды убывают обратно пропорционально их номеру (\(1/n\)).
Направление пилы: Спектральный состав восходящей (ramp up) и нисходящей (ramp down) пилы абсолютно одинаков по амплитудам. Разница заключается только в фазах гармоник, но на слух человеческое ухо эту разницу в фазах практически не воспринимает.

// LFPulse

(
{
	LFPulse.ar(4) * 0.2;
}.plot(5);
)
• В квадратной волне (меандре) амплитуды убывают медленнее — пропорционально \(1/n\) (-6 дБ на октаву). В треугольной волне они убывают как \(1/n^2\) (-12 дБ на октаву). Именно поэтому треугольная волна звучит гораздо мягче, глуше и ближе к синусоиде, так как высокие частоты в ней подавлены сильнее.


// Band Limited Oscillators используется только для аудио
// SinOsc, FSinOsc, Blip, Saw, Pulse

(
{
	Saw.ar(440) * 0.2;
}.scope();
)


(
{
	Saw.ar(4) * 0.2;
}.plot(5);
)

сравните с

(
{
	LFSaw.ar(4) * 0.2;
}.plot(5);
)

// Случайные процессы
// LFNoise0, LFNoise1, LFNoise2
(
{
	LFNoise2.kr(4) * 0.2;
}.plot(5);
)


также посмотрите
// VarSaw
// Impulse


// генераторы шума
// WhiteNoise, PinkNoise, BrownNoise

(
{
	LFNoise1.ar(4).pow(2) * 0.2;
}.plot(5);
)