(
Pbind(
	// \degree, Pwalk(pitches, Pfunc { 1 }, 1, 7),
	// \note, Pwalk((1..12), Pfunc { 1 }, 1, 7),
	// \note, Pwalk((1..12), 1, 1, 7),
	// \note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7),
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace,
	\note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace,
	\dur, 0.25,
).play;
)


(
Pbind(
	// \degree, Pseries(4, Prand(#[-2, -1, 1, 2], inf), inf).fold(-7, 11).trace,
	// \degree, Pseries(4, Prand(#[-1, 1], inf), inf).fold(-7, 11).trace,
	\degree, Pseries(
		4,
		Pclutch(Prand(#[-1, 1], inf), Pseq([0, 0, 0, 1], inf)),
		inf
	).fold(-7, 11).trace,
	\dur, 0.25,
).play;
)


(
Pbind(
	\degree, Pseries(
		4,
		Pclutch(Prand(#[-1, 1, -2, 2], inf), Pseq([0, 0, 0, 1], inf)),
		inf
	).fold(-7, 11).trace,
	\dur, 0.25,
).play;
)

(
Pbind(
	\degree, Pseries(
		4,
		Pclutch(Prand(#[-1, 1, -2, 2], inf), Pseq([0, 0, 0, 1], inf)),
		inf
	).fold(-7, 11).clump(3).trace,.
	\dur, Prand((1..6)++[Rest(1), Rest(2), Rest(4)], inf),
).play;
)


(
Pbind(
	\degree, Pseries(
		4,
		Pclutch(Prand(#[-1, 1, -2, 2], inf), Pseq([0, 0, 0, 1], inf)),
		inf
	).fold(-7, 11).clump(3).trace, // no changes in clump.
	\dur, Prand((1..6)++[Rest(1), Rest(2), Rest(4)], inf),
	\strum, Plprand(1, 10, inf) * 0.05,
	\legato, Phprand(3, 13, inf) * 0.1,
).play;
)