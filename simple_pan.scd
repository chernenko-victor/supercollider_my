s.plotTree; //see nodes stack
(
SynthDef("fm", {
	arg out = 0;
	var sig;
	// sig = [WhiteNoise.ar(0.1), WhiteNoise.ar(0.1)];
	sig = WhiteNoise.ar(0.1) * Decay2.ar(Impulse.ar(0.3));
	Out.ar(
		out
		, Pan2.ar(
			sig
			, LFNoise2.kr(1).range(-1, 1)
			// , Line.kr(-1, 1, 5)
			, 1
		)
	);
}).add;
)

~fm1 = Synth("fm");
~fm2 = Synth("fm");

~fm1.run(0);
~fm1.run(1);


~fm1.free;
~fm2.free;


{LFNoise2.kr(1).range(-1, 1)}.plot(10);

// s.plotTree;