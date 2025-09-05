(
Pfindur(8, Ppar([
	Pbind(),
	Pbind(
		\dur, Pseq([1, 2, 4, 6, 8] * 0.25, inf)
	),
	Pbind(
		\dur, Pseq([1, 2, 4, 6, 8] * 0.33, inf),
		\degree, Prand([0, 2, 4, 8, 10], inf)
	),
])).play;
)