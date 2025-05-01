//include C:\home\chernenko\src\supercollider\lib\stokhastic.scd

(
~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
~master_send = Bus.audio(s, 2);
~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);
)


(
SynthDef(\player_proto, {
	arg buf = 0;
	var out;
	out = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1);
	Out.ar(0, out);
}).add;
)

~player1 = Synth(\player_proto, [\buf, ~arturia1_buf]);
~player1.free;

/////////////////////////////////////
//             events        \\\\\\\\
/////////////////////////////////////

(
~part_arturia2_func = {
	arg beat;
	beat.postln;
	4.rand + 0.5;
};

~event_gen_tclck_func = {
	arg beat;
	// var part_arturia2_start_beat, part_arturia2_stop_beat;
	["event_gen_tclck_func", beat, ~part_arturia2_start_beat].postln;
	if(
		(beat > ~part_arturia2_start_beat) && (~part_arturia2_start_flag == 0),
		{
			~part_arturia2_start_flag = 1;

			~part_arturia2 = TempoClock.new();
			~part_arturia2.sched(0, ~part_arturia2_func);

			~player1 = Synth(\player_proto, [\buf, ~arturia1_buf]);

			~part_arturia2_stop_beat = ~lin_min_distr.value(5, 10) + beat;
			"part_arturia2_start".postln;
		},
		{
			nil;
		}
	);

	if(
		(beat > ~part_arturia2_stop_beat) && (~part_arturia2_start_flag == 1),
		{
			~part_arturia2_start_flag = 0;
			~part_arturia2.stop;

			~player1.free;

			~part_arturia2_start_beat = ~lin_max_distr.value(5, 10) + beat;
			"part_arturia2_stop".postln;
		},
		{
			nil;
		}
	);

	0.25;
};

)

(
~part_arturia2_start_flag = 0;
~part_arturia2_start_beat = ~lin_min_distr.value(5, 10);
~part_arturia2_stop_beat = 0;
~event_gen_tclck = TempoClock.new();
)

(
~event_gen_tclck.sched(0, ~event_gen_tclck_func);
)

(
~part_arturia2.stop;
~event_gen_tclck.stop;
)

