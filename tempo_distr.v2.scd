////////////////////////////////////////////////////
/////////////////////   random /////////////////////
////////////////////////////////////////////////////

(
~eq_distr = {
	arg low, hi;
	low + rand(hi - low);
};

~lin_min = {
	arg low, hi;
	var rnd1, rnd2;
	rnd1 = ~eq_distr.(low, hi);
	rnd2 = ~eq_distr.(low, hi);
	min(rnd1, rnd2);
};

~lin_max = {
	arg low, hi;
	var rnd1, rnd2;
	rnd1 = ~eq_distr.(low, hi);
	rnd2 = ~eq_distr.(low, hi);
	max(rnd1, rnd2);
};

~normal_distr = {
	arg low, hi;
	var rnd1, rnd2;
	rnd1 = ~eq_distr.(low, hi);
	rnd2 = ~eq_distr.(low, hi);
	(rnd1 + rnd2)/2;
};

~discr_dictr = {
	arg weight_arr;
	var indx = 0, rnd, len;
	len = weight_arr[0];
	rnd = ~eq_distr.(0.0, 1.0);

	while({
		len < rnd;
	}, {
		indx.postln;
		indx = indx + 1;
		len = len + weight_arr[indx];
	});
	indx;
};
)

{~eq_distr.(0, 10)}.dup(1000).plot;
{~lin_min.(0, 10)}.dup(1000).plot;
{~lin_max.(0, 10)}.dup(1000).plot;
{~normal_distr.(0, 10)}.dup(1000).plot;


{~eq_distr.(0, 10)}.dup(1000).histo.plot;
{~lin_min.(0, 10)}.dup(1000).histo.plot;
{~lin_max.(0, 10)}.dup(1000).histo.plot;
{~normal_distr.(0, 10)}.dup(1000).histo.plot;


~midi_weight_arr1 = [10, 20, 5, 30, 20].normalizeSum;
~midi_weight_arr1.plot;
~discr_dictr.(~midi_weight_arr1);

{~discr_dictr.(~midi_weight_arr1)}.dup(1000).histo.plot;


// Env.perc(0.3, 0.8, curve: 3.0).test.plot;


////////////////////////////////////////////////////
/////////////////////   synth   /////////////////////
////////////////////////////////////////////////////

(
~add_synth_proto = {
	arg frq = 440, amp = 0.3;
	var amp_base = 1, amp_env_form, amp_env_gen, final;
	amp_env_form = Env.perc(0.3, 0.8, curve: 3.0);
	amp_env_gen = EnvGen.kr(amp_env_form, doneAction: 2);
	final = amp *
	        amp_env_gen *
	        Mix.fill(8, {
                 arg i;
		         SinOsc.ar(frq*(i+1), 0, amp_base/(i+1))
	        });
	final!2;
};


~add_synth_gated_proto = {
	arg frq = 440, amp = 0.3, gate = 1;
	var amp_base = 1, amp_env_form, amp_env_gen, final;
	// amp_env_form = Env.perc(0.3, 0.8, curve: 3.0);
	amp_env_form = Env.adsr(0.1, 0.1, 1, 0.5);
	amp_env_gen = EnvGen.kr(amp_env_form, gate);
	final = amp * amp_env_gen * (
		SinOsc.ar(frq, 0, amp_base) +
		SinOsc.ar(frq*2, 0, amp_base/2) +
		SinOsc.ar(frq * 3, 0, amp_base / 3)
	);
	final!2;
};
)

~equal_distr.(110, 1000)

~add_synth1 = ~add_synth_proto.play(args: [\frq, ~equal_distr.(110, 1000), \amp, 0.2]);

// ~add_synth1.set(\frq, ~eq_distr.(110, 1000));

// ~add_synth1.run(false);

// ~add_synth1.run(true);

// ~add_synth1.free;



~add_synth_gated1 = ~add_synth_gated_proto.play();
~add_synth_gated1.set(\gate, 0);
~add_synth_gated1.set(\frq, ~eq_distr.(110, 1000), \gate, 1);
~add_synth_gated1.free;


////////////////////////////////////////////////////
/////////////////////   parts  /////////////////////
////////////////////////////////////////////////////

(
// ~add_synth1 = ~add_synth_proto.play(args: [\frq, 220]);
~part1 = TempoClock.new(1);
)

(
~part1.sched(1, {
	arg beat, sec;
	// [beat, sec].postln;
	// ~add_synth1.set(\frq, ~eq_distr.(110, 1000));
	~add_synth_proto.play(
		args: [
			\frq, ~equal_distr.(110, 1000),
			\amp, ~equal_distr.(0.1, 0.5)
		]
	);
	(~equal_distr.value(0, 11)/4.0)+0.25;
});
)

(
~part1.stop;
// ~add_synth1.free;
)


/////////////////////
/*
(
if(
	1 < 2,
	{
		"true".postln;
	},
	{
		"false".postln;
	}
);
)
*/

(
~part2 = TempoClock.new(1);
~add_synth_gated1 = ~add_synth_gated_proto.play(args: [\amp, 0]);
~part2_pause_flag = 0;
)

(
~part2.sched(1, {
	arg beat, sec;
	/*
	~add_synth2 = ~add_synth_proto.play(
		args: [
			\frq, ~eq_distr.(110, 1000),
			\amp, ~eq_distr.(0.1, 0.5)
		]
	);
	*/
	if(
		~part2_pause_flag == 0,
	{
			// "true".postln;
			~add_synth_gated1.set(\frq, ~eq_distr.(110, 1000), \amp, ~eq_distr.(0.1, 0.5), \gate, 1);
			~part2_pause_flag = 1;
	},
	{
			// "false".postln;
			~add_synth_gated1.set(\gate, 0);
			~part2_pause_flag = 0;
	}
);
	(~eq_distr.value(0, 11)/4.0)+0.25;
});
)

(
~part2.stop;
~add_synth_gated1.set(\gate, 0);
~add_synth_gated1.free;
)