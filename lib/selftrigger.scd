(
SynthDef(\demand_proto, {
	arg out_bus = 0, pos = 0, delta = 1;
	var out, amp_env_form, amp_env_gen, gate = 1, legato = 0.8, freq = 440, frq_ptrn;

	frq_ptrn = Drand(
		[
			Dseq((1..5).mirror1, 1),
			Drand((4..10), 8)
		],
		inf
	);

	delta = (LFNoise0.kr(0.1).range(1, 6)) * 0.5;

	/*
	delta = Demand.kr(
		gate,
		0,
		frq_ptrn / 2
	);

	if gate set to 1 by default, error occured:
	Demand first input is not control rate:  1 scalar
	*/

	gate = Trig.kr(Impulse.kr(1/delta), dur: delta * legato);

	// freq = TRand.kr(220, 660, gate);
	/*freq = Demand.kr(
		gate,
		0,
		(Dseq([1, 3, 5, 7, 10, 12], inf) + 60).midicps
	);*/

	freq = Demand.kr(
		gate,
		0,
		(frq_ptrn + 60).midicps
	);

	/*delta = Demand.kr(
		gate,
		0,
		frq_ptrn / 2
	);
	DOESNT WORK: delta doesnt changes. WHY?
	*/

	amp_env_form = Env.adsr();
	amp_env_gen = EnvGen.kr(amp_env_form, gate, doneAction: 0); //doNothing

	out = SinOsc.ar(freq, mul: 0.5) * amp_env_gen;
	Out.ar(out_bus, Pan2.ar(out, pos));
}).add;

// Stepper


SynthDef(\selftrig_proto, {
	var env_form, env, out, gate, master_send_lvl_db = 0.0, out_bus = 0, fx1_bus = 100;

	// ========= 1. Duration + Env ============
	// gate = Trig.kr(Impulse.kr(0.5), dur: 0.8);
	gate = SinOsc.kr(
		// 0.5 + SinOsc.kr(0.1).range(0.1, 2)
		0.5 + LFNoise2.kr(0.1).range(0.1, 2)
	);
	// env_form = Env.perc();
	env_form = Env.adsr(0.1, 0.1, 0.5, 0.5);
	env = EnvGen.kr(env_form, gate, doneAction: 0);

	// ========= 1. Timbre ============
	out = SinOsc.ar();
	out = out * env;
	Out.ar(out_bus, Pan2.ar(out * dbamp(master_send_lvl_db)), -1);
	// Out.ar(~space_send, out);
	Out.ar(fx1_bus, out);
}).add;
)

// ============= example ===============

// (
// ~demand1 = Synth(\demand_proto, [
// 	\out_bus, ~master_send,
// 	// \freq, ~equal_distr.(220, 660),
// 	// \amp, ~lin_min_distr.(0.1, 0.8),
// 	// \attc_time, ~lin_min_distr.(0.01, 0.08),
// 	// \release_time, ~tri_distr.(0.06, 0.3)
// ]);
// )
// ~demand1.free;

(
{
	Lag.kr(
		Impulse.kr(1),
		0.5
	);
}.plot(duration: 5);
)

(
{
	Lag2.kr(
		Impulse.kr(1),
		0.5
	);
}.plot(duration: 5);
)