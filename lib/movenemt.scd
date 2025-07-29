////////////////////////////////////////////
//
//  movement
//

// include lib/stokhastic
// include lib/pitch_systems.v2
//
// parameters: movement type (see below), min_pitch, max_pitch, keypitch,
//
// 1 - random,
// + parameters: random_type (see lib/stokhastic)
//
// 2 - move,
// + parameters: step, direction (-1, 1)
//
// 3 - pedal
// + parameters: count, dispersion (0.0 - 1.0)
//


(
// Cl.
var
    movement_form
  , cl_min_pitch = 53
  , cl_max_pitch = 79
  , cl_keypitch = 65

  , cl_min_pitch_step
  , cl_max_pitch_step
  , cl_keypitch_step

  , random_type = 0
  , step = 1
  , direction = 1
  , count = 3
  , dispersion = 0.25
;

// movement_form = ~get_rand_val.(
// 	distr_type: 1
// 	, value_arr: #[1, 2, 3]
// );

movement_form = 1;

movement_form.postln;

/*
switch(movement_form)
	{1} {
		~cl_keypitch = ~get_rand_val.(
				distr_type: 2
				, min_val: cl_min_pitch
				, max_val: cl_max_pitch
		).asInteger;
	}
	{2} {
		nil;
	}
	{3} {
		nil;
	}
;
*/

~cl_part1 = TempoClock.new(1);

~cl_part1.sched(0, {
	var midi_pitch, indx;
	// movement_form.postln;
	switch(movement_form)
	{1} {
		indx = ~get_rand_val.(
				distr_type: 2
				, min_val: cl_min_pitch
				, max_val: cl_max_pitch
		).asInteger;
		midi_pitch = ~get_line_stepbased.(
			  step_arr: ~euro_diatonic_step1
			, base: cl_keypitch
			, indx: indx
		);
		midi_pitch.postln;
	}
	{2} {
		nil;
	}
	{3} {
		nil;
	}
	;
	1;
});
)

~cl_part1.stop;