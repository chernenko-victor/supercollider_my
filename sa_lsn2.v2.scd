Pwhite(0, 7, inf).asStream.nextN(10);
Pwhite(0, 7, inf).asStream.nextN(1000).plot;
Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot;


Prand(#[1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot;


{1.0.linrand }.dup(10000).histo(1000).plot(discrete: true);



///////////////////////////
// weighted rand

~weight1_ptrn = Pwrand(#[1, 2, 4, 8], #[0.5, 0.25, 0.1, 0.15], inf);
~stream_weight1 = ~weight1_ptrn.asStream;
~stream_weight1.nextN(20);
~stream_weight1.nextN(1000).plot;
~stream_weight1.nextN(1000).histo.plot;


// ///////////////////////////////
// dump and visualisation 2

Env.perc(releaseTime: 0.1).plot;
// WhiteNoise.ar(0.1).plot; // no handle "plot" for "WhiteNoise" synth ((
{WhiteNoise.ar(0.1)}.plot(3);
{WhiteNoise.ar(0.1) * Env.perc(releaseTime: 1).kr(doneAction: 2)}.plot(1);
{WhiteNoise.ar(0.1) * Env.perc(releaseTime: 1).kr(doneAction: 2)}.play;


//////////////////////////////////////
// compound patterns

// In Pbind, you can’t have arrays of patterns, but only patterns that return arrays.

(
Pdef(
	\seq_rand,
	Pbind(
		\degree, Pseq(
			[Prand([
				Pseq([-2, -4, -6], 1),
				0,
				1,
				1.1,
				Pseq([-1.1, -3.1, -5.1, -6], 1),
				Ptuple([
					Pwhite(6, 15, 1),
					Pwhite(-3, 5, 1)
				], 6)
			], 1), 2, 4, 6], inf
		).trace;
	),
).stop;
)


///////////////////

(
~tuple1_ptrn = Ptuple([
		Pwhite(0, 7, inf),
		Pwhite(0, 7, inf)
], inf);

~stream_tuple = ~tuple1_ptrn.asStream;
~stream_tuple.nextN(20);
)

(
~rand_acc_tuple1_ptrn = Pbind(
	\degree, ~tuple1_ptrn,
	\dur, 0.25,
	\legato, 1
).play;
)

(
var a, b;
a = Place(#[1, [2,5], [3, 6]], inf);
x = a.asStream;
13.do({ x.next.postln; });
)

(
Pdef(
	\place_prand,
	Pbind(
		\degree,
		Place([
			1,
			[
					Pwhite(6, 15, 1),
					Pwhite(-13, -5, 1)
			],
			[3, 6]],
		inf)
	),
).stop;
)


(
Pdef(
	\scale,
	Pbind(
		\degree, Pseq((1..7), inf),
		\dur, 0.5,
		\scale, Scale.major,
		// \scale, Scale.minor,
		// \scale, Scale.dorian,
		// \scale, Scale.ahirbhairav
	),
).stop;
)

Scale.directory;

//////////////////////////////////////
// pattern by pattern


// p = Pxrand([
// 	Pbind( ... ,
// 		Pbind( ... ,
// 			...
// 	], inf).play;

(
Pdef(\movements4_ptrn_pl,
	Pxrand(
		[
			Pbind(\degree, Pseq([0, 2, 4, 6], 3)),
			Pbind(\degree, Prand([0, 0.1, 1, 1.1] + 2, 5)),
			Pbind(
				\degree, Pseries({rrand(0, 7) - 8}, 1, {rrand(5, 15)}),
				\dur, Pxrand((1 .. 5) * 0.25, inf)
			),
		], inf
	);
).stop;
)


/////////////////////////////////////
// operators and functions in patterns

// compare
rrand(-7, -1).dup(5);
{rrand(-7, -1)}.dup(5);


// use operator for set initial values
// use functions for changing values

(
Pdef(\movements_ptrn_pl,
	Pbind(
		\degree, Pseq([
			0,
			Prand([
				{rrand(-7, -1)}, // compare to rrand(-7, -1)
				12,
			],1),
			2,
			3,
		], inf).trace,
	);
).stop;
)

(
Pdef(\movements_ptrn_p2,
	Pbind(
		\dur, 0.5,
		\degree, Pseq([
			0,
			Prand([
				{rrand(-7, -1)},
				12,
			],1),
			Pseries({rrand(0, 7)}, 1, {rrand(5, 15)}),
			2,
			3,
		], inf).trace,
	);
).stop;
)

/////////////////////////
//
(
Pdef(\movements3_ptrn_pl,
	Pbind(
		\degree, Prand([
			Prand((0 .. 7) + 12, rrand(5, 10)), //random high
			Prand((0 .. 7), rrand(5, 10)), //random middle
			Prand((0 .. 7) - 12, rrand(5, 10)), //random low
			Pseries({rrand(0, 7)}, 1, {rrand(5, 15)}), // step up
			Pseries({rrand(0, 7)}, -1, {rrand(5, 15)}), // step down
			Prand(

					[
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					]

				, rrand(5, 10)
			), // pedal
		], inf).trace,
		\dur, 0.25
	);
).stop;
)

///////////////////
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


Pswitch
Pswitch1
Pif

////////////////////////
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
		\instrument, \cheappiano,
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

///////////////
// quantisation

Pdef(\myPattern, Pbind(
    \instrument, \default,
    \dur, Pseq([1, 1, 2], inf),
    \degree, Pseq([0, 3, 5], inf)
)).quant_(4);

// Play both on ~myClock, quantized to 4 beats
Pdef(\pattern1).play(~myClock, quant: 4);
Pdef(\pattern2).play(~myClock, quant: 4);


