// ================================
//       Envelopes
// ================================

Env.perc(releaseTime: 0.1).plot; // visualization

Env.perc(releaseTime: (0.1 + 1.0.rand)).test; // sonification

// fixed time instrument stays in memory
(
{
	Env.perc(releaseTime: 0.1).kr * WhiteNoise.ar(0.2);
}.play;
)

// instrument go out memory because of
// .kr(doneAction: 2)
// to see memory condition run s.plotTree;

(
{
	Env.perc(releaseTime: 0.1).kr(doneAction: 2) * WhiteNoise.ar(0.2);
}.asSynthDef(name: \hh_proto).add;
)

Synth(\hh_proto);

// that behavior suits for using in Pbind
(
Pbind(
	\dur, Prand((1..4) * 0.125, inf),
	\instrument, \hh_proto,
).play;
)

// other forms of fixed time envelopes:
// Env.linen
// Env.sine


// envelope from curved fragments
Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]).plot;

(
{
	var freq_env = Env.perc().kr(doneAction: 2).range(0.95, 1.05);
	Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]).kr(doneAction: 2) * Saw.ar(440 * freq_env) * 0.2;
}.play;
)

(
{
	EnvGen.kr(
		Env(
            levels: [0, 0.1, 0.2, 0.3, 0],
            times: [0.1, 0.1, 0.1, 0.2],
            curve: 8
        ),
		gate: 1,
		doneAction: 2
	);
}.plot(duration: 2);
)


// fixed length without 'releaseNode' parameter
(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 0.1, 0.2, 0.3, 0],
            times: [0.1, 1, 1, 0.5],
            curve: 8,
			// releaseNode: 2
        ),
		gate: 1,
		doneAction: 2
	);
	LFTri.ar(440) * env * 0.2;
}.play;
)



// envelope as pattern
(
Pbind(
    \note, Env(
            levels: [0, 12, 6, 13, 0],
            times: [1, 5, 2, 10],
            curve: 8
        ),
    \dur, 0.1
).play;
)

// in 'adsr' node previous to last is releaseNode by default
(
SynthDef(\env_help, { |out, gate = 1, amp = 0.1, release = 0.1|
    var env = Env.adsr(0.02, release, amp);
    var gen = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    Out.ar(out, PinkNoise.ar(1 ! 2) * gen)
}).add
);

a = Synth(\env_help);
b = Synth(\env_help, [\release, 2]);
a.set(\gate, 0);
// alternatively, you can write a.release;
b.set(\gate, 0);


// ================================
//            Selftrig synth
// ================================


{Trig.kr(Impulse.kr(0.1), dur: 5)}.plot(20);

{Trig.kr(Dust.kr(0.5), dur: 5)}.plot(20);

(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 1, 0],
            times: [0.1, 1],
            curve: 8,
			releaseNode: 1,
        ),
		gate: Trig.kr(Impulse.kr(0.2), dur: 1),
		doneAction: 0
	);
	LFTri.ar(440) * env * 0.2;
}.play;
)

// loopNode
(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 1, 0.2, 1, 0.3, 1, 0],
            times: [0.1, 0.5, 0.5, 0.5, 0.1, 1],
            curve: 8,
			releaseNode: 5,
			loopNode: 1,
        ),
		// gate: Trig.kr(Impulse.kr(0.1), dur: 5),
		gate: Trig.kr(Dust.kr(0.5), dur: 5),
		doneAction: 0
	);
	LFTri.ar(440) * env * 0.2;
}.play;// plot(10);
)



{Decay2.kr(Impulse.kr(1), 0.1, 1)}.plot(5)

(
{
	Decay2.kr(Impulse.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
}.play;
)

(
{
	Decay2.kr(Dust.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
}.play;
)


(
{
	var sig_out;
	sig_out = Lag2.kr(Dust.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
	sig_out = Compander.ar(sig_out, sig_out, 0.1, slopeBelow: 0.9, slopeAbove: 1/10) * 20;
	sig_out = Limiter.ar(sig_out, dbamp(-1));
}.play;
)