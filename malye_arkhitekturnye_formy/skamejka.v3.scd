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

////////////////////////////////////////////////
//
// init and change (pitch, rythm etc)

(
~midi_pitch1_arr = [60, 62, 65, 67, 70, 72, -1, -1, -1];
)

////////////////////////////////////////////////
//
// play

(
~note_on = 0;
~sin1_part1_next_start = 2;
~sin1_part1_legato = 0.8;
~sin1_part1_midi_pitch = ~midi_pitch1_arr.choose;

~sin1_part1 = TempoClock.new(1);
~sin1_part1.sched(0, {
	arg ...args;
	var len, amp;
	args.postln;

	if(
		~note_on == 0,
		{
			~note_on = 1;
			~sin1_part1_next_start = (2 + 8.rand) / 4;
			~sin1_part1_legato = 0.8;
			len = ~sin1_part1_next_start * ~sin1_part1_legato;

			// frq
			~sin1_part1_midi_pitch = ~midi_pitch1_arr.choose;

			// amp
			if(
				~sin1_part1_midi_pitch == -1,
				{
					amp = 0;
				},
				{
					amp = 0.1 + (0.5.rand);
				}
			);

			// sound on
			/*
			~sin1 = Synth(\sin_proto, [
				  \attackTime, len * 0.07
				, \decayTime, len * 0.02
				, \releaseTime, (~sin1_part1_legato * 0.25)
				, \amp, amp
				, \frq, ~sin1_part1_midi_pitch.midicps
			]);
			*/

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
			~note_on = 0;
			len = ~sin1_part1_next_start * (1 - ~sin1_part1_legato);

			// sound off
			//~sin1.release();
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
    //~sin1.release();
    ~tuba1.release();
)

////////////////////////////////////////////////
//
// finalize