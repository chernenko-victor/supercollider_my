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