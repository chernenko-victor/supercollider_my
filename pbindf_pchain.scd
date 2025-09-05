(
SynthDef("acid_oto309", {
	arg out=0, gate=1, freq=440, amp=0.1, pan=0;
	var env1, env2, son, pitch;
	pitch = freq.cpsmidi;
	pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
	env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
	env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
	son = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

	son = RLPF.ar(son, (pitch + env2).midicps, 0.3);
	son = son * env1;

	Out.ar(out, Pan2.ar(son, pan));
},
metadata: (
	credit: "from 08091500Acid309 by_otophilia",
	tags: [\pitched, \acid, \phat, \subtractive]
	)
).add;
)

~acid_oto309_expl1 = Synth("acid_oto309");
~acid_oto309_expl1.release;



(
SynthDef(\cheappiano, { arg out=0, freq=440, amp=0.1, dur=1, pan=0;�
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

~cheappiano_expl1 = Synth(\cheappiano);

s.plotTree;



(
// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html

SynthDef("waveguideFlute", { arg scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );

}).add;

)

~waveguideFlute_expl1 = Synth("waveguideFlute");

(
~ptrn1_pl = Pbind(
	// \instrument, \cheappiano,
	\dur, Pseq([1, 2, 4, 6, 8] * 0.25, 5),
	\degree, [1, 2, 4, 6, 8],
	\jhgjhg, 8,
).play;
)

~ptrn1_pl.stop;

//////////////////////////////////////
(
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

///////////////////////////////////

(
~ptrn_src = Pbind(
	\dur, 1.3,
); // dont start it immediately, it crashed whole SC and hang sound (((
)


~ptrn_src_pl = ~ptrn_src.play;
~ptrn_src_pl.stop;


(
Pbindf(
	~ptrn_src,
	\freq, 440
).play;
)

(
Pbindf(
	~ptrn_src,
	\dur, 1,
	\freq, Prand([220, 230, 460], inf),
).play;
)


Pchain
