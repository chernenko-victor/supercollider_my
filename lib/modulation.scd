/// amplitude modulation
(
SynthDef(\am_synth_proto, {
	arg freq = 440, amp = 0.5, gate = 1, out_bus = 0, master_send_lvl_db = 0.0, pos = 0;
	var f_carry = freq, f_mod, out, env_form, env;
	// f_mod = XLine.kr(1, 1000, 10);
	f_mod = f_carry * 1.2;
	out = SinOsc.ar(f_carry);
	8.do({
		arg indx;
		// out = out * SinOsc.ar(f_mod * (indx + 1), 0, 1 / (pow(indx + 1, 1/10)));
		out = out * SinOsc.ar(f_mod * (indx + 1), 0, 1 / (pow(indx + 1, 1/10)));
	});
	// SinOsc.ar(f_carry) * SinOsc.ar(f_mod);
	// SinOsc.ar() * (LFNoise2.kr(2).range(0.05, 0.9));

	env_form = Env.adsr(0.1, 0.1, 0.5, 0.5);
	env = EnvGen.kr(env_form, gate, doneAction: 0);


	Out.ar(out_bus, Pan2.ar(12 * out * env * dbamp(master_send_lvl_db), pos));
}).add;
)