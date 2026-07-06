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


//////////////////////////////////
//
//      user defined synth

// function can make sounds
(
~noise_gen = {
	WhiteNoise.ar(0.1)
}.play;
)

~noise_gen.release;

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

// .asSynthDef - set name and envelope, without it pattern can't use synth
// .add - send synth to audio server

// now we can play pattern with our synth
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
			rrand(48, 72);
		}),
		\legato, 0.8,
	)
).play;
)

// Pbind translate \degree and midinote to \freq

// Pdefn allow to change pattern for \degree without restart whole \fb_sin__player

(
Pdefn(
			\degree_at_fb_sin__player,
			Prand([1, 2, 4, 1] + 12, inf).trace
		)
)

(
Pdefn(
	\degree_at_fb_sin__player,
	Pfunc({
		// [1, 2, 5, 7] + (5.rand)
	  ~midi_seq1_arr.wchoose(~midi_seq1_weigth_arr)
	}).trace
		)
)

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


//////////////////////////////////
//
//      Envelopes

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