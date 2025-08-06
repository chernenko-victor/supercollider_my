~symmetric_arr = [0, 2, 4];

(
~all_symmetric_in_scale_arr = Array.fill(8, {
	arg index;
	~symmetric_arr + index;
});
)

~all_symmetric_in_scale_ptrn = Pseq(~all_symmetric_in_scale_arr, inf);

(
~all_symmetric_in_scale_pbind = Pbind(
	\degree, ~all_symmetric_in_scale_ptrn,
	\dur, 2,
	\legato, 0.7,
	// \scale, Scale.major(\just)
	// \scale, Scale.major(\pythagorean)
	// \scale, Scale.minor
);
)

(
~all_symmetric_in_scale_pbind_player = ~all_symmetric_in_scale_pbind.play;
)

~all_symmetric_in_scale_pbind_player.stop;

Scale