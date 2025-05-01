(
~rnd_uniform = {
	arg lo = 0.0, hi = 1.0;
	var res = 1.0.rand;
	res = ((hi - lo)*res + lo);
};

~rnd_lin_low = {
	arg lo = 0.0, hi = 1.0;
	var res1, res2;
	res1 = 1.0.rand;
	res2 = 1.0.rand;
	res1 = ((hi - lo)*res1 + lo);
	res2 = ((hi - lo)*res2 + lo);
	min(res1, res2);
};

~rnd_lin_tri = {
	arg lo = 0.0, hi = 1.0;
	var res1, res2;
	res1 = 1.0.rand;
	res2 = 1.0.rand;
	res1 = ((hi - lo)*res1 + lo);
	res2 = ((hi - lo)*res2 + lo);
	((res1 + res2)/2);
};
)

~rnd_uniform.value(220.0, 880.0);

~rnd_lin_low.value(220.0, 880.0);

~rnd_lin_tri.value(220.0, 880.0);

(
~sin_synth_abstr = {
	arg frq = 440.0, pan = 0.0;
	Pan2.ar(
		SinOsc.ar(frq, 0, 0.7).poll
		, pan
		, 1.0
	);
};
)

~sin_synth1 = ~sin_synth_abstr.play;

~sin_synth1.run(false);

~sin_synth1.set(\frq, (~rnd_uniform.value(220.0, 880.0)));

~sin_synth1.set(\pan, (~rnd_uniform.value(-1.0, 1.0)));

~sin_synth1.set(\frq, (~rnd_uniform.value(220.0, 880.0)), \pan, (~rnd_uniform.value(-1.0, 1.0)));

~sin_synth1.run();

~sin_synth1.free();



~sin_synth2 = ~sin_synth_abstr.play;

~sin_synth2.run(false);

~sin_synth2.set(\frq, (~rnd_lin_low.value(220.0, 880.0)));

~sin_synth2.set(\pan, (~rnd_uniform.value(-1.0, 1.0)));

~sin_synth2.set(\frq, (~rnd_lin_low.value(220.0, 880.0)), \pan, (~rnd_uniform.value(-1.0, 1.0)));

~sin_synth2.run();

~sin_synth2.free();

//{ LFDNoise3.ar(XLine.ar(1000, 100, 0.1) ! 3) }.plot(0.1);

{ SinOsc.ar(100) }.plot(0.1);

{Saw.ar(100, 2, 1)}.plot(0.1);

{Pulse.ar(freq: 100.0, width: 0.8, mul: 1.0, add: 0.0)}.plot(0.1);

{Pulse.ar(freq: 500.0, width: 0.9, mul: 1.0, add: 0.0)}.scope(zoom: 4);
