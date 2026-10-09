// synths definition
(
{
	arg freq, amp;
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(0.7).range(0.99, 1.01)) +
	(SinOsc.ar(freq * 2 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 2) +
	(SinOsc.ar(freq * 3 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 3) +
	(SinOsc.ar(freq * 4 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 4);
	sig = amp * sig / 4;
	[sig, sig]; // 2 channel
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_proto).add;
)

(
{
	SinOsc.ar(
		5 * LFNoise2.kr(2).range(0.5, 1.5) // frequency modulation
	);
}.plot(5);
)

(
{
	arg freq, amp;
	var sig;
	sig = VarSaw.ar(
		freq,
		width: LFNoise2.kr(3.1).range(0.3, 0.68),
    );
	sig = amp * sig;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \var_saw_proto).add;
)

Synth(\sin_sum_proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
Synth(\var_saw_proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);


===================================================
                     циклы (loops)
===================================================


(
10.do({
	arg i;
	i.postln;
})
)


(
{
	arg freq, amp;
	var sig = 0, harm_num = 10;

	harm_num.do({
	    arg ...args_arr;
	    // args_arr.postln;
		sig =  sig + (
			SinOsc.ar(
				freq *
				(args_arr[0] + 1) *
				LFNoise2.kr(0.7).range(0.99, 1.01)
			) / (args_arr[0] + 1)
		);
    });

	sig = amp * sig / harm_num;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_loop__proto).add;
)

~sin_sum_loop1 = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);

~sin_sum_loop1.release(0.2);

(
~voice_num = rrand(1, 4);
~notes_arr = Array.newClear(~voice_num);

~voice_num.do({
	arg ...args_arr;
	// args_arr.postln;
	~notes_arr[args_arr[0]] = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
})
)

(
~voice_num.do({
	arg ...args_arr;
	// args_arr.postln;
	~notes_arr[args_arr[0]].release(0.2);
})
)


///////////////////////////
// "iterable" data types

[1, 10, 100].class;     // Вернет: Array

List[1, 10, 100].class; // Вернет: List


// не надо добавлять элементы к созданному массиву
~arr1 = [1, 10, 100]; // в консоли [1, 10, 100]
~arr1.postln; // в консоли [1, 10, 100]
~arr1.add(1000); // в консоли [1, 10, 100, 1000]
~arr1.postln; // в консоли [1, 10, 100, 1000] Array увеличивается
~arr1.add(1000); // в консоли  [1, 10, 100, 1000, 1000]
~arr1.postln; // в консоли [1, 10, 100, 1000] Array теперь не увеличился


(
5.do({ // число тоже iterable
	~arr1.add(100.rand).postln; // в консоли  [1, 10, 100, 1000, <random>]
	~arr1.postln; // в консоли [1, 10, 100, 1000] Array теперь не увеличился
})
)

Чтобы добавить элементов, надо использовать список

~list1 = List[1, 1.5, 3, Rest(1)];

(
5.do({
	var dur = (15.rand / 10) + 0.125;
	if(
		[false, false, true].choose,
		{dur = Rest(dur)}
	);
	~list1.add(dur).postln;
})
)

(
Pbindef(\test_list,
	\dur, Pser([1, 1.5, 3, Rest(1)], inf)
).play;
)

(
Pbindef(\test_list,
	\dur, Pser(~list1, inf)
);
)

Pbindef(\test_list).stop;


~list1.asArray.class;
~arr1.asList.class;



Индекс всегда целый
(
5.1.do({
	arg i;
	i.postln;
});
)

С переменным шагом
forBy (0, 2, 0.5) { |value| value.postln };


Массив итерабельный
(
~arr1.do({
	arg ...args_arr; // все аргументы упакует в массив, удобно когда не знаешь перечень аргументов
	args_arr.postln; // [value, index]
});
)

Заполнение массива с помощью функции
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
		\instrument, \var_saw_proto,
		\midinote, Pseq(~midi_seq_arr, 1),
	)
).quant_(1).play;
)


Переменное число обертонов

(
{
	arg
	  freq = 440,
	  amp = 0.2,
	  freqs_ratio_arr = #[1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // #[1, 2, 3, 4] - фиксированный массив
	;
	var sig = 0;

	freqs_ratio_arr.do({
	    // arg ...args_arr; // не работает в синте
		arg ratio;
		/*
		// не работает в синте
		if(
			args_arr[0] > 0,
			{	nil; }
		);
		*/
		var is_positive = ratio > 0; // а это работает ))


		sig =  sig + ((
					SinOsc.ar(
						freq *
						(ratio + 1) *
						LFNoise2.kr(0.7).range(0.99, 1.01)
					) / (ratio + 1)
		) * is_positive); // Если ratio <= 0, сигнал умножится на 0 и сотрется
    });

	sig = amp * sig / freqs_ratio_arr.size;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_loop_var__proto).add;
)

FreqScope.new;

~my_saw = Synth(\sin_sum_loop_var__proto);
~my_saw.release();


(
~my_square = Synth(\sin_sum_loop_var__proto, args: [
	\freqs_ratio_arr, [1, 3, 5, 7, 9, 11]
]);
)
~my_square.release();


(
~non_harm_arr = Array.fill(7, {
	arg i;
	i + 1 + (rrand(0, 10) / 15);
});
)

(
~my_drone = Synth(\sin_sum_loop_var__proto, args: [
	\freqs_ratio_arr, ~non_harm_arr
]);
)



~my_drone.set(\amp, 0.7);
~my_drone.set(\freq, rrand(1, 12) / rrand(2, 5) * 110);
~my_drone.release();



=====================================================

Субстрактивный синтез
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

Pdef(\substr_example__play).stop;


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



===================================================
          Различные случайные распределения
===================================================


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
               Огибающие (Envelopes)
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




// ==========================================
//             types of musical texture
//             типы музыкальной фактуры
// ==========================================

// melody
(
Pbind(
	// \instrument, \var_saw_proto,
	\degree, Prand((0..8), inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(((1..6) ++ [Rest(2), Rest(4)]) * 0.25, inf),
).play;
)

// accords
(
Pbind(
	// \instrument, \sin_sum_proto,
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
	// \instrument, \var_saw_proto,
	\note, Pwalk((1..12), 1, 1, 7).trace, // chromatic movement, up direction
	// \note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7), // up-down direction
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace, // step variation
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace, // random direction
	\amp, Pwalk((1..8) * 0.1, 1, Prand([-1, 1]), 3),
	\dur, 0.25,
).play;
)



======================================================
                  вложенные паттерны III
=======================================================


(
~rand_seq = Pxrand(
	[
		Pbind(
			\instrument, \sin_synth_proto,
			\freq, Pser([1, 2, 3] * 110, inf).trace,
			\dur, Pser([1, 2, 3], 4)
		),
		Pbind(
			\instrument, \default,
			\freq, Pser([1, 2, 3] * 440, inf).trace,
			\dur, Pser([1, 2, 3] * 0.25, 4)
		),
		Pbindef( \feedbackPad3,
			\instrument, "feedbackPad3",
			\dur, 2,
			\legato, 0.9,
			\sampleRate, Pwhite(20.0, 25.0),
			\midinote, Pseq([ // Welcome to the ocean!
				[43, 47], [41, 48], [43, 47], [41, 48],
				[43, 47], [41, 48], [41, 45], [39, 46],
			])
		),
	],
	10
).play;
)

~rand_seq.stop;

(
~seq_of_seq = Pser(
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

~seq_of_seq.stop;


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
            паттерны разной длины
            синхронизация каждый 4 бита
===================================== =============

(
Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq(
		[
				Pn(1, 3), Rest(1/4), 3/4, Pn(1, 3), Rest(1)
		], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).play(~clck3, quant: 1);

Pdef(
\ppolyrythm1,
Pn(
// Паттерн играет случайное количество нот длительностью 0.3 бита.
// 0.3 не делится ровно на 1 или 4.
  Psync(
    Pbind(
        \dur, 0.3,
        \note, Pseq([0, 2, 4, 7], 3) // Всего 12 нот по 0.3 = 3.6 бита
    ),
    quant: 1.0, // Округлить общую длительность до целого бита
    maxdur: 4.0 // Но не дольше 4 битов
  ),
  inf
)
).play(~clck3);
)

Pbindef(\seq3).stop;



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


=======================================================
           LFO
=======================================================

(
{
	// arg freq =440, amp = 0.2;
	var
	  sig,
	  pulse_witdth,
	  amp_env,
	  duration = 0.5,
	  freq =440,
	  amp = 0.2
	;

	freq = LFNoise0.kr(1).range(1, 10).ceil / (LFNoise0.kr(0.72).range(2, 6).ceil) * 440;

	duration = LFNoise0.kr(0.25).range(1, 10).ceil * 0.25;

	pulse_witdth = LFNoise2.kr(0.3).range(0.2, 1.5);
	amp_env = SinOsc.kr(freq: duration);
	// amp_env = LFSaw.kr(freq: 0.1).poll;
	sig = LFPulse.ar(
		freq: freq,
		iphase: 0,
		width: (0.5 * pulse_witdth).poll
	) * amp_env * amp;

	sig = Limiter.ar(in: sig, level: dbamp(-0.4));
}.asSynthDef(fadeTime: 0.2, name: \self_trig__proto).add;
)

~self_trig1 = Synth(\self_trig__proto);
~self_trig1.release(0.3);

//////////////////////////
//
// Exchange data between synth by Bus.control


Changed

(
{
    var changingSignal = LFNoise0.ar(1000);
    var changed = Changed.ar(changingSignal);
    [changingSignal, changed]
}.plot
);





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



// ....

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
