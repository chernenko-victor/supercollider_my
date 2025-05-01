// ==============           NOTE               =================
// weird bug with pause, better use zero amplitude
// see skamejka.v3.scd
// =============================================================

////////////////////////////////////////////////////
//          init once area
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
~midi_note_arr1 = [60, 62, 65, 67, 70, 72, -1, -1, -1];
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)


////////////////////////////////////////////////////
//
//  test

(
~tuba1 = Synth(
	\tuba_proto,
	[
		//\freq, 220 + 220.rand,
		\freq, 62.midicps,
		// \out_bus, ~record_bus1
		\out_bus, ~master_send
    ]
);
)

~tuba1.release();

////////////////////////////////////////////////////
//          work area :: start
//



(
~cor_part1_note_off = 0;
~cor_part1_midi_pitch = ~midi_note_arr1.choose;
//  ========= Cor I. =============
~cor_part1 = TempoClock.new(1);
~cor_part1.sched(0, {
	arg ...args;
	var delta, beats, legato, midi_pitch; //, cc3_value;
	beats = args[0];
	delta = 2;
	legato = 0.8;

	("beat = "+beats+" ~cor_part1_midi_pitch = "+~cor_part1_midi_pitch+" ~cor_part1_note_off = "+~cor_part1_note_off).postln;

	// note
	if(
		~cor_part1_midi_pitch != -1,
		{
			if(
				~cor_part1_note_off == 0,
				{
					//
					("note sounding | beat = "+beats).postln;
					~cor_part1_note_off = delta * (1 - legato);
					delta = delta * legato;

					~cor_part1_midi_pitch = ~midi_note_arr1.choose;

					//~midi_out.noteOn(0, ~cor_part1_midi_pitch, 80);
					~tuba1 = Synth(
						\tuba_proto,
						[
							\freq, ~cor_part1_midi_pitch.midicps,
							// \out_bus, ~record_bus1
							\out_bus, ~master_send
						]
					);
				},
				{
					//
					("note muted | beat = "+beats).postln;
					delta = ~cor_part1_note_off;
					~cor_part1_note_off = 0;

					//~midi_out.noteOff(0, ~cor_part1_midi_pitch, 80);
					~tuba1.release();
				}
			);
	    },
		{
			~cor_part1_midi_pitch = ~midi_note_arr1.choose;
		}
	);


    if(beats > 90, {
	    ~cor_part1.stop;
	    ~midi_out.allNotesOff(0);
    });

	delta;
});
)

////////////////////////////////////////////////////
//          finalize all
//
(
    ~cor_part1.stop;
    ~midi_out.allNotesOff(0);
    ~tuba1.release();
    ~master.free;
)