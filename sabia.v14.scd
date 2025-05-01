/*           ===============================================================
                                   before start
             ===============================================================          */

//include C:\home\chernenko\src\supercollider\lib\common.scd
// and test audio

//include C:\home\chernenko\src\supercollider\lib\fx.scd
//include C:\home\chernenko\src\supercollider\lib\additive.scd
// include lib/temperament.scd
// include lib/record_part.scd

~master = Synth(\master_proto, [\in_bus, ~master_send]);

(
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

/*           ===============================================================
                                   work area
             ===============================================================          */

// (Pgeom(1, 2, 7) ++ Pgeom(10,0.5, 3)).asStream.nextN(10)

(
var start_time_arr_len = 10;
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
)



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
)

/*           ===============================================================
                                   finalize work
             ===============================================================          */

(
~master.free;
)