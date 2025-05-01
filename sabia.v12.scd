/////////////////////////
// setup
//
// REAPER sabia.n11.v7 -> loop midi -> Super Collider::sabia.v12.scd -> record per track -> insert into Reaper
//
// 2DO: Ottoni
//
////////////////////////

////////////////////////
// prepare
//
//
// include lib/temperament.scd
// include lib/fx.scd
// include lib/additive.scd
//

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);

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

~recorder1 = Recorder.new(s);
~recorder1.prepareForRecord("C:/home/chernenko/audio/music/chernenko/sabia_n11/Media/fl_sc_synth.v3.wav", 2);
~recorder1.recHeaderFormat = "wav";
~recorder1.recSampleFormat = "int24";

~record_bus1 = Bus.audio(s, 2);
)

(
MIDIClient.init;
MIDIIn.connectAll;
)

///////////////
// test area

~fl_part1_player = ~fl_part1.play;
~fl_part1_player.stop;

(
~add_synth_percussion1 = Synth(
	\add_synth_percussion_proto,
	[
		\freq, 220 + 220.rand,
		// \out_bus, ~record_bus1
		\out_bus, ~master_send
    ]
);
)


(
~sqr_var_adsr1 = Synth(
	\sqr_var_adsr_proto,
	[
		\freq, 220 + 220.rand,
		// \out_bus, ~record_bus1
		\out_bus, ~master_send
    ]
);
)

~sqr_var_adsr1.release();

//////////////
~recorder1.record(bus: ~record_bus1);

~recorder1.stopRecording;
~recorder1.free;

(
~midi_intr_arr = Array2D.new(10, 128);
/*~midi_intr_arr[3,2] = 1;
~midi_intr_arr[3,2].post;*/

~on_func = MIDIFunc.noteOn({
	arg ...args_arr;
	var vel, pitch, chn;
	// args_arr.postln;
	vel = args_arr[0];
	pitch = args_arr[1];
	chn = args_arr[2] + 1;

	switch(chn,
		1, {
			// args_arr.postln;
			// ============ NB distort on fast passage
			// Synth(\add_synth_percussion_proto, [\freq, 220 + 220.rand]);
			Synth(\add_synth_percussion_proto, [
				// \freq, 220 + 220.rand
				\freq, pitch.midicps,
				\amp, vel / 127.0 / 2.0,
				// \out_bus, ~record_bus1,
				\out_bus, ~master_send,
				\attc_time, 0.05 + (0.1.rand),
				\release_time, 0.07 + (0.3.rand)
			]);
		},
		2, {
			~midi_intr_arr[chn-1, pitch] = Synth(
				\sqr_var_adsr_proto,
				[
					\freq, pitch.midicps,
					\amp, vel / 127.0 / 2.0,
					// \out_bus, ~record_bus1
					\out_bus, ~master_send
				]
			);
		},
		3, {
			~midi_intr_arr[chn-1, pitch] = Synth(
				\sqr_var_adsr_proto,
				[
					\freq, pitch.midicps,
					\amp, vel / 127.0 / 2.0,
					// \out_bus, ~record_bus1
					\out_bus, ~master_send
				]
			);
		}
	);
});

~off_func = MIDIFunc.noteOff({
	arg ...args_arr;
	var vel, pitch, chn;
	//  args_arr.postln;
	vel = args_arr[0];
	pitch = args_arr[1];
	chn = args_arr[2] + 1;

	switch(chn,
		// 1, {},
		2, {
			"release".postln;
			args_arr.postln;
			~midi_intr_arr[chn-1, pitch].release;
		},
		3, {
			"release".postln;
			args_arr.postln;
			~midi_intr_arr[chn-1, pitch].release;
		}
	);
});
)

(
~on_func.free;
~off_func.free;
~master.free;
~record_bus1.free;
)