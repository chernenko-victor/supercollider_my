////////////////////////////////////////////////////////////////////////////////
//                                                                           ///
//                                 skamejka                                  ///
//                                                                           ///
//                                                                           ///
//                   from "malye_arkhitekturnye_formy" cycle                 ///
//                                                                           ///
//                        generative electronic music                        ///
//                                                                           ///
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////
//
// init once area
//
// include lib/common.scd
// and test audio
//
// include lib/fx.scd
// include lib/frequency_modulation.scd
// include lib/stokhastic
//
// patch sends midi message, select MIDI device (as argument for MIDIOut), channel number, CC number etc
//

(
MIDIClient.init;
~midi_out = MIDIOut(2);
~bbc_orch_volume_cc_num = 1;
~master = Synth(\master_proto, [\in_bus, ~master_send]);

~min_dur = 0.25;
)

////////////////////////////////////////////////
//
// init and change (pitch, rythm etc)

(
~midi_pitch2_arr = [60, 62, 64];
~midi_pitch2_resr_arr = ~midi_pitch2_arr ++ [-1, -1, -1];

~midi_pitch1_arr = [60, 62, 65, 67, 70, 72];
~midi_pitch1_resr_arr = ~midi_pitch1_arr ++ [-1, -1];

~midi_pitch3_arr = [60, 62, 65, 67, 70, 72]-2;
~midi_pitch3_resr_arr = ~midi_pitch3_arr ++ [-1];


~midi_pitch4_arr = [60, 62, 64, 67, 69, 72]+2;
~midi_pitch4_resr_arr = ~midi_pitch4_arr ++ [-1];

~midi_pitch5_arr = [60, 62, 64, 67, 69, 72]+3;
~midi_pitch5_resr_arr = ~midi_pitch5_arr ++ [-1];

)


////////////////////////////////////////////////
//
// test
//

(
~ob1 = Synth(\add_synth_long_proto, [
	  \freq: 220.rand + 220
	, \out_bus, ~master_send
	, \attackTime, 0.07
	, \decayTime, 0.02
	, \releaseTime, 0.01
	, \amp: 0.5
	, \pos: 0.5
]);
)

~ob1.release;

(
~tuba1 = Synth(
	\tuba_proto,
	[
		\freq, 220 + 220.rand
		//, \freq, 62.midicps
		//, \out_bus, ~record_bus1
		, \out_bus, ~master_send
		, \attackTime, 0.02
	    , \decayTime, 0.05
	    , \releaseTime, 0.5
	    , \amp, 0.05 + (0.5.rand)
    ]
);
)

~tuba1.release();

~get_rand_val.value(value_arr: ~midi_pitch2_resr_arr);

(
~get_rand_val.value(
	  distr_type: 2
	, min_val: (8 * ~min_dur).asInteger
	, max_val: (40 * ~min_dur).asInteger

) * ~min_dur;
)


(
~get_rand_val.value(
	  distr_type: 2
	, min_val: 0.4
	, max_val: 0.85

);
)

(
~get_rand_val.value(
	  distr_type: 2
	, min_val: 0.1
	, max_val: 0.7

);
)



////////////////////////////////////////////////
//
// play

/* ============================================
part spesified variables form like <instr_name>_<part_name>_<functionality>, e.g. ~sin1_part1_midi_pitch means "MIDI pitches for part 1 of instrument 'sin1'"

a part works on TempoClock's schedule
When ~<instr_name>_<part_name>_note_on equals to 1, schedule anonymous function:
1. calculate frequency, next start of sound (stores to ~<instr_name>_<part_name>_next_start), duration, amplutude,
2. begins sounding.

When ~<instr_name>_<part_name>_note_on equals to 0, schedule anonymous function:
1. turms off sound,
2. calculate time to next "note on" basing on valuse last stored in "~<instr_name><part_name>_next_start" variable

==== Duration ===
Duration (or lenght) of sounding event (note, changing timbre, changing dynamic etc.) there calculated like

len = ~<instr_name>_<part_name>_next_start * ~<instr_name>_<part_name>_legato; // note on

or

len = ~<instr_name>_<part_name>_next_start * (1 - ~<instr_name>_<part_name>_legato); // note off


==== Pitch ===

For Cor. part pitches brings from arrays "~midi_pitch<number>_arr" Later these arrays concatenate with some number of "-1", which denotes pause.

In variable ~<instr_name>_<part_name>_curr_pitch_arr there is reference tu current pitches array. Current midi pitch brings like this

// ======= frq =======
~<instr_name>_<part_name>_midi_pitch = ~get_rand_val.value(value_arr: ~<instr_name>_<part_name>_curr_pitch_arr);

Function "get_rand_val" from lib/stokhastik.csd gets different types of random distribution.


==== Amp ===

2DO

==== Parameters changes ===

2DO


=============================================== */

// =============================================================
// ===================== Cor I. part 1 init ====================
// =============================================================
(
~sin1_part1_curr_pitch_arr = ~midi_pitch2_resr_arr;

~sin1_part1_note_on = 0;
~sin1_part1_next_start = ~get_rand_val.value(
	  distr_type: 2
	, min_val: (8 * ~min_dur).asInteger
	, max_val: (40 * ~min_dur).asInteger

) * ~min_dur;

~sin1_part1_legato = ~get_rand_val.value(
	  distr_type: 2
	, min_val: 0.4
	, max_val: 0.85

);
~sin1_part1_midi_pitch = ~get_rand_val.value(value_arr: ~sin1_part1_curr_pitch_arr);

// ===================== Cor I. part 1 play =====================

~sin1_part1 = TempoClock.new(1);
~sin1_part1.sched(0, {
	arg ...args;
	var len, amp;
	//args.postln;

	if(
		~sin1_part1_note_on == 0,
		{
			~sin1_part1_note_on = 1;

			// ======= duration =======
			//dur_arr = ~get_next_start_and_legato.value();
			~sin1_part1_next_start = ~get_rand_val.value(
				distr_type: 2
				, min_val: (8 * ~min_dur).asInteger
				, max_val: (80 * ~min_dur).asInteger

			) * ~min_dur;
			("~sin1_part1_next_start = "+~sin1_part1_next_start).postln;

			~sin1_part1_legato = ~get_rand_val.value(
				distr_type: 2
				, min_val: 0.4
				, max_val: 0.85

			);
			len = ~sin1_part1_next_start * ~sin1_part1_legato;

			// ======= frq =======
			~sin1_part1_midi_pitch = ~get_rand_val.value(value_arr: ~sin1_part1_curr_pitch_arr);

			// ======= amp =======
			if(
				~sin1_part1_midi_pitch == -1,
				{
					amp = 0;
				},
				{
					amp = ~get_rand_val.value(
						distr_type: 2
						, min_val: 0.1
						, max_val: 0.7

					);
				}
			);
			~midi_out.control(0, ~bbc_orch_volume_cc_num, amp * 127);

			// ======= sound on =======
			~tuba1 = Synth(
				\tuba_proto,
				[
					  \freq, ~sin1_part1_midi_pitch.midicps
					, \out_bus, ~master_send
					, \attackTime, len * 0.07
					, \decayTime, len * 0.02
					, \releaseTime, ~sin1_part1_legato * 0.25
					, \amp, amp
				]
			);

			~midi_out.noteOn(0, ~sin1_part1_midi_pitch, 80);
		},
		// ======= note off =======
		{
			// ======= duration =======
			~sin1_part1_note_on = 0;
			len = ~sin1_part1_next_start * (1 - ~sin1_part1_legato);

			// ======= sound off =======
			~tuba1.release();
			~midi_out.noteOff(0, ~sin1_part1_midi_pitch, 80);
		}
	);

	len;
});

// ===================== Cor I. part 1 changes =====================

~sin1_part1_changes = TempoClock.new(1);
~sin1_part1_changes.sched(0, {
	arg ...args;
	//args.postln;
	args[0].postln;
	//((args[0] >= 10)&&(args[0] < (10 + ~min_dur))).postln;
	case
	  {
		(args[0] >= 40)&&(args[0] < (40 + ~min_dur))
	  }
	  {
		"=============== change pitch 1".postln;
		~sin1_part1_curr_pitch_arr = ~midi_pitch1_resr_arr;
	  }
      // ===
	  {
		(args[0] >= 80)&&(args[0] < (80 + ~min_dur))
	  }
	  {
		"=============== change pitch 2".postln;
		~sin1_part1_curr_pitch_arr = ~midi_pitch3_resr_arr;
	  }
	;

	~min_dur;
});
)

// ===================== Cor I. part 1 stop =====================
(
    ~sin1_part1.stop;
    ~sin1_part1_changes.stop;
    ~midi_out.allNotesOff(0); // if notes stuck in channel 1
    ~tuba1.release();
)


// =============================================================
// ===================== Ob. part 2 init ====================
// =============================================================
(


///////////////////////////////////////////////////////////////
//////                                               //////////
//////           Something wrong with 2 voices       //////////
//////                                               //////////
///////////////////////////////////////////////////////////////



~ob_part2_midi_chn = 1;
~ob_part2_min_val = 50;
~ob_part2_max_val = 60;
~ob_part2_start = 0;

~ob_part2_curr_pitch_arr = ~midi_pitch4_resr_arr;

~ob_part2_note_on = 0;
~ob_part2_next_start = ~get_rand_val.value(
	  distr_type: 2
	, min_val: (~ob_part2_min_val * ~min_dur).asInteger
	, max_val: (~ob_part2_max_val * ~min_dur).asInteger

) * ~min_dur;

~ob_part2_legato = ~get_rand_val.value(
	  distr_type: 2
	, min_val: 0.8
	, max_val: 0.95

);
~ob_part2_midi_pitch_arr = Array.fill(2, {0});
~ob_part2_midi_pitch_arr[0] = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);
~ob_part2_midi_pitch_arr[1] = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);
//~ob_part2_midi_pitch = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);

// ===================== Ob. part 2 play =====================

~ob_part2 = TempoClock.new(1);
~ob_part2.sched(0, {
	arg ...args;
	var len, amp;
	//args.postln;

	if(
		~ob_part2_note_on == 0,
		{
			~ob_part2_note_on = 1;

			// ======= duration =======
			//dur_arr = ~get_next_start_and_legato.value();
			~ob_part2_next_start = ~get_rand_val.value(
				distr_type: 2
				, min_val: (8 * ~min_dur).asInteger
				, max_val: (80 * ~min_dur).asInteger

			) * ~min_dur;
			("~ob_part2_next_start = "+~ob_part2_next_start).postln;


			~ob_part2_legato = ~get_rand_val.value(
				distr_type: 2
				, min_val: 0.4
				, max_val: 0.85

			);
			len = ~ob_part2_next_start * ~ob_part2_legato;

			// ======= frq =======
			//~ob_part2_midi_pitch = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);

			~ob_part2_midi_pitch_arr[0] = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);
			~ob_part2_midi_pitch_arr[1] = ~get_rand_val.value(value_arr: ~ob_part2_curr_pitch_arr);
			("~ob_part2_midi_pitch = "+~ob_part2_midi_pitch_arr[0]).postln;

			// ======= amp =======
			if(
				//~ob_part2_midi_pitch == -1,
				~ob_part2_midi_pitch_arr[0] == -1 || ~ob_part2_midi_pitch_arr[1] == -1 ,
				{
					amp = 0;
				},
				{
					amp = ~get_rand_val.value(
						distr_type: 2
						, min_val: 0.05
						, max_val: 0.35

					);
				}
			);
			~midi_out.control(~ob_part2_midi_chn, ~bbc_orch_volume_cc_num, amp * 127);

			// ======= sound on =======
			/*
			~ob1 = Synth(\add_synth_long_proto, [
				\freq: ~ob_part2_midi_pitch.midicps
				, \out_bus, ~master_send
				, \attackTime, len * 0.07
				, \decayTime, len * 0.02
				, \releaseTime, ~ob_part2_legato * 0.25
				, \amp: amp
				, \pos: 0.5
			]);

			~midi_out.noteOn(~ob_part2_midi_chn, ~ob_part2_midi_pitch, 80);
			*/

			~ob1_1 = Synth(\add_synth_long_proto, [
				\freq: ~ob_part2_midi_pitch_arr[0].midicps
				, \out_bus, ~master_send
				, \attackTime, len * 0.07
				, \decayTime, len * 0.02
				, \releaseTime, ~ob_part2_legato * 0.25
				, \amp: amp
				, \pos: 0.5
			]);

			~ob1_2 = Synth(\add_synth_long_proto, [
				\freq: ~ob_part2_midi_pitch_arr[1].midicps
				, \out_bus, ~master_send
				, \attackTime, len * 0.07
				, \decayTime, len * 0.02
				, \releaseTime, ~ob_part2_legato * 0.25
				, \amp: amp
				, \pos: 0.5
			]);

			if(
				amp != 0,
				{
					~midi_out.noteOn(~ob_part2_midi_chn, ~ob_part2_midi_pitch_arr[0], 80);
					~midi_out.noteOn(~ob_part2_midi_chn, ~ob_part2_midi_pitch_arr[1], 80);
				}
			);

		},
		// ======= note off =======
		{
			// ======= duration =======
			~ob_part2_note_on = 0;
			len = ~ob_part2_next_start * (1 - ~ob_part2_legato);

			// ======= sound off =======
			~ob1_1.release();
			~ob1_2.release();
			~midi_out.noteOff(~ob_part2_midi_chn, ~ob_part2_midi_pitch_arr[0], 80);
			~midi_out.noteOff(~ob_part2_midi_chn, ~ob_part2_midi_pitch_arr[1], 80);
		}
	);

	len;
});

// ===================== Ob. part 2 changes =====================

~ob_part2_changes = TempoClock.new(1);
~ob_part2_changes.sched(0, {
	arg ...args;
	//args.postln;
	//args[0].postln;
	case
	  {
		(args[0] >= (~ob_part2_start + 40))&&(args[0] < (~ob_part2_start + 40 + ~min_dur))
	  }
	  {
		"=============== Ob. change pitch ~midi_pitch5_resr_arr".postln;
		~ob_part2_curr_pitch_arr = ~midi_pitch5_resr_arr;
	  }
      // ===
	  {
		(args[0] >= (~ob_part2_start + 80))&&(args[0] < (~ob_part2_start + 80 + ~min_dur))
	  }
	  {
		"=============== Ob. change pitch ~midi_pitch1_resr_arr".postln;
		~ob_part2_curr_pitch_arr = ~midi_pitch2_resr_arr;
	  }
	;

	~min_dur;
});
)

// ===================== Ob. part 2 stop =====================
(
    ~ob_part2.stop;
    ~ob_part2_changes.stop;
    ~midi_out.allNotesOff(~ob_part2_midi_chn); // if notes stuck in channel 2
    ~ob1_1.release();
    ~ob1_2.release();
)


////////////////////////////////////////////////
//
// stop


////////////////////////////////////////////////
//
// finalize

(
    ~master.free;
)