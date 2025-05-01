/*           ===============================================================
                                   before start
             ===============================================================          */

//include C:\home\chernenko\src\supercollider\lib\common.scd
// and test audio

//include C:\home\chernenko\src\supercollider\lib\fx.scd
//include C:\home\chernenko\src\supercollider\lib\additive.scd
// include lib/temperament.scd
// include lib/record_part.scd
// include lib/frequency_modulation.scd

~master = Synth(\master_proto, [\in_bus, ~master_send]);

(
var start_time_arr_len = 10;

~theme1_midi_arr = ((1..10) ++ (Rest(0)).dup(3));

~theme1_midi_ptrn = Pser(
		((1..10) ++ (Rest(0)).dup(3)) + 64,
		inf
    );

~part1 = Pbind(
	\instrument, \add_synth_percussion_proto,
	\out_bus, ~master_send,
	\midinote, ~theme1_midi_ptrn,
	\dur, 0.1,
	// attc_time = 0.01,
	\attc_time, Pexprand(0.01, 0.1, inf),
	// release_time = 0.1;
	\amp, (Pseries(0.1, ((10.rand)/1000 + 0.05), inf) % 0.4)
);


// (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2).asStream.nextN(20)

~part1_meta2 = Pbindf(
	~part1_meta,
	\dur, 0.05,
	\ctranspose, 15,
	\amp, (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2)
);


// (Pseries(0.005, ((10.rand)/1000 + 0.001), inf) % 0.1).asStream.nextN(20)
~part1_meta3 = Pbindf(
	~part1_meta,
	// \dur, (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2),
	\dur, (Pseries(0.005, ((10.rand)/1000 + 0.001), inf) % 0.1)/10.0,
	\ctranspose, -15,
	\amp, (Pseries(0.01, ((15.rand)/1000 + 0.02), inf) % 0.2)
);


~part1_meta = Pdef(\part1, ~part1);
////

~seq_ptrn = Pbind(
	\freq, Pser(~et12_8_ratios_arr * 440.0, 57),
	\dur, 0.07
);
~rand1_ptrn = Pbind(
	\freq, Prand(~et12_8_ratios_arr * 440.0, 65),
	\dur, 0.07
);

~fl_part1 = Prand(
	[
		Ptpar([
			0, ~seq_ptrn,
			2, ~rand1_ptrn
		], 1),
		~seq_ptrn,
		Pbind(\freq, Rest(0), \dur, Pser([1.5], 1)),
		~rand1_ptrn
	], 5
);


////


// (Pgeom(1, 2, 7) ++ Pgeom(10,0.5, 3)).asStream.nextN(10)

~start_time_arr = Array.fill(start_time_arr_len, {
	arg indx;
	var res;
	if(indx <= 6,
		{
			res = 20 * (pow(1.5, -1*indx));
		},
		{
			res = 20 * (pow(2, indx)/2000);
		}
	);
	res;
});
~start_time_arr = [0] ++ ~start_time_arr;

///
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

///////////////////////////////////////////
// test area

~theme1_midi_ptrn.asStream.nextN(30);


Synth(\add_synth_percussion_proto, [\out_bus, ~master_send]);


~part1_player = ~part1.play;
~part1_player.stop;

////


~part1_meta1_player = Pbindf(~part1_meta, \dur, 1).play;
~part1_meta1_player.stop;

~part1_meta2_player = ~part1_meta2.play;
~part1_meta2_player.stop;

~part1_meta3_player = ~part1_meta3.play;
~part1_meta3_player.stop;


~tuba1 = Synth(\tuba_proto, [\freq, 220.0, \out_bus, ~master_send]);
~tuba1.set(\freq, 440.0);
~tuba1.set(\freq, 880.0);
~tuba1.release;


(
~ottoni_part1_meta1_player = ~ottoni_part1_meta1.play;
~ottoni_part1_meta2_player = ~ottoni_part1_meta2.play;
~fl_part2_meta1_player = ~fl_part2_meta1.play;
)

~ottoni_part1_meta1_player.stop;
~ottoni_part1_meta2_player.stop;
~fl_part2_meta1_player.stop;

/*           ===============================================================
                                   work area
             ===============================================================          */


(
var start_time = 0, len = 20, end_time;

start_time = start_time + ~start_time_arr[0];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1 = TempoClock.new(1);
~global_part1.sched(start_time, {
	~part1_player = ~part1.play;
});
~global_part1.sched(end_time, {
	~part1_player.stop;
});


start_time = start_time + ~start_time_arr[1];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1.sched(start_time, {
	~part1_meta1_player = Pbindf(~part1_meta, \dur, 1).play;
});
~global_part1.sched(end_time, {
	~part1_meta1_player.stop;
});


start_time = start_time + ~start_time_arr[2];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1.sched(start_time, {
	~part1_meta2_player = ~part1_meta2.play;
});
~global_part1.sched(end_time, {
	~part1_meta2_player.stop;
});


start_time = start_time + ~start_time_arr[3];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1.sched(start_time, {
	~part1_meta3_player = ~part1_meta2.play;
});
~global_part1.sched(end_time, {
	~part1_meta3_player.stop;
});


start_time = start_time + ~start_time_arr[4];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1.sched(start_time, {
	~fl_part1_player = ~fl_part1.play;
});
~global_part1.sched(end_time, {
	~fl_part1_player.stop;
});

start_time = start_time + ~start_time_arr[5];
end_time = start_time + len;
[start_time, end_time].postln;
~global_part1.sched(start_time, {
	~ottoni_part1_meta1_player = ~ottoni_part1_meta1.play;
	~ottoni_part1_meta2_player = ~ottoni_part1_meta2.play;
	~fl_part2_meta1_player = ~fl_part2_meta1.play;
});
// ~global_part1.sched(end_time, {
// 	~fl_part1_player.stop;
// });
)

/*           ===============================================================
                                   finalize work
             ===============================================================          */

(
~master.free;
)