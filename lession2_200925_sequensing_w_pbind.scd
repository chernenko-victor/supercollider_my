// Pbind - sequencer
// to turn on code inside "()" place cursor inside "()" and press CMD + Enter (MAC) or Ctrl + Enter (WIN)
(
Pbind().play;
)

// Two sequencers
(
~pl1 = Pbind().play;
)

(
~pl2 = Pbind(
	\degree, 3,
	\dur, 0.25
).play;
)

// Ctrl (Cmd) + . = stop all sounds

~pl1.stop; // stop one sequencer
~pl1.play; // start one sequencer

~pl1.mute;
~pl1.unmute;

~pl1.resume; // restart from stop point

~pl1.reset; // restart from stop begin


// Sequence of pitches and durations
(
~pl3 = Pbind(
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play;
)

// Pseq([a, b, c, d, ...], number) - pattern that repeat a, b, c, d, ... for "number" cycles, "inf" for infinite repetition

/*
inside "()" of Pbind must be pairs
Pbind(key1, value1, key2, value2, ..., keyN, valueN)
"key" is a name of musical parameter, for example "\degree" for degree of pitch scale:
0 - C middle, 1 - D, 2 - E, ...
*/

// durations are in beats, BPS (beats per second) by default = 1
// to change BPS use TempoClock

(
~clk4 = TempoClock.new(2); // set BPS to 2 beats per sec
~pl4 = Pbind(
	\amp, Pseq([0.05, 0.1, 0.2], inf),
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play(~clk4);
)

~clk4.tempo = 4; // change BPS while Pbind playing

// different syths
// https://github.com/supercollider-quarks/SynthDefPool/tree/master/pool

// for example, copy from there https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/acid_oto309.scd and add ".add" after final ")"

(
SynthDef(\cheappiano, { arg out=0, freq=440, amp=0.1, dur=1, pan=0;Ê
	var sig, in, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
	freq = freq.cpsmidi;
	hammer = Decay2.ar(Impulse.ar(0.001), 0.008, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
	sig = Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.04, 0, 0.03].at(i);
			delay = (1/(freq + detune).midicps);
			CombL.ar(hammer, delay, delay, 50 * amp)
		}) );

	sig = HPF.ar(sig,50) * EnvGen.ar(Env.perc(0.0001,dur, amp * 4, -1), doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
},
metadata: (
	credit: "based on something posted 2008-06-17 by jeff, based on an old example by james mcc",
	tags: [\casio, \piano, \pitched]
	)
).add;
)

// now we can use it in Pbind

(
~clk5 = TempoClock.new(2); // set BPS to 2 beats per sec
~pl5 = Pbind(
	\instrument, \cheappiano,
	\amp, Pseq([0.05, 0.1, 0.2], inf),
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play(~clk5);
)

~pl5.stop; // turn off sequenser