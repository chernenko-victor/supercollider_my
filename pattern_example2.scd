(
~celesta_ptrn = Pbind();
)

~celesta_ptrn_pl  = ~celesta_ptrn.play;
~celesta_ptrn_pl.stop;

s.plotTree;

(
SynthDef(\apad_mh, {arg freq=880, amp=0.5, attack=0.4, decay=0.5, sustain=0.8, release=1.0, gate=1.0, out=0;
	var env,sig,mod1,mod2,mod3;
	env=EnvGen.kr(Env.adsr(attack,decay,sustain,release),gate,levelScale:amp,doneAction:2);
	mod1=SinOsc.kr(6).range(freq*0.99,freq*1.01);
	mod2=LFNoise2.kr(1).range(0.2,1);
	mod3=SinOsc.kr(rrand(4.0,6.0)).range(0.5,1);
	sig=SinOsc.ar([freq,mod1],0,env).distort;
	sig=sig*mod2*mod3;
	Out.ar(out,sig);
},
metadata:(
	credit: "A simple sustained sound with vibrato --Mike Hairston",
	tags: [\pad,\vibrato,\sustained]
	)
).add;
)

~apad_mh_exempl1 = Synth(\apad_mh, args: [\freq, (220.rand + 220)]);
~apad_mh_exempl1.release();

// =======================

(
~apad_mh_ptrn = Pbind(
	\instrument, \apad_mh,
	// \freq, [220, 440, 880] - 110,
	\freq, ~freq_seq,
	\dur, ~dur_seq
);
)

~apad_mh_ptrn_pl  = ~apad_mh_ptrn.play;
~apad_mh_ptrn_pl.stop;

~freq_seq = Pseq([220, 440, 880], 3);
~dur_seq = Pseq([0.5, 1, 0.5, 4, Rest(1)], 2);

~freq_seq_stream = ~freq_seq.asStream;
~freq_seq_stream.nextN(10);

(
~routine1 = {
	loop {
		(~freq_seq_stream.next()).postln;
		1.wait;
	};

}.fork;
)
~routine1.reset;
~routine1.stop;

~freq_seq_stream.nextN(8).plot;
~freq_seq_stream.nextN(8).histo.plot;

({(10.rand)}!100).plot;
({(10.rand)}!1000).histo.plot;

~rand1_ptrn = Pwhite(0, 7, inf);
~rand1_ptrn_stream = ~rand1_ptrn.asStream;
~rand1_ptrn_stream.nextN(10);

(
~apad_mh2_ptrn = Pbind(
	\instrument, \apad_mh,
	// \freq, ~rand1_ptrn,
	\degree, ~rand1_ptrn,
	\dur, ~dur_seq
);
)

~apad_mh2_ptrn_pl  = ~apad_mh2_ptrn.play;
~apad_mh2_ptrn_pl.stop;


// mtranspose

(
~apad_mh2_mtranspose_ptrn = Pbind(
	\instrument, \apad_mh,
	// \freq, ~rand1_ptrn,
	// \degree, ~rand1_ptrn,
	\degree, Pseq([0, 1, 2, 3],inf),
	\mtranspose, 12,
	\scale, Scale.major(\just),
	\stepsPerOctave, 5, // no effect wtf?
	// \dur, ~dur_seq
);
)

~apad_mh2_mtranspose_ptrn_pl  = ~apad_mh2_mtranspose_ptrn.play;
~apad_mh2_mtranspose_ptrn_pl.stop;

Scale.major.stepsPerOctave;

Scale.new(degrees: 'ionian', pitchesPerOctave: 12); // wtf?


Scale.at(\ionian).;