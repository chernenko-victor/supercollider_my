(0..7).clump(3)

(
Place([
	(0..7),
	(0..7) + 3,
	(0..7) + 5,
], inf).asStream.nextN(3 * 5);
)

(
Place([
	(0..7),
	(0..7) + 3,
	(0..7) + 5,
], inf).clump(3).asStream.nextN(3 * 5);
)

(
Ptuple([
	Prand((0..7), inf),
	Prand((0..7) + 3, inf),
	Prand((0..7) + 5, inf),
], inf).asStream.nextN(2);
)

(
Ppatlace([
	Prand((0..7), inf),
	Prand((0..7) + 3, inf),
	Prand((0..7) + 5, inf),
], inf).asStream.nextN(3 * 5);
)



