===================================================
          Синтез звука
===================================================

(
{
	SinOsc.ar()

}.play;
)

Какие недостатки у такого синтезатора?

1. Нельзя выключить отдельный экземпляр.

2. Нельзя ничего поменять. Повторный старт не выключает работающий экземпляр синта.

s.plotTree; // показывает экземпляры синта

3. Нельзя использовать в паттернах


Быстрый конструктор синта
(
{
	SinOsc.ar();
}.asSynthDef(fadeTime: 0.1, name: \my_first_synth__proto).add;
)

(
Pbindef(
	\my_1st_synth_seq1,
	\instrument, \my_first_synth__proto,
	\dur, Pseq([1, 1, 1,
		Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
	], inf).trace,
	\amp, 0.4,
).play;
)

Pbindef(\my_1st_synth_seq1).stop;


Рандом в синтах - Rand

(
{
	SinOsc.ar(Rand(1, 5) * 220);
}.asSynthDef(fadeTime: 0.1, name: \sin_freq_rnd__proto).add;
)

Pbindef(\my_1st_synth_seq1, \instrument, \sin_freq_rnd__proto);

Pbindef(\my_1st_synth_seq1).stop;


Попробуйте вместо синуса другие периодические сигналы

LFTri
LFPulse
LFSaw


Параметры в паттернах

Чтобы сделать входы в синтезаторе, надо перечислить их после ключевого слова arg. Если призвоить значение, то оно будет использовано по умолчанию.

(
{
	arg freq = 440;
	SinOsc.ar(freq);
}.asSynthDef(fadeTime: 0.1, name: \my_first_synth__proto).add;
)



Ручной запуск

~my_first_synth1 = Synth(\my_first_synth__proto);

~my_first_synth1.run(0); // mute
~my_first_synth1.run(1); // unmute

~my_first_synth1.set(\freq, rrand(1, 5) * 220); // меняем частоту по рандому

~my_first_synth1.release(0.2);  // выключение с релизом


Pbindef(\my_1st_synth_seq1).clear;

(
Pbindef(
	\my_1st_synth_seq1,
	\instrument, \my_first_synth__proto,
	\dur, Pseq([1, 1, 1,
		Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
	] * 0.25, inf),
	\amp, 0.4,
	\freq, Pser([3, 2.5, 1.75, 1.25, 1] * 220, inf),
).play;
)


(
Pbindef(
	\my_1st_synth_seq1,
	\freq, nil,
	\degree, Pser(
	[
		[-3, 1, 4],
		Pxrand((-12..-4), 3),
		5,
		Prand(
			[
				Pseq([[-3, 1, 4], [-3, 1, 4] + 2, [-3, 1, 4] - 1.1], 1),
				Pseq((3.1, 5.2..11.1), 2),
				Pseq([1.1], 3),
			],
		1),
	]
	, inf).trace
)
)

Pbindef(\my_1st_synth_seq1).stop;


Обратите внимание: вместо \freq используется \degreee, но частота синта все равно изменется


Отображение экземпляров синта
s.plotTree;

Отображение проектов (прототипов) синтов
SynthDescLib.global.browse;



=============================================================
// При работе со звуком всегда используйте лимитер
 =============================================================

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


// В коллайдере нет приоритета арифметических операций ))
// сравните

1 + 2 * 3

// и
1 + (2 * 3)



FreqScope.new(); // спектроскоп

~my_first_synth1 = Synth(\sin_synth_proto);

~my_first_synth1.run(0);
~my_first_synth1.run(1);

~my_first_synth1.set(\amp, 0.3);

~my_first_synth1.set(\freq, rrand(1, 5) * 220);


~my_first_synth1.release(0.2);


1. Попробуйте сделать аддитивный синт с разными сочетаними частот и амплитуд синусов. Как это влияет на спектр?

2. Сделайте паттерн с использованием вашего синта.

