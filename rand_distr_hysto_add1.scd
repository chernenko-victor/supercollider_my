(
Pdef(
	\rand_pl,
	Pbind(
		\degree, Pdefn(
			\degree__rand_pl,
			Pwrand((1..5), [10, 30, 5, 15, 40].normalizeSum, inf)
		).trace,
	)
).stop;
)

(
Pdefn(
			\degree__rand_pl,
			Pwrand((1..5), [10, 30, 5, 15, 40].normalizeSum, inf)
		);
)

(
Pdefn(
			\degree__rand_pl,
			0
		);
)

~rand_ptrn = Pwrand((1..5), [10, 30, 5, 15, 40].normalizeSum, inf);

~rand_ptrn.asStream.nextN(10);


~rand_ptrn.asStream.nextN(100).plot;

~rand_ptrn.asStream.nextN(1000).histo.plot;

~rand_arbitr_ptrn = Pprob([1, 0]);
~rand_arbitr_ptrn.asStream.nextN(1000).plot;
~rand_arbitr_ptrn.asStream.nextN(1000).histo.plot;

~rand_arbitr2_ptrn = Pwrand((1..5), (1..5).normalizeSum, inf);
~rand_arbitr2_ptrn.asStream.nextN(1000).plot;
~rand_arbitr2_ptrn.asStream.nextN(1000).histo.plot;


~rand_arbitr3_ptrn = Pwrand((1..5), (5..1).normalizeSum, inf);
~rand_arbitr3_ptrn.asStream.nextN(1000).plot;
~rand_arbitr3_ptrn.asStream.nextN(1000).histo.plot;

(10, 8..1)

(
Pbindef(\rnd2_pl, \degree, 0).play;
)

Pbindef(\rnd2_pl, \degree, Pseq((1..5), inf));


Pbindef(\rnd2_pl, \instrument, \distortedGuitar);

Pbindef(\rnd2_pl).stop;

SCLOrkSynths.gui;