(
{
	WhiteNoise.ar(0.1);
}.play;
)

(
~additive_func_pleer = {
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

~additive_func_pleer.run(0);
~additive_func_pleer.free;
~additive_func_pleer.release;

s.plotTree;


// how to use function in patterns?
// make synthesizer from function

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
}.asSynthDef(fadeTime: 0.1, name: \additive_example__proto).add;
)

(
Pdef(
	\additive_example__play,
	Pbind(
		\instrument, \additive_example__proto,
		\midinote, 72,
	)
).quant_(1).stop;
)

~pl1.mute;
~pl1.unmute;

~pl1.resume; // restart from stop point

~pl1.reset; // restart from stop begin


// include fx
// include additive

~add_synth_long = Synth(\add_synth_long_proto);
~add_synth_long.free;
~add_synth_long.release;

Env.adsr(1).test;

Env.adsr(1).plot();

Env.perc.test;
Env.perc.plot;


~add_synth_long = Synth(\add_synth_long_proto, args: [\freq, 220 + (10.rand * 20)]);


~add_synth_long.release;

~add_synth_long.set(\freq, 220 + (10.rand * 20));

(
Pdef(
	\add_synth_percussion__play,
	Pbind(
		\instrument, \add_synth_percussion_proto,
	)
).quant_(1).stop;
)

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

(
~midi_seq_weight_arr = Array.fill(10, {
	10.rand;
});
)

~midi_seq_weight_arr;

~midi_seq_weight_arr.normalizeSum.sum;

(
{
	~midi_seq_arr.wchoose(
	  ~midi_seq_weight_arr.normalizeSum
    )
}.dup(1000).histo.plot;
)


(
Pdefn(
	\substr_example_at_midinote,
	Pfunc({
			~midi_seq_arr.wchoose(
			  ~midi_seq_weight_arr.normalizeSum
		    );
		})
)
)

(
Pdefn(
	\substr_example_at_midinote,
	Pfunc({
			~midi_seq_arr.scramble.wchoose(
			  ~midi_seq_weight_arr.normalizeSum
		    );
		})
)
)
// include substr

/*
    A  B  C  D
A   10 20 30 10
B   10 10 20 30
C   30 10 10 20
D   20 30 10 10
*/

(
~markov_w_arr = [
	[10, 20, 30, 10].normalizeSum,
	[10, 10, 20, 30].normalizeSum,
	[30, 10, 10, 20].normalizeSum,
	[20, 30, 10, 10].normalizeSum,
];

~markov_dur = [1, 2, 4, 8] * 0.25;

~curr_indx = 0;
)

~curr_indx = ~markov_w_arr[~curr_indx].windex;


(
Pdefn(
	\substr_example_at_dur,
	Pfunc({
			~curr_indx = ~markov_w_arr[~curr_indx].windex;
		~markov_dur[~curr_indx];
		})
)
)

////////////////////////////

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

(
~clk4 = TempoClock.new(2); // set BPS to 2 beats per sec

/*
~pl4 = Pbind(
	\amp, Pseq([0.05, 0.1, 0.2], inf),
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play(clock: ~clk4, quant: 4);
*/

Pdef(
	\quant_tempo,
	Pbind(
	  \amp, Pseq([0.05, 0.1, 0.2], inf),
	  \degree, Pseq([0, 2, 3, 4], inf),
	  \dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
    )
).play(argClock: ~clk4, quant: 4);
)

~clk4.tempo = 4; // change BPS while Pbind playing

/*
Prand([
	Pbind,
	Pbind,
	[Pbind, ...]
])
*/


(
Pbind(
	// \instrument, \var_saw_proto,
	// \note, Pwalk((1..12), 1, 1, 7).trace, // chromatic movement, up direction
	\note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7).trace, // up-down direction
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace, // step variation
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace, // random direction
	\amp, Pwalk((1..8) * 0.1, 1, Prand([-1, 1]), 3),
	\dur, 0.25,
).play;
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
// legato

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
