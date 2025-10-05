// define synths
(
{
	arg freq = 440;
	(
		SinOsc.ar(freq)
		+ (SinOsc.ar(freq * 2) / 2)
		+ (SinOsc.ar(freq * 3) / 3)
		+ (SinOsc.ar(freq * 4) / 4)
		+ (SinOsc.ar(freq * 5) / 5)
	) / 5;
}.asSynthDef(fadeTime: 0.1, name: \test_synth).add;
)

~test_synth_exempl1 = Synth(\test_synth, args: [\freq, 220 + (10.rand * 200)]);
~test_synth_exempl1.release();

s.plotTree;

(
Pdef(
	\deg_pl, Pbind(
		\instrument, \test_synth,
		// \dur, Prand(((1..6) ++ [Rest(1), Rest(4)]) * 0.25, inf),
		\dur, Pdefn(\deg_pl_dur, 3),
		// \freq, Pdefn(\deg_pl_freq, 220),
		\degree, Pdefn(\deg_pl_degree, 0),
	)
).stop;
)

(
Pdefn(\deg_pl_dur, Prand(((1..6) ++ [Rest(1), Rest(4)]) * 0.25, inf));
)

(
Pdefn(\deg_pl_freq,
	Prand((1, 3..10) * 220, inf);
);
)

(
Pdefn(\deg_pl_degree,
	Prand((1, 3..10), inf);
);
)