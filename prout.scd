(
~route1 = Routine({
	1.yield;
	2.yield;
});

~route1.nextN(3);
)

~route1.nextN(3);
~route1.reset;

(
~prout_pl = Pbind(
	\dur, Prout({
		loop({
			(0.25 + (4.rand / 4)).yield;
		})
	}),
	\degree, p{
		inf.do({
			7.rand.yield;
		});
	}
).play;
)

~prout_pl.stop;