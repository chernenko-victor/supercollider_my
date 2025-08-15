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


60.midicps;

///////////////////////////////////
// 12 octave equal

(
~eq12_semitone = pow(2, 1/12); // pow(scale_repeat_ratio, num_of_steps)


~eq12_ratios_arr = (0..12).collect({
	arg item;
	//item.postln;
	pow(~eq12_semitone, item);
});
)

///////////////////////////////////
// 12 duodecimal equal

(
~eq12_duodec_semitone = pow(2 + (2/3), 1/12); // pow(scale_repeat_ratio, num_of_steps)


~eq12_duodec_ratios_arr = (0..12).collect({
	arg item;
	//item.postln;
	pow(~eq12_duodec_semitone, item);
});
)

(64.rand + 32).round(4)
[1, 2, 3, 4, 5].choose.round(3)
(12.rand).round(2)


(
Pdef(\test_pitch,
	Pbind(
		// \degree, Pser([[0,1,2], [0,1,2] + 2, [0,1,2] + 4], inf),
		\degree, Pser([0,1,2], inf),

		\scale, Scale.major,
		// \scale, Scale.minor,
		// scale, Scale.phrygian,

		//\freq, 261.62 * Pser(~eq12_duodec_ratios_arr, inf)// Prand(~eq12_duodec_ratios_arr, inf),
		// \midinote, Pser([60,61,63], inf),
		// \note, Pser([60,61,63]-60, inf),
		// all three above independent of Scale

		// all three affectrd by
		// \ctranspose,12,//transposeanoctaveabove(=12semitones)

		\strum, 0.25,
		\legato, 0.5
	)
).play
)

Pdef(\test_pitch).stop;

Scale.directory;

~phryg_scale = Scale.phrygian;

// Scale(
// 	[ 0, 1, 3, 5, 7, 8, 10 ], // degrees - array consists amount of semitones from key note for degree = index
//   // e.g. degree=2 => 3 semitones (minor tertia)
// 	12,
// 	Tuning(
// 		[ 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0 ],
// 		2.0,
// 		"ET12"
// 	), "Phrygian"
// )

~phryg_scale.degrees
~phryg_scale_buf = Buffer.loadCollection(s, ~phryg_scale.degrees);

~phryg_scale_buf.plot;

// ===============
~phryg_scale.performDegreeToKey(4, 24, 0)

