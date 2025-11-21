// lsn9_151125

///////////////////////////////////////
// additive



Klang // additive


(
SynthDef(\klang_proto, {
	arg gate = 1, freq = 440;
	var frequencies, amplitudes, phases, amp_env, sig_out;
	frequencies = [300, 550, 1188, 3456];
	frequencies = frequencies / 300;
	amplitudes = [1, 0.3, 0.5, 0.2];
	phases = [0, pi/2, 0, 2 * pi / 3];
	amp_env = EnvGen.kr(
		Env.adsr(),
		gate,
		doneAction: 2
	);
	sig_out = Klang.ar(
		`[frequencies, amplitudes, phases],
		freq.linexp(50, 5000, 1, 0.01),
		freq
	);
	sig_out = sig_out * amp_env;
	Out.ar(0, sig_out);
}).add;
)

~klang = Synth(\klang_proto, args: [\freq, 1000]);
~klang.release;

(
Pdef(\klang_pl,
	Pbind(
		\instrument, \klang_proto,
		\degree, Prand((0..8), inf),
		\dur, Pclutch(
			Prand(((1..6) ++ [Rest(1)]) * 0.25, inf),
			Prand([1, 0, 0], inf)
		).trace,
	)
).stop;
)

DynKlang // parameters changable

(
SynthDef('help-dynKlang', { |out,
    freqs = #[220, 440, 880, 1760],
    amps = #[0.35, 0.23, 0.12, 0.05],
    phases = #[1, 1.5, 2, 2.5]|

    Out.ar(out, DynKlang.ar(`[freqs, amps, phases]))
}).add
)

a = Synth('help-dynKlang');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.rand(4, 0.01, 0.25));

a.free;

///////////////////////////////////////
// filtering, substractive


// lns7 ...
// see \white_noise_substr_adsr_proto from self_trig.scd

Klank // bank of Ringz filters
(
{
	Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1))
}.play;
)

{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007])) }.play;



DynKlank // parameters changable

(
// change freqs and ringtimes with mouse
{    var freqs, ringtimes;
    freqs = [800, 1071, 1153, 1723] * MouseX.kr(0.5, 2, 1);
    ringtimes = [1, 1, 1, 1] * MouseY.kr(0.1, 10, 1);
    DynKlank.ar(`[freqs, nil, ringtimes], Impulse.ar(2, 0, 0.1))
}.play;
)


(
// set them from outside later:
SynthDef(\dynklank_proto, { |out|
    var freqs, ringtimes, signal;
    freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
    ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
    signal = DynKlank.ar(`[freqs, nil, ringtimes], Impulse.ar(2, 0, 0.1));
    Out.ar(out, signal);
}).add;
)

~dynklank = Synth(\dynklank_proto);

~dynklank.setn(\freqs, Array.rand(4, 500, 2000));
~dynklank.setn(\ringtimes, Array.rand(4, 0.2, 4));
~dynklank.setn(\ringtimes, Array.rand(4, 0.02, 0.4));

// muted instrument for Pbind not sounding
(
SynthDef(\silence, {
	var sig_out = 0, amp_env;
	amp_env = Env.perc.kr(doneAction: 2);
	Out.ar(0, sig_out * amp_env);
}).add;
)

// ~silence = Synth(\silence);

(
Pdef(\klang_pl,
	Pbind(
		\instrument, \klang_proto,
		\degree, Prand((0..8), inf).clump(3),
		\dur, Pclutch(
			Prand(((1..6) ++ [Rest(1)]) * 0.25, inf),
			Prand([1, 0, 0], inf)
		),
	)
).play;


// change param of continuosly sounding synth
Pdef(\dynklank_param_pl,
	Pbind(
		\instrument, \silence,
		\bypass, Pfunc({
			~dynklank.setn(\ringtimes, Array.rand(4, 0.2, 4));
		})
	)
).play;
)

~dynklank.free;


// ================================
//            Granulation +
//            retrigger +
//            map control bus to synth arg
// ================================
// see lsn 8

// create multichannel controls directly with literal arrays:
(
SynthDef('help-dynKlank', { |out,
    freqs (#[100, 200, 300, 400]),
    amps (#[1, 0.3, 0.2, 0.05]),
    rings (#[1, 1, 1, 2])|

    Out.ar(out, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)

a = Synth('help-dynKlank');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.exprand(4, 0.01, 1));

{ Out.kr(102, MouseX.kr(1, 2) * Array.rand(4, 500, 2000)) }.play;
a.mapn(\freqs, 102, 4);


///////////////////////////////////////
Scale.major(\pythagorean)
// see scale tuning.scd


///////////////////////////////////////
// random

///////////////////////////////////////
// pattern

(
Pdef(\test_osc_pl,
	Pbind(
		\instrument, \test_osc
	)
).stop;
)

Prand
Pwrand
Pwhite

//////////////////////////////////////
// pattern by pattern


// p = Pxrand([
// 	Pbind( ... ,
// 		Pbind( ... ,
// 			...
// 	], inf).play;


~stream_wn = Pwhite(0, 7, inf).asStream;
~stream_wn.nextN(10);
~stream_wn.nextN(1000).plot;
~stream_wn.nextN(1000).histo.plot;

Pfunc

Ptuple // patterns to arrays
Place // arrays to ptrn
Ppatlace // arrays of ptrn to ptrn

//
Pclutch

Pclutch(Pseq([1, 2, 3, 4, 5], 3), Pseq([0, 0, 1, 0, 0, 0, 1, 1])).asStream.nextN(10);
-> [ 1, 1, 2, 2, 2, 2, 3, 4, nil, nil ]

lace
clumb

// movement see pwalk_and_other_line_mov, pattern_example4


Pkey //copy from prev key


///
Pdef(\ptrn3_pl,
	Pbind(
		\dur, 0.25,
		\degree, Pdefn(\ptrn3_pl_degree, 3),
	)
).play;
)

(
Pdefn(\ptrn3_pl_degree, 0);
)

Pdef(\ptrn3_pl).stop;


// pbindef.scd


PatternConductor

///////////////////////////////////////
// composition

///////////////////////////////////////
// grain
// lsn7 ...

// granular time stretcher and pitchshifter.
Warp1

// fft
// lsn8 ...

