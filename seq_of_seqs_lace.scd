// sequencing of sequencers

(
Pseq(
	[
		Pbind(
			\degree, Prand((0..7), 3)
		),
		Pbind(
			\degree, Prand((-7..0), 3)
		),
		Pbind(
			\degree, Prand((0..7), 3),
			\dur, 0.25
		),
		Pbind(
			\degree, Prand((-7..0), 3),
			\dur, 0.25
		),
	]
	, inf).trace.play;
)

// serialism
(
Pbind(
	\note, Prand([
		Pshuf((0..5) ++ [Rest(1)], 3),
		Pshuf((0..5) ++ [Rest(1), Rest(2)], 3),
		Pshuf((0..5) ++ [Rest(1), Rest(2), Rest(4)], 3),
	],
	inf
	).trace,
).play;
)


(
Pwhite(1.0, 0.0, inf).asStream.nextN(1000).histo(50, 0, 1.0).plot;
Prand([1, 2, 3, 4], inf).asStream.nextN(1000).histo.plot;
{0.001.exprand(1.0)}.dup(1000).histo(200).plot;
{-1 * (1.0.bilinrand)}.dup(1000).histo(200).plot;
)

{10 - 10.linrand}.dup(1000).histo.plot;
{10.linrand}.dup(1000).histo.plot;



// accords
Ppatlace
(
~arr1 = Ptuple([
	Pseq((0..7), inf),
	Pseq((0..7) + 3, inf),
	Pseq((0..7) + 5, inf),
], inf).asStream.nextN(10);
)
(
Prand(~arr1, inf).asStream.nextN(10);
)

(
Pbind(
	\degree, Prand(~arr1, inf),
).play;
)


Place([0, [2, 6, 8], [3, 4]], inf).asStream.nextN(10);

(
Ppatlace([
Pseries(0, 1, 8), // first, third etc. notes
Pseries(2, 1, 7) // second, fourth etc. notes
], inf).asStream.nextN(10)
)