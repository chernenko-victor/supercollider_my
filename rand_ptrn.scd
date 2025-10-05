(
Pwhite(1, 10, inf).asStream.nextN(100).plot;
Pwhite(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Pexprand(1, 10, inf).asStream.nextN(100).plot;
Pexprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Phprand(1, 10, inf).asStream.nextN(100).plot;
Phprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Plprand(1, 10, inf).asStream.nextN(100).plot;
Plprand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Pmeanrand(1, 10, inf).asStream.nextN(100).plot;
Pmeanrand(1, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Pwalk((0..7), Prand([1, 2, 3], inf), Pseq([1, -1], inf), 3).asStream.nextN(100).plot;
Pwalk((0..7), Prand([1, 2, 3], inf), Pseq([1, -1], inf), 3).asStream.nextN(1000).histo.plot;
)

(
~plot_rnd_distr = {
	arg ptrn;
	ptrn.asStream.nextN(100).plot;
	ptrn.asStream.nextN(1000).histo.plot;
	nil;
};
)

(
~rnd_weight_ptrn = Pwrand((0..7), [10, 30, 5, 40, 20, 10, 5, 40].normalizeSum, inf);
~plot_rnd_distr.value(~rnd_weight_ptrn);
// ~rnd_weight_ptrn.asStream.nextN(100).plot;
// ~rnd_weight_ptrn.asStream.nextN(1000).histo.plot;
)

(
Pprob([0, 1, 0, 1, 0, 0, 0, 1]).asStream.nextN(100).plot;
Pprob([0, 1, 0, 1, 0, 0, 0, 1]).asStream.nextN(1000).histo.plot;
)

// ==========================================

(
Pbrown(1, 10, 0.1, inf).asStream.nextN(100).plot;
Pbrown(1, 10, 0.1, inf).asStream.nextN(1000).histo.plot;
)

(
Pgauss(5, 2, inf).asStream.nextN(100).plot;
Pgauss(5, 0.02, inf).asStream.nextN(1000).histo.plot;
Pgauss(5, 10, inf).asStream.nextN(1000).histo.plot;
)

(
Ppoisson(5, inf).asStream.nextN(100).plot;
Ppoisson(5, inf).asStream.nextN(1000).histo.plot;
)
