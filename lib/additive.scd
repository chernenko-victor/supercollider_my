//include C:\home\chernenko\src\supercollider\lib\fx.scd


(
SynthDef(\add_synth_long_proto, {
	arg
	  freq = 440,
	  amp = 0.3,
	  out_bus = 0,
	  master_send_lvl_db = 0.0,
	  pos = 0,
	  gate = 1,
	  attc_time = 0.01,
	  release_time = 0.1;

	var
	  amp_base = 1,
	  amp_env_form,
	  amp_env_gen,
	  out;

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

	out = amp *
	        amp_env_gen *
	        Mix.fill(8, {
                 arg i;
		         SinOsc.ar(freq*(i+1), 0, amp_base/(i+1))
	        });

	Out.ar(out_bus, Pan2.ar(out * dbamp(master_send_lvl_db), pos));
}).add;


SynthDef(\add_synth_percussion_proto, {

	arg
	  freq = 440,
	  amp = 0.3,
	  out_bus = 0,
	  master_send_lvl_db = 0.0,
	  pos = 0,
	  attc_time = 0.01,
	  release_time = 0.1;

	var
	  amp_base = 1,
	  amp_env_form,
	  amp_env_gen,
	  out;

	amp_env_form = Env.perc(attc_time, release_time, curve: 3.0);
	amp_env_gen = EnvGen.kr(amp_env_form, doneAction: 2); //freeSelf

	out = amp *
	        amp_env_gen *
	        Mix.fill(8, {
                 arg i;
		         SinOsc.ar(freq*(i+1), 0, amp_base/(i+1))
	        });

	Out.ar(out_bus, Pan2.ar(out * dbamp(master_send_lvl_db), pos));
}).add;

// EnvGen.kr timeScale можно использовать, чтобы задавать разные длительности

/*
levels = [0, 1, 1, 0.3, 0, 1, 0];
	times = [0.1, 0.2, 0.1, 0.3, 0.1, 0.1] * 1.5;
	curve = [-5, 1, 2, -2, 0, 1, 0];

	// gate = Trig.kr(Impulse.kr(0.5), dur: 0.8);
	gate = SinOsc.kr(0.3);
	// env_form = Env.perc();
	// env_form = Env.adsr(0.1, 0.1, 0.5, 0.5);
	env_form = Env.new(levels, times, curve);
*/


SynthDef(\sqr_var_proto, {
	arg freq = 440, master_send_lvl_db = 0.0, out_bus = 0, pos = 0;
    var out;
	out = Mix.fill(8, {
	    arg index;
	    var frq = freq;
		frq = frq * ((2 * index) + 1);
		SinOsc.ar(LFNoise2.kr(0.5).range(0.95, 1.01) * frq, 0, (1/(index + 1)));
		// SinOsc.ar(frq, 0, LFNoise2.kr(0.5).range(0.1, 1) * (1/(index + 1)));
		// SinOsc.ar(frq, 0, (1/(index + 1)));
    });
	Out.ar(out_bus, Pan2.ar(out * dbamp(master_send_lvl_db), pos));
}).add;


SynthDef(\sqr_var_adsr_proto, {
	arg
	  freq = 440,
	  amp = 0.3,
	  gate = 1,
	  releaseTime = 0.3,
	  master_send_lvl_db = 0.0,
	  out_bus = 0,
	  pos = 0;
    var out, amp_env;
	amp_env = EnvGen.kr(
		Env.adsr(
			releaseTime: releaseTime,
			curve: -2.5
		),
		gate,
		doneAction: 2
	);
	out = Mix.fill(8, {
	    arg index;
	    var frq = freq;
		frq = frq * ((2 * index) + 1);
		SinOsc.ar(LFNoise2.kr(0.5).range(0.95, 1.01) * frq, 0, (1/(index + 1)));
		// SinOsc.ar(frq, 0, LFNoise2.kr(0.5).range(0.1, 1) * (1/(index + 1)));
		// SinOsc.ar(frq, 0, (1/(index + 1)));
    });
	Out.ar(out_bus, Pan2.ar(out * amp * dbamp(master_send_lvl_db), pos));
}).add;

// TRand
// TChoose
)