Scale.directory
Scale.choose

Tuning.directory
Tuning.choose

~rand_scale = Scale.choose;
Pbind(\scale, ~rand_scale, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;

~rand_scale.tuning_(\just);
Pbind(\scale, ~rand_scale, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;

~rand_tuning = Tuning.choose;
~rand_scale.tuning_(~rand_tuning);
Pbind(\scale, ~rand_scale, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;


Tuning.et12.ratios

Tuning.new(#[0, 0.795, 2.251, 3.251, 4.036, 4.680, 5.915, 7.221, 8.013, 9.29, 9.930, 11.032]);

(
Tuning.new(
	(0..11).collect(_ * (2.08 ** (1/12))),
	2.08,
	"Stretched ET12"
);
)




(0..11).collect(_ * (2.08 ** (1/12)))

(2.08 ** (1/12))
(2 ** (1/12))



a = Scale.major;
a.degrees;        // [0, 2, 4, 5, 7, 9, 11]
a.semitones;        // [0, 2, 4, 5, 7, 9, 11]
a.cents;        // [0, 200, 300, 500, 700, 900, 1100]
a.ratios;        // [1, 1.1224620483089, 1.2599210498937, 1.3348398541685, etc.]

Pbind(\scale, a, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;

// use non-standard tuning
a.tuning_(\just);
a.degrees;        // no change; degrees are independent of tuning
a.semitones;        // [0, 2.0391000173077, 3.1564128700055, 4.9804499913461, etc.]
a.ratios.collect(_.round(0.001));    // [1, 1.125, 1.2, 1.333, 1.5, 1.667, 1.875]

Pbind(\scale, a, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;


~tun_new = Tuning.new(#[0, 0.795, 2.251, 3.251, 4.036, 4.680, 5.915, 7.221, 8.013, 9.29, 9.930, 11.032]);

a.tuning_(~tun_new);
a.degrees;        // no change; degrees are independent of tuning
a.semitones;        // [0, 2.0391000173077, 3.1564128700055, 4.9804499913461, etc.]
a.ratios.collect(_.round(0.001));    // [1, 1.125, 1.2, 1.333, 1.5, 1.667, 1.875]

Pbind(\scale, a, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;


(
Pbindef(\from_img_seq1).clear;
Pbindef(
	\from_img_seq1,
	\dur,
	Pseq([0.25, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.25, 0.25, 0.5, 0.25, 0.5, 0.0625, 0.125, 0.25, 0.125, 0.25, 0.125, 0.125, 0.0625, 0.0625, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.5, 0.5, 0.5, 0.125, 0.125, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.125], inf) * 2,
	\degree,
	Pseq([59, 58, 58, 59, 59, 62, 68, 64, 63, 62, 57, 56, 55, 54, 62, 58, 56, 55, 54, 57, 54, 53, 53, 54, 52, 51, 62, 61, 57, 56, 55, 56, 59, 67, 64, 58, 56, 53, 58, 59, 57, 54, 53, 53, 53, 53, 54, 55, 54, 50, 54, 58, 57, 56, 53, 55, 54, 53, 53, 56, 55, 55, 53, 52], inf) - 59,
	\scale, a,
).play(argClock: ~clck1, quant: 4);
)

Pbindef(\from_img_seq1).stop;



(
~narrowed_et12_tun = Tuning.new(
	(0..11).collect(_ * (1.87 ** (1/12))),
	1.87,
	"Narrowed ET12"
);
)


~ionian_scale = Scale.major;
~ionian_scale.degrees;        // [0, 2, 4, 5, 7, 9, 11]
~ionian_scale.semitones;        // [0, 2, 4, 5, 7, 9, 11]
~ionian_scale.cents;        // [0, 200, 300, 500, 700, 900, 1100]
~ionian_scale.ratios;        // [1, 1.1224620483089, 1.2599210498937, 1.3348398541685, etc.]

Pbind(\scale, ~ionian_scale, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;


~ionian_scale_narrowed_et12_tun = Scale.major.tuning_(~narrowed_et12_tun);
~ionian_scale_narrowed_et12_tun.degrees;        // [0, 2, 4, 5, 7, 9, 11]
~ionian_scale_narrowed_et12_tun.semitones;        // [0, 2, 4, 5, 7, 9, 11]
~ionian_scale_narrowed_et12_tun.cents;        // [0, 200, 300, 500, 700, 900, 1100]
~ionian_scale_narrowed_et12_tun.ratios;        // [1, 1.1224620483089, 1.2599210498937, 1.3348398541685, etc.]


Pbind(\scale, ~ionian_scale_narrowed_et12_tun, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;


(
Pbindef(\from_img_seq1).clear;
Pbindef(
	\from_img_seq1,
	\dur,
	Pseq([0.25, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.25, 0.25, 0.5, 0.25, 0.5, 0.0625, 0.125, 0.25, 0.125, 0.25, 0.125, 0.125, 0.0625, 0.0625, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.5, 0.5, 0.5, 0.125, 0.125, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.125], inf) * 2,
	\degree,
	Pseq([59, 58, 58, 59, 59, 62, 68, 64, 63, 62, 57, 56, 55, 54, 62, 58, 56, 55, 54, 57, 54, 53, 53, 54, 52, 51, 62, 61, 57, 56, 55, 56, 59, 67, 64, 58, 56, 53, 58, 59, 57, 54, 53, 53, 53, 53, 54, 55, 54, 50, 54, 58, 57, 56, 53, 55, 54, 53, 53, 56, 55, 55, 53, 52], inf) - 59,
	\scale, ~ionian_scale_narrowed_et12_tun,
).play(argClock: ~clck1, quant: 4);
)

Pbindef(\from_img_seq1).stop;