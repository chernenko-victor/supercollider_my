////////////////////////////////////////////////
//
// init once area
//
// include lib/common.scd
// and test audio
//
// include lib/fx.scd
// include lib/frequency_modulation.scd
//

(
MIDIClient.init;
~midi_out = MIDIOut(1);
~bbc_orch_volume_cc_num = 1;
~master = Synth(\master_proto, [\in_bus, ~master_send]);

~get_val = {
	arg
	      distr_type = 1
	    , value_arr = []
	    , min_val = 0.0
	    , max_val = 1.0
	    , weight_arr = []
	    , markov2d_arr = []
	;

	switch(distr_type)
	  {1} {
		//~midi_pitch1_resr_arr.choose;
		value_arr.choose;
	  }
	  {2} {
		min_val + ((max_val-min_val).rand);
	  }
	;

};

~min_dur = 0.25;
)

////////////////////////////////////////////////
//
// test
//

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

~get_val.value(value_arr: ~sin1_part1_curr_pitch_arr);

(
~get_val.value(
	  distr_type: 2
	, min_val: (8 * ~min_dur).asInteger
	, max_val: (40 * ~min_dur).asInteger

) * ~min_dur;
)


(
~get_val.value(
	  distr_type: 2
	, min_val: 0.4
	, max_val: 0.85

);
)

(
~get_val.value(
	  distr_type: 2
	, min_val: 0.1
	, max_val: 0.7

);
)



////////////////////////////////////////////////
//
// init and change (pitch, rythm etc)

(
~midi_pitch2_arr = [60, 62, 64];
~midi_pitch2_resr_arr = ~midi_pitch1_arr ++ [-1, -1, -1, -1];

~midi_pitch1_arr = [60, 62, 65, 67, 70, 72];
~midi_pitch1_resr_arr = ~midi_pitch1_arr ++ [-1, -1, -1];


)

////////////////////////////////////////////////
//
// play

(
~sin1_part1_curr_pitch_arr = ~midi_pitch2_resr_arr;

~note_on = 0;
~sin1_part1_next_start = ~get_val.value(
	  distr_type: 2
	, min_val: (8 * ~min_dur).asInteger
	, max_val: (40 * ~min_dur).asInteger

) * ~min_dur;

~sin1_part1_legato = ~get_val.value(
	  distr_type: 2
	, min_val: 0.4
	, max_val: 0.85

);
~sin1_part1_midi_pitch = ~get_val.value(value_arr: ~sin1_part1_curr_pitch_arr);

~sin1_part1 = TempoClock.new(1);
~sin1_part1.sched(0, {
	arg ...args;
	var len, amp;
	args.postln;

	if(
		~note_on == 0,
		{
			~note_on = 1;

			// duration
			//dur_arr = ~get_next_start_and_legato.value();
			~sin1_part1_next_start = ~get_val.value(
				distr_type: 2
				, min_val: (8 * ~min_dur).asInteger
				, max_val: (40 * ~min_dur).asInteger

			) * ~min_dur;

			~sin1_part1_legato = ~get_val.value(
				distr_type: 2
				, min_val: 0.4
				, max_val: 0.85

			);
			len = ~sin1_part1_next_start * ~sin1_part1_legato;

			// frq
			~sin1_part1_midi_pitch = ~get_val.value(value_arr: ~sin1_part1_curr_pitch_arr);

			// amp
			if(
				~sin1_part1_midi_pitch == -1,
				{
					amp = 0;
				},
				{
					amp = ~get_val.value(
						distr_type: 2
						, min_val: 0.1
						, max_val: 0.7

					);
				}
			);
			~midi_out.control(0, ~bbc_orch_volume_cc_num, amp * 127);

			// sound on
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
		{
			// duration
			~note_on = 0;
			len = ~sin1_part1_next_start * (1 - ~sin1_part1_legato);

			// sound off
			~tuba1.release();
			~midi_out.noteOff(0, ~sin1_part1_midi_pitch, 80);
		}
	);

	len;
});
)

////////////////////////////////////////////////
//
// stop

(
    ~sin1_part1.stop;
    ~midi_out.allNotesOff(0);
    ~tuba1.release();
)

////////////////////////////////////////////////
//
// finalize

(
    ~master.free;
)