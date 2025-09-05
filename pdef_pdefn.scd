(
Pdef(\part1, Pbind(
	\degree, Pdefn(\part1_degree, 4),
	\amp, 0.1,
	\sustain, 0.2,
	\dur, 0.5,
)).play;
)

(
Pdefn(\part1_degree, Prand([
	[-4, -2, 3], 0, [2, 4, 7], 5
], inf));
)

Pdef(\part1).stop;


// start something from next bar

~clock1.schedAbs(~clock1.nextBar - 0.01, {
	Pdefn(\part1_degree, Prand([
		[-4, -2, 3], 0, [2, 4, 7], 5
	], inf));
	nil;

});