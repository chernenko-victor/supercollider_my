Pbind().play; // simpiest sequencer

///////////////////////////////////////
// play, stop, change, play, stop .....

(
~seq1 = Pbind(
	\freq, 220,
	\dur, 0.25,
).play;
)

~seq1.stop;

///////////////////////////////////////
// livecoding style
//
// change freq and duration, evaluate region
// to stop change "play" to "stop" and evaluate region

(
Pdef(
	\seq1,
	Pbind(
		\freq, 220,
		\dur, 0.25,
	)
).play;
)

///////////////////////////////////////
// Patterns
//
// Pser plays element of array [] N times
// change N to inf
//
// Insert Pser pattern to \dur
//
// replace \freq pattern to Prand([1, 2/3, 3/4, 4/5] * 220, inf)
//
// add random to \dur

(
Pdef(
	\seq1,
	Pbind(
		\freq, Pser([1, 2/3, 3/4, 4/5] * 220, 7),
		\dur, 0.25,
	)
).play;
)


/////////////////////////////////////////
// installation extensions (quarks)
//
// Main menu - Language - Quarks, in new window check SCLOrkSynth, restart SuperCollider
//

SCLOrkSynths.gui;

// listen to synth (select and "play demo" in new window)

// copy code to current patch
// press "show me code", switch to new tab, copy all from "SynthDef" to ".add;"
// make a region in current patch
// paste code inside and execute region
// look in post window, must be "-> a SynthDef" there

(
SynthDef(\FMRhodes2, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1,
	//controls
	lfoSpeed = 2.4, inputLevel = 0.2, modIndex = 2, fmHarmonic = 30,
    // all of these range from 0 to 1
    mix = 0.2, lfoDepth = 0.75, lfoBottom = 0.15, lfoRange = 0.3;

    var env1, env2, env3, env4, range, bottom;
    var osc1, osc2, osc3, osc4, snd;

	bottom = lfoBottom.linlin(0, 1, 100, 12000);
	range = lfoRange.linlin(0, 1, bottom, 16000);

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * fmHarmonic) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;

    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = LPF.ar(snd, SinOsc.kr(lfoSpeed).range(bottom, range), lfoDepth) + (snd * (1 - lfoDepth));
    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;
)

// lets make new sequencer
(
Pdef(
	\seq_rodes,
	Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser([1, 2/3, 3/4, 4/5] * 220, 7),
		\dur, 0.25,
	)
).play;
)

// modify \seq_rodes and play with two parts
//
// add \amp, \gate to rodes part
//
// What others parameters we can control?