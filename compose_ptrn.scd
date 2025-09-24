(
Pseq((1..4), 10).asStream.nextN(10);
Prand((1..4), 10).asStream.nextN(10);
)

(
// Pseq(
Prand(
	[
		Pseq((1..4), 1),
		Pseq((11..14), 1),
	], 20
).asStream.nextN(20);
// Prand((1..4), 10).asStream.nextN(10);
)

(
Pfunc({
	1.0.rand;
}).asStream.nextN(5);
)
