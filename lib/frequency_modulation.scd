(
SynthDef(\tuba_proto, {
	arg
	  freq = 440,
	  amp = 0.3,
	  gate = 1,
	  attackTime = 0.5,
	  releaseTime = 0.3,
	  master_send_lvl_db = 0.0,
	  out_bus = 0,
	  pos = 0;
    var out, amp_env, mul;
	amp_env = EnvGen.kr(
		Env.adsr(
			attackTime: attackTime,
			releaseTime: releaseTime,
			curve: -2.5
		),
		gate,
		doneAction: 2
	);
	mul = 100;
	out = SinOsc.ar(
		freq + SinOsc.ar(
			2 * (amp_env/50 + 1) * freq,
			mul: (amp_env * 3 + 1) * mul,
			add: (amp_env/5 + 1) * mul / 2
		)
	);
	Out.ar(out_bus, Pan2.ar(out * amp * amp_env * dbamp(master_send_lvl_db), pos));
}).add;
)