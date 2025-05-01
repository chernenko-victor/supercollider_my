/*           ===============================================================
                                   before start
             ===============================================================          */

//include C:\home\chernenko\src\supercollider\lib\common.scd
// and test audio

//include C:\home\chernenko\src\supercollider\lib\stokhastic.scd
//include C:\home\chernenko\src\supercollider\lib\fx.scd
//include C:\home\chernenko\src\supercollider\lib\additive.scd
//include C:\home\chernenko\src\supercollider\lib\sample.scd

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);

~midi_pitch_arr = Array.fill(20, {
	arg indx;
	if(
		0.85.coin,
		{
			rand((indx+1) * 3) + ((indx+1) * 2) + 32;
		},
		{
			Rest(0)
		}
	);
});
~midi_pitch_ptrn = Pseq(~midi_pitch_arr, inf);

~midi_pitch_modified_ptrn = Ppatlace([
	~midi_pitch_ptrn,
	Prand(~midi_pitch_arr, inf)
], inf);

~midi_chord_ptrn = Ptuple([
	~midi_pitch_ptrn,
	~midi_pitch_ptrn + 2,
	~midi_pitch_ptrn + 5,
], inf);

~part1_bass_arpeggiato = Pbind(
	\instrument, Prand(
		[\default, \add_synth_percussion_proto],
		inf
	),
	\out_bus, ~master_send,
	\freq, ~midi_pitch_ptrn,
	\dur, 0.1
);

~part1_bass_arpeggiato_modified = Pbind(
	\instrument, Prand(
		[\default, \add_synth_percussion_proto],
		inf
	),
	\out_bus, ~master_send,
	\freq, ~midi_pitch_modified_ptrn,
	\dur, 0.1
);
)

/*           ===============================================================
                                   test area
             ===============================================================          */


(
~add_synth_percussion1 = Synth(\add_synth_percussion_proto, [
	\out_bus, ~master_send,
	\freq, ~equal_distr.(220, 660),
	\amp, ~lin_min_distr.(0.1, 0.8),
	\attc_time, ~lin_min_distr.(0.01, 0.08),
	\release_time, ~tri_distr.(0.06, 0.3)
]);
)

~part1_bass_arpeggiato_player = ~part1_bass_arpeggiato.play;
~part1_bass_arpeggiato_player.stop;


~part1_bass_arpeggiato_modified_player = ~part1_bass_arpeggiato_modified.play;
~part1_bass_arpeggiato_modified_player.stop;


/////////////////////////////////////////
(
~player1 = Synth(\player_proto, [
	\buf, ~arturia1_buf,
	// \out_bus, ~master_send
	\out_bus, ~rev_send
]);
)



(
~revv1 = Synth(\revv_proto, [
	\out_bus, ~master_send,
	\in_bus, ~rev_send
]);
)


~revv1.free;
~player1.free;


////////////////////
(
~granulator2 = Synth(\granulator2_proto, [
	\buf, ~arturia1_mono_buf,
	// \out_bus, ~master_send
	\out_bus, ~rev_send
]);
)

~granulator2.set(\trig_dur, 1);


/*           ===============================================================
                                   work area
             ===============================================================          */


/*           ===============================================================
                                   finalize work
             ===============================================================          */

(
~master.free;
)