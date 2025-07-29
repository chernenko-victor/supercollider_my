(
// relative midi pitch system (rmps)
// ...


// step amount in halftone in 12et
~euro_diatonic_step1 = [2, 2, 1, 2, 2, 2, 1];

~get_midi_pitch_from_step_and_keypitch = {
	arg step_arr, keypitch = 0;
	var res_arr, curr_pitch;
	res_arr = Array.newClear(step_arr.size + 1);
	res_arr.do({
		arg val, i;
		val.postln;

		if(
			i == 0 ,
			{
				curr_pitch = keypitch;
			} ,
			{
				curr_pitch = res_arr[i-1] + step_arr[i-1];
			}
		);
		res_arr[i] = curr_pitch;

	});
	res_arr;
};

(
// 2, 2, 1, 2, 2, 2, 1

~get_line_stepbased = {
	arg step_arr, base, indx;
	var res = base;

	if(
		indx > 0,
		{
			indx.do({
				res = res + step_arr.wrapAt(indx);
			});
		}
	);
	/*
	if(
		indx < 0,
		{
			(-1 * indx).do({
				res = res - step_arr.wrapAt(indx);
			});
		}
	);
	*/
	res;
};
)


/*
// base = arr[0]
//
// values
// 64, 66, 68, 69, 71, 73, 75, 76
//     78, 80, 81, 83, 85, 87, 88,
//     90, 92, 93, 95, 97, 99, 100
//
// - base
// 0,  2,  4,  5,  7,  9,  11, 12
// 12, 14, 16, 17, 19, 21, 23, 24
//
// indexes                                 transpose
// -14                     -8              -2
// -7  -6  -5  -4  -3  -2  -1              -1
// 0   1   2   3   4   5   6   7           0
//     8   9   10  11  12  13  14          1
//     15  16

~get_value_folded_transposed = {
	arg in_arr, indx;
	var
	    res = nil
	  , base = in_arr[0]
	  , val, transpose
	  , repeat_val = (in_arr[in_arr.size-1] - base)
	;

	transpose = (indx/(in_arr.size)).floor;

	if(
		indx > (in_arr.size - 1),
		{ indx = indx + transpose;}
	);
	if(
		indx < 0,
		{ indx = indx - transpose;}
	);

	val = in_arr.wrapAt(indx);
	["base = ", base, "val = ", val, "transpose = ", transpose, "repeat_val = ", repeat_val].postln;
	res = (val - base) + (transpose * repeat_val) + base;
};
)

~euro_diatonic1 = ~get_midi_pitch_from_step_and_keypitch.value(~euro_diatonic_step1, 64);


(
var indx, in_arr;
in_arr = ~euro_diatonic1;
indx = -1;


if(
	indx > (in_arr.size - 1),
		{ indx = indx + 1;}
	);
if(
	indx < 0,
		{ indx = indx - 1;}
	);

indx;
)

~euro_diatonic1.wrapAt(-2);

(-17/(~euro_diatonic1.size)).floor;
~euro_diatonic1 - 64 + 12;

~euro_diatonic1 + 24;

~get_value_folded_transposed.(~euro_diatonic1, 15);

*/