{[VarSaw.ar(40, width: 0.5), VarSaw.ar(40, width: LFTri.kr(1).range(0.01, 0.99))]}.plot(0.5);

LFTri

// Trig.ar(

(
var tri_pulse_func;
tri_pulse_func = {
	var trig, amp_env, src, mod_imp;
	mod_imp = SinOsc.kr(0.3).range(-6.7, 10);
	trig = Trig.kr(
		Impulse.kr(7 + mod_imp, 0.99)
	);
	amp_env = Lag.kr(
		trig
	);
	src = LFTri.ar(220);
	src * amp_env;
};
tri_pulse_func.plot(0.5);
~tri_pulse_synth = tri_pulse_func.play;
)

~tri_pulse_synth.free;

