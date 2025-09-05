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
~route2 = Routine({
	inf.do({ // similar to loop({})
		1.0.rand.yield;
	});
});

~route2.nextN(3);
)

~route2.nextN(3);