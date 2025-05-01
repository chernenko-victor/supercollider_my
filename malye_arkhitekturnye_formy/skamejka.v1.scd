////////////////////////////////////////////////////
//          init once area
//

(
MIDIClient.init;
~midi_out = MIDIOut(1);
~bbc_orch_volume_cc_num = 1;
~midi_note_arr1 = [60, 62, 65, 67, 70, 72, -1, -1, -1];
)


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

					~midi_out.noteOn(0, ~cor_part1_midi_pitch, 80);
				},
				{
					//
					("note muted | beat = "+beats).postln;
					delta = ~cor_part1_note_off;
					~cor_part1_note_off = 0;

					~midi_out.noteOff(0, ~cor_part1_midi_pitch, 80);
				}
			);
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
)