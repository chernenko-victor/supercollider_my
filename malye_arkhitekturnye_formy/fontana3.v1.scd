////////////////////////
// prepare
//
//
// include lib/fx.scd
// include lib/additive.scd
//
(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

///////////////
// test area

(
~add_synth_long1 = Synth(
	\add_synth_long_proto,
	[
		\freq, 220 + 220.rand,
		// \out_bus, ~record_bus1
		\out_bus, ~master_send
    ]
);
)

~add_synth_long1.release();


////////////
(
~guit_part1 = Pbind(
	\instrument, \add_synth_long_proto
);

~guit_part1_player = ~guit_part1.play;
)

~guit_part1_player.stop;

///////////
Pdef(\guit_part1, ~guit_part1);

(
~guit_part1_1 = Pbindf(
	Pdef(\guit_part1),
	\dur, Pwhite(0.25, 4)
);

~guit_part1_1_player = ~guit_part1_1.play;
)

~guit_part1_1_player.stop;

(
~guit_part1_2 = Pbindf(
	Pdef(\guit_part1),
	\dur, 0.25
);

~guit_part1_2_player = ~guit_part1_2.play;
)

~guit_part1_2_player.stop;

(
Pdef(\guit_part1,
	Pbind(
		\dur, 4
	)
)
)
///////////////
(
Pdef(
	\guit_part2,
	Pbind(
		\instrument, \add_synth_long_proto,
		\note, Pbrown(0, 6, 0.1, inf)
	)
);

Pdef(\guit_part2).quant = 0;

~player1 = Pbindf(
	Pdef(\guit_part2),
	\dur, 1,
	\ctranspose, 15
).play;
)

~player1.stop;

(
Pdef(
	\guit_part2,
	Pbind(
		\instrument, \add_synth_long_proto,
		\note, Pseq([0, 3, 5, 7, 9, 11], inf),
		\dur, 0.25
	)
);
)

///////////////
// work area


///////////////
// finalize area
(
~master.free;
)