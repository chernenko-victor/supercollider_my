(
{
	var src, out, out_trem;
	src = Decay.ar(
		Dust.ar(1),
		decayTime: 0.5
	// ) * WhiteNoise.ar(0.2);
		) * Saw.ar(440, 0.2);
	out = src;
	5.do({
		out = DelayN.ar(
			out,
			maxdelaytime: 1,
			delaytime: LFNoise0.kr(0.3).range(0.001, 0.01) // spectral change
		) + out;
	});

	out_trem = out;
	5.do({
		out_trem = DelayN.ar(
			out_trem,
			maxdelaytime: 1,
			delaytime: LFNoise0.kr(0.3).range(0.01, 0.9) // tremolando
		) + out_trem;
	});

	out = (out * 0.33) + (
		out_trem * LFNoise2.kr(0.1).range(0.0001, 0.01)
	);
	out = Limiter.ar(out, -0.95.dbamp);
}.scope(1);
)

