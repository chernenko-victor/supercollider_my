(
Pbind(
	\dur, Pser([1], 10),
).play;
Pbind(
	\dur, Pser([0.33], 10),
	\degree, 3
).play;
)

// install SCLorkSynths Quark and add kick808, snare1
(
~cl1 = TempoClock.new(2);

Pseq(
	[
		Ppar([
			Pbind(
				\dur, Pser([1], 10),
				\instrument, "kick808",
			).trace,
			Pbind(
				\dur, Pser([0.5], 20),
				\instrument, "snare1",
			).trace,
		]),
		Pbind(
			\dur, Pser([0.33], 10),
			\degree, 3
		),
	],
	inf
).play(clock: ~cl1);
)

~cl1.tempo=1;

Ppar


(
Ppar([
			Pbind(
				\dur, Pser([1], 10),
				\instrument, "kick808",
			).trace,
			Pbind(
				\dur, Pser([0.5], 20),
				\instrument, "snare1",
			).trace,
]).play(quant: 4);
)

(
Pbind(
			\dur, Pser([2], 10),
			\degree, 3
		).play(quant: 4);
)

Quant