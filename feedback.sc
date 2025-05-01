//https://supercollider.github.io/sc-140.html Nathaniel Virgo
{
	LocalOut.ar(
		a=CombN.ar(
			BPF.ar(
				LocalIn.ar(2) * 7.5 + Saw.ar([32,33], 0.2) //in
				, 2 ** LFNoise0.kr(4/3, 4) * 300 //frq
				,0.1 //rq = bandwidth / freq
			).distort //in
			, 2 //max delay time
			, 2 //delay time
			, 40 //decaytime
		)
	);
	a
}.play;

FreqScope.new;


/*


(
play(
	{
		Decay.ar(
			Impulse.ar(
				0.5
			) //in
			, 0.2 //decayTime
			, 1//PinkNoise.ar //mul
			, 0
		) * WhiteNoise.ar;
	}
);
)
*/

(
SynthDef(\feedback_synth, {
	var src, dest;
	src = Decay.ar(
		Impulse.ar(
			0.5
		)
	) * WhiteNoise.ar(0.2);

	dest = src.dup + LocalIn.ar(2);
	dest[0] = CombN.ar(
			dest[0]
			, 0.1
			, 0.1
			, 0.2
		);
	dest[1] = CombN.ar(
			dest[1]
			, 0.1 //maxdelaytime
			, 0.1 //delaytime
			, 0.2 //decay
		);

	LocalOut.ar(dest * 0.8);
	Out.ar(0, dest);
}).add;

SynthDef(\feedback_synt_another, {
	var source, local;
	source = Decay.ar(
		Impulse.ar(
			0.5
		)
	) * WhiteNoise.ar(0.2);
	local = LocalIn.ar(2) + [source, 0];
	//local = [source, 0];
	local = DelayN.ar(local);
	LocalOut.ar(local.reverse * 0.8);
	Out.ar(0, local);
}).add;
)

~feedback_synth1 = Synth(\feedback_synth);
~feedback_synth1.free;

~feedback_synth2 = Synth(\feedback_synt_another);
~feedback_synth2.free;
