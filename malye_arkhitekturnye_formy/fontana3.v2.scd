////////////////////////
// prepare
//
//
// include lib/fx.scd
// include lib/additive.scd
// include lib/sample.scd
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
~guit_part1_proto = Pbind(
	\instrument, \add_synth_long_proto,
	\midinote, Prand([60, 62, 65, 67, 70, 72, Rest(), Rest()], inf),
	\dur, (Prand([1, 2, 3, 4, 6, 8], inf) * 0.25) + Pbrown(0.01, 0.1, 0.1, inf),
	\out_bus, ~master_send
);

Pdef(\guit_part1, ~guit_part1_proto);
)

// (
// ~guit_part1_voice1_player =
// Pbindf(Pdef(\guit_part1)).play;
// ~guit_part1_voice2_player = Pbindf(Pdef(\guit_part1)).play;
// )
//
// (
// ~guit_part1_voice1_player.stop;
// ~guit_part1_voice2_player.stop;
// )


/////
(
~slava_kpss_v3_buf = Buffer.read(s, "E:/audio/music/chernenko/ans_bulatov_slava_kpss3.wav");
~slava_kpss_v3_buf.query; //numChannels: 2
)

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~slava_kpss_v3_buf, \out_bus, ~master_send, \rate, 0.5]);
~sample_player_rate_var.free;

////////
(
~pitch_system1 = [60, 62, 65, 67, 70, 72];
~note_density1 = 0.8;

~comping2_ptrn = Pfuncn({
	if(
		~note_density1.coin,
		{
			~pitch_system1.scramble.keep(3);
		},
		{
			Rest(0);
		}
	)
}, inf);
)
~comping2_ptrn.asStream.next();


///////////////////////////
// re-initiate

~pitch_system1 = [60, 62, 65, 67, 70, 72];

(
~guit_part1_comping_player =
Pbindf(
	Pdef(\guit_part1),
	\midinote, ~comping2_ptrn
).play;

~meta_part1 = TempoClock.new();
~meta_part1.sched(0, {
	arg beat, sec;
	var power;
	[beat, sec].postln;
	// power = 60 - (pow(beat+1, 2)%50);
	power = 40 - ((0.375 * beat)%38);
	power.postln;
	~pitch_system1 = ~pitch_system1 + (12.rand2);
	power;
});
)

~note_density1 = 0.67;

~guit_part1_comping_player.stop;

~meta_part1.stop;

//////
(
~meta_part2_started = 0;

~meta_part2 = TempoClock.new();
~meta_part2.sched(30, {
	arg beat, sec;
	var delta;
	delta = (4.rand + 1) * 5;
	[beat, sec].postln;
	if(
		~meta_part2_started == 0,
		{
			~meta_part2_started = 1;
			~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [
				\buf, ~slava_kpss_v3_buf,
				\out_bus, ~master_send,
				\rate, 0.5
			]);
		},
		{
			~meta_part2_started = 0;
			~sample_player_rate_var.free;
		}
	);
	delta;
});
)

(
~sample_player_rate_var.free;
~meta_part2.stop;
)

///////////////
// work area




///////////////
// finalize area
(
~master.free;
)