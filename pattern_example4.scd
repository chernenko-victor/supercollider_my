(
Pdef(\movements_ptrn_pl,
	Pbind(
		\degree, Pseq([
			0,
			Prand([
				rrand(7, 12),
				5,
				6
			],1),
			2,
			3,
		], inf),
	);
).play;
)

Pdef(\movements_ptrn_pl).stop;


(
Pdef(\movements2_ptrn_pl,
	Pbind(
		\degree, Prand([
			Prand((12 .. 17), rrand(5, 10)),
			Prand((0 .. 7), rrand(5, 10)),
		], inf).trace,
		\dur, 0.25
	);
).play;
)

Pdef(\movements2_ptrn_pl).stop;

Pseries({rrand(0, 7)}, 1, {5, 15})

(
Pdef(\movements3_ptrn_pl,
	Pbind(
		\degree, Prand([
			Prand((0 .. 7) + 12, rrand(5, 10)), //random high
			Prand((0 .. 7), rrand(5, 10)), //random middle
			Prand((0 .. 7) - 12, rrand(5, 10)), //random low
			Pseries({rrand(0, 7)}, 1, {rrand(5, 15)}), // step up
			Pseries({rrand(0, 7)}, -1, {rrand(5, 15)}), // step down
			Prand(

					[
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					[[rrand(0, 7)], [rrand(-7, -1)], [rrand(8, 13)]],
					]

				, rrand(5, 10)
			), // pedal
		], inf).trace,
		\dur, 0.25
	);
).play;
)

Place

Pdef(\movements3_ptrn_pl).stop;


(0 .. 7) + [12, -12, 15, -17].choose

~test = ([1, 2, 3] + Prand([12, -12, 15, -17], 1)).asStream;
~test.next()


(
Pdef(\movements4_ptrn_pl,
	Prand(
		[
			Pbind(\degree, Pseq([0, 2, 4, 6], 3)),
			Pbind(\degree, Prand([0, 0.1, 1, 1.1] + 2, 5)),
			Pbind(
				\degree, Pseries({rrand(0, 7)}, 1, {rrand(5, 15)}),
				\dur, Pxrand((1 .. 5) * 0.25, inf)
			),
		], inf
	);
).play;
)

Pdef(\movements4_ptrn_pl).stop;

Pswitch
Pswitch1
Pif

0.7.coin.binaryValue