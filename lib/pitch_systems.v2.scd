(
// step amount in halftone in 12et
~euro_diatonic_step1 = [2, 2, 1, 2, 2, 2, 1];
)

(
~get_line_stepbased = {
	arg step_arr, base, indx;
	var res = base;

	if(
		indx > 0,
		{
			indx.do({
				arg val, indx_curr;
				//("indx_curr = "+indx_curr).postln;
				//("res before = "+res).postln;
				//(step_arr.wrapAt(indx_curr)).postln;
				res = res + step_arr.wrapAt(indx_curr);
				//("res after = "+res).postln;
			});
		}
	);
	if(
		indx < 0,
		{
			(-1 *indx).do({
				arg val, indx_curr;
				//("indx_curr = "+indx_curr).postln;
				//("res before = "+res).postln;
				(step_arr.wrapAt(indx_curr)).postln;
				res = res - step_arr.wrapAt(-1 * (indx_curr + 1));
				//("res after = "+res).postln;
			});
		}
	);

	res;
};

~get_step_by_midi_pitch = {
	arg step_arr, base, min_pitch, max_pitch;
	var res = [nil, nil], indx = 0;

	// finding max step
	while (
		{
			~get_line_stepbased.(step_arr, base, indx) <= max_pitch;
		},
		{
			indx = indx + 1;
		}
	);
	res[0] = indx;

	indx = 0;
	// finding min step
	while (
		{
			~get_line_stepbased.(step_arr, base, indx) >= min_pitch;
		},
		{
			indx = indx - 1;
		}
	);
	res[1] = indx;

	res;
};
)

// ~get_line_stepbased.(~euro_diatonic_step1, 0, -9);

(
var
    cl_min_pitch = 53
  , cl_max_pitch = 79
  , cl_keypitch = 65
;

~get_step_by_midi_pitch.(
	step_arr: ~euro_diatonic_step1
  , base: cl_keypitch
  , min_pitch: cl_min_pitch
  , max_pitch: cl_keypitch
);

//something wrong
)