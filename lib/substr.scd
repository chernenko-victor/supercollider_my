(
SynthDef(\substr_noise__proto, {
	arg
	  freq = 440,
	  amp = 0.3,
	  out_bus = 0,
	  master_send_lvl_db = 0.0,
	  pos = 0,
	  gate = 1,
	  attc_time = 0.01,
	  release_time = 0.1
	;

	var
	  out_sig,
	  amp_env_form,
	  amp_env_gen
	;

	out_sig = Mix.fill(10, {
		arg index;
		var in, frq, bwr;
		in = WhiteNoise.ar(0.2);
		frq = freq * (2 * index + 1);
		// bwr = 0.01;
		bwr = LFNoise2.kr(0.3).exprange(0.008, 0.3);
		16*(Resonz.ar(in, frq, bwr)/(index + 1));
	});

	amp_env_form = Env.adsr(
		attackTime: attc_time,
		releaseTime: release_time,
		curve: 3.0
	);
	amp_env_gen = EnvGen.kr(
		amp_env_form,
		gate,
		doneAction: 2
	); //freeSelf

	out_sig = amp * amp_env_gen * out_sig;

	Out.ar(out_bus, Pan2.ar(out_sig * dbamp(master_send_lvl_db), pos));
	// Out.ar(out_bus,	out_sig);
}).add;
)

~substr_noise__proto = Synth(\substr_noise__proto, args: [\out_bus, ~master_send,]);
~substr_noise__proto.release;