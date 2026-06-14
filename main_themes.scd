(
~parts_start = [1, 20, 20 + 15, 20 + 15 + 7, 20 + 15 + 7 + 4];

~metro1 = TempoClock.new();

~metro1.sched(0, {
	arg ...args;
	args.postln;
	/*
	i = 0;
	while {i < 5} {
		i.postln;
		i = i + 1;
	};
	*/
	~parts_start.size.do({
		arg i;
		if((~parts_start[i] > 0) && (~parts_start[i] <= args[0])) {
			~parts_start[i].postln;
			~parts_start[i] = 0;
		} {
			// "test".postln;
		};

	});
 	1;
});
)

~metro1.stop;

///////////////////////
// start init
(
s.waitForBoot({
	var path2lib = "C:/home/Admin/src/supercollider/supercollider_my/lib/";

	"--- Server started. Preparing patch... ---".postln;
	s.freeAll; // Clear all

});
)

(
Pdef(
	\part1__cl,
	Pbind(
		// \instrument, \test_synth,
		// \instrument, \cymbal808_ryan,
		\degree, Pser([1, 5.1, 2], inf),
		\dur, Pser([1, 5.1, 2] * 0.25, inf),
		\amp, 0.1,
	)
).quant_(1).stop;
)

(
Pdef(
	\part1__fl,
	Pbind(
		\degree, Pser([1, 5.1, 2] + 12, inf),
		\dur, Pser([1, 5.1, 2] * 0.25, inf),
		\amp, 0.1,
	)
).quant_(1).stop;
)

// lession2_200925_sequensing_w_pbind.scd


/*
Pdef работает на уровне клиента (языка) и создает инструкции (ноты, сообщения).Ndef работает на уровне сервера (аудиодвижка) и создает звуковые волны и аудиоэффекты.
*/

////////////////
// audio parameters management

// array_serveroption.scd
// change_device.scd



// C:\home\Admin\src\supercollider\supercollider_my\lsn4_041025.scd
// function is project for physical device

/////////////////
//
// installation extensions (quarks) fft_next.scd

// Language - Quarks - Open folder

// see C:\Users\Admin\AppData\Local\SuperCollider\downloaded-quarks\SynthDefPool\pool


SCLOrkSynths.gui;


////////////////////
// define synths

// C:\home\Admin\src\supercollider\supercollider_my\lsn4_041025.scd
// convert function to synth



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

~started = [0, 0, 0, 0]


~test_synth_exempl1 = Synth(\test_synth, args: [\freq, 220 + (10.rand * 200)]);
~test_synth_exempl1.release();


~started[0] = Synth(\test_synth, args: [\freq, 220 + (10.rand * 200)]);

(
~started[0].release;
~started[0]
)

~started[1] = Synth(\test_synth, args: [\freq, 220 + (10.rand * 200)]);

(
~started[1].release;
~started[1]
)


s.plotTree;

///////////////////////////

(
Pdef(
	\deg_pl, Pbind(
		\instrument, \test_synth,
		// \dur, Prand(((1..6) ++ [Rest(1), Rest(4)]) * 0.25, inf),
		\dur, Pdefn(\deg_pl_dur, 3),
		// \freq, Pdefn(\deg_pl_freq, 220),
		\degree, Pdefn(\deg_pl_degree, 0),
	)
).stop;
)

(
Pdefn(\deg_pl_dur, Prand(((1..6) ++ [Rest(1), Rest(4)]) * 0.25, inf));
)

///////////////////////////
// "iterable" data types

[1, 10, 100].class;     // Вернет: Array

List[1, 10, 100].class; // Вернет: List

(
Pdef(
	\part1__cl,
	Pbind(
		// \instrument, \test_synth,
		// \instrument, \cymbal808_ryan,
		\freq, Pser(Array.interpolation(5, 1, 1/12) * 220, inf),
		\dur, Pser([1, 5.1, 2] * 0.25, inf),
		\amp, 0.1,
	)
).quant_(1).stop;
)


(
[12, 0, -12].collect({
	arg i;
	i ** 2;
});
)

(
~pyramid_arr = Array.fill(10, {
	arg i;
	[1, 2, 3, 4].pyramid(i + 1);
});
)

/*
array
  scramble
  rotate
  reverse
*/

// wrapAt
a = [1, 2, 3]
a.wrapAt(2) // same as at
a.wrapAt(3) // wraps
a.wrapAt([-1, 3, 1]) // array of indices
a@@3 //syntactic shortcut

a = [1, 2, 3]
a.foldAt(2) // same as at
a.foldAt(3) // folds back
a.foldAt([-1, 3, 1]) // array of indices
a@|@3 //syntactic shortcut

// clipAt


////////////////////////
// random

10.rand

rrand(5.1, 9.1)


max(rrand(10, 20), rrand(10, 20)).dup(10) // evaluate max() once

{max(rrand(10, 20), rrand(10, 20))}.dup(1000).plot

{min(rrand(10, 20), rrand(10, 20))}.dup(1000).histo.plot

{min(rrand(10, 20), rrand(10, 20))}.dup(1000).histo.plot


(
{
	min(
		min(
			min(
				rrand(10, 20),
				rrand(10, 20)
			),
			rrand(10, 20)
		),
		rrand(10, 20)
	)
}.dup(1000).histo.plot
)

(
{
~arr1 = Array.rand(1000, 0, 10);
~arr1.mean;
}.dup(1000).histo.plot
)


{5000 - (exprand(100, 5000))}.dup(1000).histo.plot


////////////////////////////
// discrete distribution
// .choose
// .wchoose

///////////////////////////
// markov dictribution
[1, 2, 3, 4].normalizeSum.windex

////////////////////////////

(
// Задаем сид для текущего потока перед запуском музыки
thisThread.randSeed_(1234);

p = Pbind(
    // Pwhite будет генерировать случайную, но всегда одинаковую последовательность нот
    \note, Pwhite(0, 12, 8),
    \dur, 0.25
).play;
)


/*
Метод thisThread.randSeed влияет только на текущий поток (thread) выполнения.Если вы задали сид в одной строке кода, а затем через минуту запустили другую строчку, эта вторая строчка уже не будет привязана к сиду, так как это будет новый поток выполнения. Поэтому всегда объединяйте сид и генерацию случайных чисел в один блок кода круглыми скобками ( ... ) и выполняйте их одновременно.

В компьютерах не бывает «абсолютной» случайности. Генератор случайных чисел всегда использует формулы.Когда вы пишете thisThread.randSeed_(42), формула всегда стартует с числа 42 и выдает одинаковый результат.Когда вы пишете thisThread.randSeed_(Date.seed), формула каждый раз стартует с нового уникального числа (ведь время не стоит на месте), создавая идеальную иллюзию полной случайности.
*/


/*
"как передавать меняющийся сид через Pseq, чтобы мелодия менялась каждый такт"
*/
(
p = Pseed(
    // 1. Задаем последовательность сидов. Каждое число — это уникальный такт.
    // inf означает, что эти 3 такта будут бесконечно повторяться по кругу.
    Pseq([111, 222, 333], inf),

    Pbind(
        // 2. Здесь мы пишем случайную генерацию нот.
        \note, Pwhite(0, 12, 4), // Важно: генерируем ровно 4 ноты на один сид (один такт)!
        \dur, 0.25,               // Каждая нота длится четверть доли
        \amp, 0.2
    )
).play;
)
p.stop;

/*
C:\home\Admin\src\supercollider\supercollider_my\lsn4_041025.scd
// ========= Random. Visualization =============
// ========= Arbitrary random =============
// ========= Linear movement =============
*/

Prand([0, 2, 4, 6, 8], inf).asStream.nextN(100).plot;

// .asStream - covert pattern to stream
// .nextN(100) - covert stream to array with 100 elements
// .plot - show array with indexies on horizontal axis and elements' values on vertical

Prand([0, 2, 4, 6, 8], inf).asStream.nextN(1000).histo.plot; // Histogram  shows the number of occurrences of each element in array [0, 2, 4, 6, 8]. Compare with:

(
Phprand(1, 10, inf).asStream.nextN(100).plot;
Phprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)


////////////////////////////
// server-side

// Шумовые генераторы
// WhiteNoise.ar(0.2)


// LFNoise*

// Случайность по триггеру

(
SynthDef(\snareClick, { |gate = 1|
    // Impulse.kr(4) создает 4 триггера в секунду
    var trigger = Impulse.kr(4);

    // При каждом импульсе выбирается случайная частота от 800 до 4000 Гц
    var freq = TRand.kr(800, 4000, trigger);

    // Простая атака звука для каждого удара
    var env = EnvGen.kr(Env.perc(0.01, 0.1), trigger);

    var sig = SinOsc.ar(freq) * env * 0.3;
    Out.ar(0, sig ! 2);
}).add;

)

~snareClick1 = Synth(\snareClick);
~snareClick1.free;


/*
По умолчанию сервер всегда генерирует уникальный случайный шум. Но вы можете заставить конкретный синт повторять одну и ту же случайность с помощью модуля RandSeed.
*/

(
SynthDef(\seededSynth, {
    // Фиксируем случайность внутри этого синта.
    // При каждом запуске LFNoise0 выдаст абсолютно одинаковую мелодию!
    RandSeed.kr(1, 777);

    var freq = LFNoise0.kr(4).exprange(300, 1200);
    var sig = Saw.ar(freq) * 0.1;
    Out.ar(0, sig ! 2);
}).add;
)
////////////////////////////

// 1. Включаем звуковой сервер
s.boot;

(
// 2. Создаем SynthDef для случайного хэта
SynthDef(\randomHiHat, { |amp = 0.3, tempo = 12|
    // Шестнадцатые ноты (tempo = 12 импульсов в секунду)
    var clock = Impulse.kr(tempo);

    // TRand выдает число от 0.0 до 1.0 на каждый импульс часов.
    // Если число меньше 0.6 (60% вероятность), то триггер сработает!
    var strikeTrigger = TRand.kr(0.0, 1.0, clock) < 0.6;

    // Живая динамика: случайная громкость для каждого удара
    var strikeAmp = TRand.kr(0.2, 1.0, strikeTrigger);

    // Живой тембр: случайная частота фильтра (от 7000 до 12000 Гц)
    var filterFreq = TRand.kr(7000, 12000, strikeTrigger);

    // Короткая огибающая громкости для перкуссионного звука (хэта)
    var env = EnvGen.kr(Env.perc(0.001, 0.05), strikeTrigger);

    // Источник звука: белый шум (основа любого хэта)
    var source = WhiteNoise.ar();

    // Фильтруем шум, оставляя только самый верх, как у реального железа
    var filtered = HPF.ar(source, filterFreq);

    // Собираем всё вместе
    var sig = filtered * env * strikeAmp * amp;

    // Выводим в стерео
    Out.ar(0, sig ! 2);
}).add;
)

// 3. ЗАПУСК: Хэт начнет играть бесконечный, никогда не повторяющийся случайный ритм
x = Synth(\randomHiHat, [\tempo, 10, \amp, 0.25]);

// Можно на ходу менять скорость "внутренних часов"
x.set(\tempo, 16); // Сделать быстрее
x.set(\tempo, 6);  // Сделать медленнее

// 4. ОСТАНОВКА
x.free;


// if_select_sendtrig.scd


////////////////////////////
// substractive

(
{
	arg freq = 440;
	var in = Pulse.ar(50), out;

	out = Mix.fill(8, {
		arg i;
		BPF.ar(
			in: in,
			freq: freq * (i + 1),
			rq: SinOsc.kr(0.2).exprange(0.05, 0.1)
		) / (i + 1);
	});
	out = HPF.ar(out, 70);
	out = HPF.ar(out, 70);
	out = HPF.ar(out, 70);
	out = LeakDC.ar(out);
	out = LPF.ar(out, 4000);
}.asSynthDef(fadeTime: 0.1, name: \substr_impls_synth).add;
)

(
Pdef(\substr_synth_pl,
	Pbind(
		\instrument, \substr_impls_synth,
		// \freq, Pseq([220, 440, 660, 220, 330], inf).trace,
		// \midinote, Pseq([60, 62, 63, 65, 67], inf).trace,
		\degree, Pseq([0, 1, 2, 3, 4], inf).trace,
		\dur, Prand([1, 0.5, Rest(1), 1, 0.5, Rest(1)], inf).trace,
	)
).stop;
)

// dust.scd

// Klang
// DynKlank

// gen_add_substr_synthesis_array_pass_to_synth.scd

//////////////////////////////
// repeat in patterns

// play

~clk1 = TempoClock.new(110/60);

(
~pf_pl = Pbind(
	\rate, Pseries(
		-0.25,
		Pclutch(
			Prand([-1, 1], inf) * 0.25,
			Pseq([0, 0, 0, 1], inf)
		),
		inf
	).wrap(-3, 3).trace,
	\dur, Pwrand([
		0.25,
		Rest(16),
	], [85, 15].normalizeSum, inf),
	\instrument, \sampler_2ch_speed_var_proto,
	\buf, ~buf_sample3,
).play(~clk1, quant: 4);
)

(
~tom_pl = Pbind(
	\dur, Pwrand([
		1,
		Rest(1),
		Rest(4),
	], [94, 5, 1].normalizeSum, inf),
	\instrument, \sampler_mono_speed_var_proto,
	\buf, ~buf_sample1,
).play(~clk1, quant: 0);
)

//////////////////////////////
// pattern in pattern

// lace_ptrn.scd

// for complex number generators
(
Pfunc({
	1.0.rand;
}).asStream.nextN(5);
)




/*
// envelopes
C:\home\Admin\src\supercollider\supercollider_my\env_adv.scd

// env_retrigg.scd

// events control (trigger or gate)
// delay_dust_decay_selftrigger.scd
// dust.scd
// ...


C:\home\Admin\src\supercollider\supercollider_my\lsn5_111025.scd
//             waveforms, visualization
//             types of musical texture


C:\home\Admin\src\supercollider\supercollider_my\lsn6_181025.scd

//       Envelopes
//            Selftrig synth
//            Filter
//       Substractive synth
//       Samples
// directory to sampler

// continues play samples from dir
// continues_play_samples.scd


// midi_in.scd
//


C:\home\Admin\src\supercollider\supercollider_my\lsn7_011125.scd

// ================================
//            Granulation +
//            retrigger +
//            map control bus to synth arg
// ================================

*/




////////////////////////////
// feedback.sc

// SinOscFB



////////////////////////////
// installation server plugins fft_next.scd
//
// fft_base.scd - manipulations with bins
// fft.v3.scd
// fft.v4.scd
// fft_adv.scd
// fft_conv.scd
// ffttft.sc