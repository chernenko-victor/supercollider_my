FreqScope.new;

{WhiteNoise.ar(0.2).scope()}.play;

(
{
	var sig;
	sig = Blip.ar(
		330,
		XLine.kr(10, 100, 20) // numharm: 100
	).scope();
	HPF.ar(sig, XLine.kr(800, 5000, 20));
}.play;
)

(
{
	var sig = WhiteNoise.ar(0.2).scope();
	Mix.fill(10, {
		arg index;
		(Resonz.ar(
			sig,
			440.0 * (2 * index + 1),
			LFNoise2.kr(0.3).exprange(0.01, 0.1);
	) / (index + 1));
	});
}.play;
)