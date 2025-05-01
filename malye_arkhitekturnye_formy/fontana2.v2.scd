////////////////////////////////////////////////////
//          init once area
//

(
MIDIClient.init;
~midi_out = MIDIOut(1);
~bbc_orch_volume_cc_num = 1;
)

////////////////////////////////////////////////////
//          test area
//


//~midi_out.noteOn(0, 61, 80);
//~midi_out.noteOff(0, 61, 80);

// (
// ~part1_started = Array.fill(8, {0});
// )
//
// (
// ~part1 = TempoClock.new(1);
//
// ~part1.sched(0, {
// 	if(
// 		~part1_started[0] == 0,
// 		{
// 			~part1_started[0] = ([60, 62, 65, 67, 70, 72].choose)+1;
// 			~midi_out.noteOn(0, ~part1_started[0], 80);
// 		},
// 		{
// 			~midi_out.noteOff(0, ~part1_started[0], 80);
// 			~part1_started[0] = 0;
// 		}
// 	);
// 	1;
// });
// )
//
// (
// ~part1.stop;
// ~midi_out.allNotesOff(1);
// )


// (1 > 10) && (5 == 6)


////////////////////////////////////////////////////
//          reinit area
//


//  ========= Fl. =============
(
~midi_note_arr1 = [60, 62, 65, 67, 70, 72];
~dur_arr = [1, 1.5, 2, 3, 4, 8, 16, 32];
~min_dur = 0.25;
~fl_part2_started = Array.fill(8, {0});
~fl_part2_prase_len = 0;
~fl_part2_pause_after = 5.rand + 5;
~fl_part2_change_arr = Array.fill(8, {0});
//)

//  ========= Pf. =============
//(
~midi_note_arr3 = [60, 63, 67, 81, 84, 88]-12;
~dur_arr3 = [1, 1.5, 2, 3, 4, 8, 16, 32];
~min_dur3 = 0.25;
~pf_part3_started = Array.fill(8, {0});
~pf_part3_prase_len = 0;
~pf_part3_pause_after = 5.rand + 5;
~pf_part3_change_arr = Array.fill(8, {0});
)

////////////////////////////////////////////////////
//          work area :: start
//

(
//  ========= Fl. =============
~fl_part2 = TempoClock.new(1);

~fl_part2.sched(0, {
	arg ...args;
	var delta, beats, cc3_value;
	beats = args[0];
	cc3_value = (sin(beats%(10))+1)*64;
	~midi_out.control(0, ~bbc_orch_volume_cc_num, cc3_value);
	args.postln;
	/*if(
		beats
	);*/
	case
	    {(beats > 20) && (~fl_part2_change_arr[0] == 0)} {
		    ~fl_part2_change_arr[0] = 1;
		    ~midi_note_arr1 = ~midi_note_arr1 + 2;
		    "Fl. caesura 1".postln;
		    ~midi_note_arr1.postln;
	    }
	    {(beats > 40) && (~fl_part2_change_arr[1] == 0)} {
		    ~fl_part2_change_arr[1] = 1;
		    ~midi_note_arr1 = ~midi_note_arr1 + 1;
		    "Fl. caesura 2".postln;
		    ~midi_note_arr1.postln;
	    }
	    //{} {}
	    //{} {}
	;
	if(
		~fl_part2_started[0] == 0,
		{
			~fl_part2_next_start = ~dur_arr.choose * ~min_dur;
			~fl_part2_dur = (((90.rand) + 9) / 100);
			~fl_part2_dur = ~fl_part2_next_start * ~fl_part2_dur;

			delta = ~fl_part2_dur;
			~fl_part2_started[0] = (~midi_note_arr1.choose)+12;
			("Fl. midi note = "+~fl_part2_started[0]).postln;
			// === rest ===
			~fl_part2_prase_len = ~fl_part2_prase_len + 1;
			if(
				~fl_part2_prase_len == ~fl_part2_pause_after,
				{
					~fl_part2_prase_len = 0;
					~fl_part2_pause_after = 5.rand + 5;
					"Fl. pause".postln;
				},
				{
					~midi_out.noteOn(0, ~fl_part2_started[0], 80);
				}

			);
			// (5.rand + 5) //
		},
		{
			delta = ~fl_part2_next_start - ~fl_part2_dur;
			~midi_out.noteOff(0, ~fl_part2_started[0], 80);
			~fl_part2_started[0] = 0;
		}
	);
	delta;
});
//)

//  ========= Pf. =============
//(
~pf_part3 = TempoClock.new(1);

~pf_part3.sched(30, {
	arg ...args;
	var delta, beats, cc3_value, voice_total, i;
	beats = args[0];
	cc3_value = (sin(beats%(10))+1)*64;
	~midi_out.control(1, ~bbc_orch_volume_cc_num, cc3_value);
	args.postln;
	case
	    {(beats > 30) && (~pf_part3_change_arr[0] == 0)} {
		    ~pf_part3_change_arr[0] = 1;
		    ~midi_note_arr3 = ~midi_note_arr3 - 6;
		    "Pf. caesura 1".postln;
		    ~midi_note_arr3.postln;
	    }
	    {(beats > 60) && (~pf_part3_change_arr[1] == 0)} {
		    ~pf_part3_change_arr[1] = 1;
		    ~midi_note_arr3 = ~midi_note_arr3 + 4;
		    "Pf. caesura 2".postln;
		    ~midi_note_arr3.postln;
	    }
	    //{} {}
	    //{} {}
	;
	if(
		~pf_part3_started[0] == 0,
		{
			~pf_part3_next_start = ~dur_arr3.choose * ~min_dur3;
			~pf_part3_dur = (((90.rand) + 9) / 100);
			~pf_part3_dur = ~pf_part3_next_start * ~pf_part3_dur;

			delta = ~pf_part3_dur;
			~pf_part3_started[0] = ~midi_note_arr3.choose;
			// ("Pf. midi note = "+~pf_part3_started[0]).postln;
			// === rest ===
			~pf_part3_prase_len = ~pf_part3_prase_len + 1;
			if(
				~pf_part3_prase_len == ~pf_part3_pause_after,
				{
					~pf_part3_prase_len = 0;
					~pf_part3_pause_after = 5.rand + 5;
					// "Pf. pause".postln;
				},
				{
					voice_total = 4.rand + 1;
					i = 0;
					while(
						{i < voice_total}, {
							~pf_part3_started[i] = ~midi_note_arr3.choose;
							~midi_out.noteOn(1, ~pf_part3_started[i], 80);
							i = i + 1;
						}
					);
					/*~pf_part3_started[0] = ~midi_note_arr3.choose;
							~midi_out.noteOn(1, ~pf_part3_started[0], 80);*/
				}

			);
			// (5.rand + 5) //
		},
		{
			delta = ~pf_part3_next_start - ~pf_part3_dur;
			i = 0;
			while(
				{i < 8}, {
					~midi_out.noteOff(1, ~pf_part3_started[i], 80);
					~pf_part3_started[i] = 0;
					i = i + 1;
				}
			);
			/*~midi_out.noteOff(1, ~pf_part3_started[0], 80);
			~pf_part3_started[0] = 0;*/
		}
	);
	delta;
});
)

////////////////////////////////////////////////////
//          finalize all
//

(
~fl_part2.stop;
~midi_out.allNotesOff(0);
)
(
~pf_part3.stop;
~midi_out.allNotesOff(0);
)
