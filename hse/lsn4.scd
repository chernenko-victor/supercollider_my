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
