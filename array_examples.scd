(
Pdef(
	\def_ptrn,
	Pbind(
		\freq, Prand(Array.interpolation(5, 1, 12) * 220, inf),
		// \degree, Prand((0, 3..12) ++ ((Rest(1))!3), inf),
		\dur, 0.25,
		\ctranspose, Prand([12, 0, -12, 12, 0, -12], inf),
	);
).play;
)

Pdef(\def_ptrn).stop;

[12, 0, -12]!5

[12, 0, -12].dupEach(n: 3)


Array

(
[12, 0, -12].collect({
	arg i;
	i ** 2;
});
)

Array.interpolation(5, 1, 12) * 220;

(
10.do({ arg i;
    [1, 2, 3, 4].pyramid(i + 1).postcs;
});
)

(
~pyramid_arr = Array.fill(10, {
	arg i;
	[1, 2, 3, 4].pyramid(i + 1);
});
)

(
Pdef(
	\pyramyd_pl,
	Prand([
		Pbind(
			\degree, Pser(~pyramid_arr[0], 10),
			\dur, Pser(~pyramid_arr[3] * 0.5, 10),
		),
		Pbind(
			\degree, Pser(~pyramid_arr[1], 10),
			\dur, Pser(~pyramid_arr[4] * 0.25, 10),
		),
		Pbind(
			\degree, Pser(~pyramid_arr[2], 10)),
		// \dur, Pser(~pyramid_arr[5], 10),
	], inf)
).play;
)



Pdef(\pyramyd_pl).stop;


[ [ 4, 7 ], [ 6, 8 ] ].reshape(1, 4)


-> [ 144.0, 0.0, 144.0 ]
-> [ 4, 7, 6, 8 ]
-> [ [ 4, 7 ], [ 6, 8 ] ]
-> [ [ 4, 7, 6 ], [ 8, 4, 7 ] ]

[1, 2, 3, 4].normalizeSum.windex