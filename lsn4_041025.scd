// ========= Random. Visualization =============

(
Pbind(
	\degree, Prand([0, 2, 4, 6, 8], inf),
).play;
)

Prand([0, 2, 4, 6, 8], inf).asStream.nextN(100).plot;

// .asStream - covert pattern to stream
// .nextN(100) - covert stream to array with 100 elements
// .plot - show array with indexies on horizontal axis and elements' values on vertical

Prand([0, 2, 4, 6, 8], inf).asStream.nextN(1000).histo.plot; // Histogram  shows the number of occurrences of each element in array [0, 2, 4, 6, 8]. Compare with:

(
Phprand(1, 10, inf).asStream.nextN(100).plot;
Phprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Plprand(1, 10, inf).asStream.nextN(100).plot;
Plprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Pmeanrand(1, 10, inf).asStream.nextN(100).plot;
Pmeanrand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

// use it for contrast between of parts of musical form

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

// ========= Arbitrary random =============

Pwrand([0, 2, 4, 6, 8], [10, 30, 10, 20, 5].normalizeSum, inf).asStream.nextN(1000).histo.plot;

(
Pbind(
	\note, Pwrand([0, 2, 4, 6, 8], [10, 30, 10, 20, 5].normalizeSum, inf).trace,
).play;
)

// ========= Linear movement =============

(
Pbind(
	\note, Pwalk((0..11), 1, 1, 5).trace,
	\dur, 0.25,
).play;
)

(
~directionPattern = Pseq([-1, 1], inf);
Pbind(
	\note, Pwalk((0..11), 1, ~directionPattern, 5).trace,
	\dur, 0.25,
).play;
)

(
~directionPattern = Pseq([-1, 1], inf);
~stepPattern = Pser([1, 2, 2], inf);
Pbind(
	\note, Pwalk((0..11), ~stepPattern, ~directionPattern, 5).trace,
	\dur, 0.25,
).play;
)

(
~directionPattern = Pseq([-1, 1], inf);
~stepPattern = Prand([1, 2, 2], inf);
Pbind(
	\note, Pwalk((0..11), ~stepPattern, ~directionPattern, 5).trace,
	\dur, 0.25,
).play;
)

// ========= Function =============

(
// handmade low dominant linear distribution ))
~get_lin_rand = {
	min(10.rand, 10.rand); // last string in function is its output
};
)

~get_lin_rand.value();

// make array by 1000 call of function ~get_lin_rand, then plot histogram
~get_lin_rand.dup(1000).histo.plot;


// ========= Sound function =============

(
// function is project for physical device
~sin_wave = {
	SinOsc.ar() * 0.2;
};
)

~sin_wave_synth1 = ~sin_wave.play; // make device by project
~sin_wave_synth1.free; // delete device


// convert function to synth

// =============================================================
// CAUSION: Always limit amplitude before listening sounds!
// =============================================================

(
{
	arg freq, amp; // two inputs
	Limiter.ar( // just for safety: limit loud sounds to -0.4 dB
		SinOsc.ar(freq) * amp, // audio signal
		level: dbamp(-0.4)
	);
}.asSynthDef(fadeTime: 0.1, name: \sin_synth_proto).add;
)

(
~directionPattern = Pseq([-1, 1], inf);
~stepPattern = Prand([1, 2, 2], inf);
Pbind(
	\note, Pwalk((0..11), ~stepPattern, ~directionPattern, 5).trace,
	\dur, 0.25,
	\instrument, \sin_synth_proto,
	\amp, Pwalk((1..8) * 0.1, Pwrand([1, 3], [0.75, 0.25], inf), ~directionPattern, 4),
).play;
)