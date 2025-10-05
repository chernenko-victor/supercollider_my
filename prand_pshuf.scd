(
Pbind(
	\degree, Pshuf((1..8), inf),
).play;
)


Pshuf((0..7), inf).asStream.nextN(16);

// serializm
(
Prand([
	Pshuf((0..7), 2),
	Pshuf((0..7), 2),
	Pshuf((0..7), 2),
	Pshuf((0..7), 2),
], inf).asStream.nextN(8*8);
)


-> [5, 2, 0, 6, 1, 4, 3, 7,
	5, 2, 0, 6, 1, 4, 3, 7,

	2, 3, 6, 5, 0, 7, 4, 1,
	2, 3, 6, 5, 0, 7, 4, 1,

	1, 2, 0, 5, 3, 4, 7, 6,
	1, 2, 0, 5, 3, 4, 7, 6,

	1, 2, 5, 6, 4, 3, 7, 0,
	1, 2, 5, 6, 4, 3, 7, 0]


(
Prand([
	Pshuf((1..6) ++ [Rest(1), Rest(2)] * 0.25, 2),
	Pshuf((1..5) ++ [Rest(1), Rest(2), Rest(3)] * 0.25, 3),
	Pshuf((1..4) ++ [Rest(1), Rest(2), Rest(3), Rest(4)] * 0.25, 1),
	Pshuf((1..6) ++ [Rest(1), Rest(2)] * 0.25, 2),
], inf).asStream.nextN(8*8);
)

(
{(10.rand+1);}.dup(1000).histo.plot;
)
