//{SinOsc.ar()}.play;

~bus_2ch = Bus.audio(s, 2);

(
SynthDef(\test_2ch, {
	arg out = 0, width=3, spread=1, level=0.2, center=0.0;
	var sig, sig_out;
	//sig = [SinOsc.ar(), WhiteNoise.ar(0.5)];
	var env = Env([0.0, 1.0, 0.9, 0.0], [0.05, 1.0, 1.5], -4);
	var envgen = EnvGen.ar(
		env
		//, Impulse.kr(0.2)
		, { |i| Dust.ar(LFNoise0.kr(0.5).range(0.05, 1)) }!10
	);
	//sig = SinOsc.ar( { |i| LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100) } ! 10);
	sig = SinOsc.ar(
		{|i| Rand(440, 880)}!10
		, 0
		, envgen
	);
	sig_out = Splay.ar(
		sig,
		spread,
		level,
		center
	);
	Out.ar(~bus_2ch, sig_out);
	//Out.ar(0, sig_out);
}).add;

SynthDef(\test_master_out_2ch, {
	Out.ar(0, In.ar(~bus_2ch, 2));
}).add;

SynthDef(\test_eff_2ch, {
	var in_arr = Array.new(2);
	var left_ch, right_ch;
	in_arr = In.ar(~bus_2ch, 2);
	left_ch = in_arr[0];
	right_ch = in_arr[1];

	5.do {
		|i|
		left_ch = DelayC.ar(left_ch, 1, 1 / (2**i), 1, left_ch * 0.5);
	    right_ch = DelayC.ar(right_ch, 1, 1 / (2**i), 1, right_ch * 0.5);
    };

	//Out.ar(0, right_ch);
    Out.ar(0, [left_ch, right_ch]);
}).add;
)

~test_2ch1 = Synth(\test_2ch);
~test_master_out_2ch1 = Synth(\test_master_out_2ch, addAction: 'addToTail');
~test_eff_2ch1 = Synth(\test_eff_2ch, addAction: 'addToTail');
~test_2ch1.free;
~test_master_out_2ch1.free;
~test_eff_2ch1.free;