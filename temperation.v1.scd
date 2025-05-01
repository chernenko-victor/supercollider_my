///  ============ ====== before start
(
~master_send = Bus.audio(s, 2);
)

(
SynthDef(\sqr_var_proto, {
	arg freq = 440, master_send_lvl_db = 0.0, gate = 1, pos = -0.7;
    var out, env, env_form;
	env_form = Env.adsr(0.05, 0.09, 1, 0.1);
	env = EnvGen.kr(env_form, gate, doneAction: 2);
	out = Mix.fill(8, {
	    arg index;
	    var frq = freq;
		frq = frq * ((2 * index) + 1);
		SinOsc.ar(LFNoise2.kr(0.5).range(0.95, 1.01) * frq, 0, (1/(index + 1)));
		// SinOsc.ar(frq, 0, LFNoise2.kr(0.5).range(0.1, 1) * (1/(index + 1)));
		// SinOsc.ar(frq, 0, (1/(index + 1)));
    });
	Out.ar(~master_send, Pan2.ar(out * dbamp(master_send_lvl_db), pos));
}).add;

SynthDef(\master_proto, {
	var out, in;
	in = In.ar(~master_send, 2);
	out = Limiter.ar(in, 0.92);
	Out.ar(0, out);
}).add;

~temp_12et_arr = Array.fill(12, {
	arg indx;
	var gamut_ratio = 2, degree_num = 12; // gamut_ratio = 2 for octave, degree_num = 12 for 12 degree
	pow(gamut_ratio, indx/degree_num);
});
~temp_12et_arr = ~temp_12et_arr * 110;

~temp_27et_arr = Array.fill(27, {
	arg indx;
	var gamut_ratio = 2, degree_num = 27; // gamut_ratio = 2 for octave, degree_num = 12 for 12 degree
	pow(gamut_ratio, indx/degree_num);
});
~temp_17et_arr = ~temp_27et_arr * 440;


~scale2 = [
	~temp_17et_arr[0],
	~temp_17et_arr[2],
	~temp_17et_arr[4],
	~temp_17et_arr[7],
	~temp_17et_arr[9],
	~temp_17et_arr[11],
	~temp_17et_arr[13],
	~temp_17et_arr[16],
	~temp_17et_arr[18], //8
	~temp_17et_arr[20],
	~temp_17et_arr[23],
	~temp_17et_arr[25]
];

~piece1_part1_pitch1_ptrn = Pwrand(
	// [Pseq(~temp_12et_arr, 1), \rest],
	[Prand(~temp_12et_arr, 1), Rest(0)],
	[0.75, 0.25],
	inf
);

~piece1_part1_pitch2_ptrn = Pwrand(
	[Prand(~scale2, 1), Rest(0)],
	[0.85, 0.15],
	inf
);

~piece1_part1 = Pbind(
	// \instrument, \sqr_var_proto,
	\freq, ~piece1_part1_pitch1_ptrn,
	\dur, 1
);

~piece1_part2 = Pbind(
	// \instrument, \sqr_var_proto,
	//\freq, ~piece1_part1_pitch1_ptrn,
	\freq, ~piece1_part1_pitch2_ptrn,
	\dur, 1
);
)

(
~master = Synth(\master_proto);
)


/// ============ ====== test area

~sqr_var = Synth(\sqr_var_proto, [\freq, ~tri_distr.(220, 660), \master_send_lvl_db, -12]);
~sqr_var.release;

///  ============ ====== play


~piece1_part1_player = ~piece1_part1.play;
~piece1_part2_player = ~piece1_part2.play;


~piece1_part1_player.stop;
~piece1_part2_player.stop;

///  ============ ====== finish
(
~master.free;
)