///////////////////////////////////////////
// init
//
// include lib/common.scd
// and test audio
//
// include lib/fx.scd
// include lib/additive.scd
// include lib/sample.scd
// include lib/frequency_modulation.scd
//

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

/////////////////     part1 (pluck)  ///////////////
(
~guit_part1_proto = Pbind(
	\instrument, \add_synth_long_proto,
	\midinote, Prand([60, 62, 65, 67, 70, 72, Rest(), Rest()], inf),
	\dur, (Prand([1, 2, 3, 4, 6, 8], inf) * 0.25) + Pbrown(0.01, 0.1, 0.1, inf),
	\out_bus, ~master_send
);

Pdef(\guit_part1, ~guit_part1_proto);

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

/////////////////    part2 (drum loop)  ///////////////
(
~slava_kpss_v3_buf = Buffer.read(s, "E:/audio/music/chernenko/ans_bulatov_slava_kpss3.wav");
~slava_kpss_v3_buf.query; //numChannels: 2
)


/////////////////  part3 (ottoni riff) ///////////////
(
~ottoni_riff1 = Pseq([32, Rest(0), 32, Rest(0), 32, Rest(0)], 2);
~ottoni_part1 = Pbind(
	\instrument, \tuba_proto,
	\out_bus, ~master_send,
	/*\midinote, [
		Pser([32, 30, 34, 28, Rest(0)], 10)-10,
		Pser([32, 30, 34, 28, Rest(0)], 10),
	],*/
	\midinote, ~ottoni_riff1,
	\dur, Pseq([0.5, 2, 3, 0.5, 0.5, 4], 2),
	// \attackTime, Pwhite(0.05, 0.5, inf),
	\attackTime, Pseq([0.05, 0.1, 1, 0.1, 0.07, 0.1], 2),
	// release_time = 0.1;
	\amp, (Pseries(0.1, ((10.rand)/1000 + 0.05), inf) % 0.4) * 0.8
);

~ottoni_part1_meta1 = Pdef(\ottoni_part1, ~ottoni_part1);

~ottoni_part1_meta2 = Pbindf(
	~ottoni_part1_meta1,
	\ctranspose, -12,
	\dur, Pseq([0.55, 2, 2.95, 0.52, 0.48, 4], 2),
	\attackTime, Pseq([0.06, 0.1, 0.7, 0.1, 0.05, 0.1], 2),
	\amp, (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2) * 0.8
);

~fl_part2_meta1 = Pbindf(
	~ottoni_part1_meta1,
	\instrument, \add_synth_percussion_proto,
	\ctranspose, 12,
	\dur, Pseq([0.53, 1.97, 2.95, 0.49, 0.51, 4], 2),
	\attackTime, Pseq([0.06, 0.1, 0.7, 0.1, 0.05, 0.1], 2),
	\amp, (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2) * 0.8
);
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
~guit_part1_voice1_player =
Pbindf(Pdef(\guit_part1)).play;
~guit_part1_voice2_player = Pbindf(Pdef(\guit_part1)).play;
)

(
~guit_part1_voice1_player.stop;
~guit_part1_voice2_player.stop;
)


/////
~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~slava_kpss_v3_buf, \out_bus, ~master_send, \rate, 0.5]);
~sample_player_rate_var.free;

////////
~comping2_ptrn.asStream.next();


///

~tuba1 = Synth(\tuba_proto, [\freq, 220.0, \out_bus, ~master_send]);
~tuba1.set(\freq, 440.0);
~tuba1.set(\freq, 880.0);
~tuba1.release;


//////////////////////////////////////////
// work area


/////////////////     part1 (pluck)  ///////////////

~pitch_system1 = [60, 62, 65, 67, 70, 72]; // re-initiate

(
~meta_part1_start = {
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
};

~meta_part1_start.value;
)

~note_density1 = 0.67;

~guit_part1_comping_player.stop;

~meta_part1.stop;

/////////////////    part2 (drum loop)  ///////////


(
~meta_part2_start = {
	arg start_delay = 30;
	~meta_part2_started = 0;

	~meta_part2 = TempoClock.new();
	~meta_part2.sched(start_delay, {
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
};

~meta_part2_start.value;
)

(
~sample_player_rate_var.free;
~meta_part2.stop;
)

/////////////////    part3 (factura)  ///////////

(
~meta_part3_started = 0;

~meta_part3 = TempoClock.new();
~meta_part3.sched(120, {
	arg beat, sec;
	var delta;
	[beat, sec].postln;
	if(
		~meta_part3_started == 0,
		{
			~meta_part3_started = 1;

			~guit_part1_comping_player.stop;
			~meta_part1.stop;

			~sample_player_rate_var.free;
			~meta_part2.stop;

			~ottoni_part1_meta1_player = ~ottoni_part1_meta1.play;
			~ottoni_part1_meta2_player = ~ottoni_part1_meta2.play;
			~fl_part2_meta1_player = ~fl_part2_meta1.play;
			delta = 17;
		},
		{
			~meta_part3_started = 0;


			~pitch_system1 = [60, 62, 65, 67, 70, 72];
			~note_density1 = 0.67;

			~meta_part1_start.value;
			~meta_part2_start.value(23);

			delta = nil;
		}
	);
	delta;
});
)

///////////////
// finalize area
(
~master.free;
)