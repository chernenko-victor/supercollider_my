// lsn6
s.plotTree; // see how synth exemplars free self from memory (or not)

(
SynthDef(\additive_proto, {
	arg freq = 440, amp = 0.2;
	var sig_out = 0;
	10.do({
		arg index;
		sig_out = sig_out + (
			SinOsc.ar(freq * (index+1)) /
			(index+1)
		);
	});
	sig_out = amp * sig_out;
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(0, Pan2.ar(sig_out)); // Bus
}).add;
)

~additive = Synth(\additive_proto);
~additive.run(0);
~additive.run(1);
~additive.set(\freq, 220);
~additive.free;

(
SynthDef(\additive_env_proto, {
	arg freq = 440, amp = 0.2;
	var sig_out = 0;
	10.do({
		arg index;
		sig_out = sig_out + (
			SinOsc.ar(freq * (index+1)) /
			(index+1)
		);
	});
	sig_out = sig_out * Env.perc(releaseTime: 0.3).kr(doneAction: 2);
	sig_out = amp * sig_out;
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(0, Pan2.ar(sig_out)); // Bus
}).add;
)


Synth(\additive_env_proto, args: [\freq: 50]);

(
Pbind(
	\degree, Pseries(
		0,
		Pclutch(
			Prand([-1, 1], inf),
			Pseq([0, 0, 0, 1], inf)
		),
		inf
	).wrap(-8, 8).trace,
	\dur, 0.25,
	\instrument, \additive_env_proto,
).play;
)

// ================================
//       Envelopes
// ================================

Env.perc(releaseTime: 0.1).plot; // visualization

Env.perc(releaseTime: (0.1 + 1.0.rand)).test; // sonification

// fixed time instrument stays in memory
(
{
	Env.perc(releaseTime: 0.1).kr * WhiteNoise.ar(0.2);
}.play;
)

// instrument go out memory because of
// .kr(doneAction: 2)
(
{
	Env.perc(releaseTime: 0.1).kr(doneAction: 2) * WhiteNoise.ar(0.2);
}.asSynthDef(name: \hh_proto).add;
)

Synth(\hh_proto);

// that behavior suits for using in Pbind
(
Pbind(
	\dur, Prand((1..4) * 0.125, inf),
	\instrument, \hh_proto,
).play;
)

// other forms of fixed time envelopes:
// Env.linen
// Env.sine


// ================================
//       Samples
// ================================


// find your samples, for example kick drum for ~buf_sample1, clap (or snare) for ~buf_sample2 and piano for ~buf_sample3

// maybe there:
// freesound.org
// mobygratis.com
// your phone records ))


~buf_sample1 = Buffer.read(s, "D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic/R-8bend tom.wav");
~buf_sample1.plot;
~buf_sample1.numChannels;
~buf_sample1.numFrames;
~buf_sample1.sampleRate;
~buf_sample1.duration;

(
~buf_sample2 = Buffer.read(s, "D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic/R-8slap2.wav");
~buf_sample3 = Buffer.read(s, "D:/audio/samples/pf_STE-000.wav");
)

~buf_sample3.numChannels;

(
{
	arg buf = 0;
	var sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: 1,
		doneAction: 2
	);
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
}.play(args: [\buf, ~buf_sample3]);
)

// for make sample desired length
(
SynthDef(\sampler_mono_speed_var_proto, {
	arg buf = 0, rate = 1;
	var sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: rate,
		loop: 1,
		// doneAction: 2
	) * Env.perc.kr(doneAction: 2);
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(0, sig_out);
}).add;

SynthDef(\sampler_2ch_speed_var_proto, {
	arg buf = 0, rate = 1;
	var sig_out;

	sig_out = PlayBuf.ar(
		2,
		buf,
		rate: rate,
		loop: 1,
		// doneAction: 2
	) * Env.perc.kr(doneAction: 2);
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(0, sig_out);
}).add;
)

Synth(\sampler_2ch_speed_var_proto, args: [\buf, ~buf_sample3, \rate, (8.rand - 4) / 3.3]);


// play

~clk1 = TempoClock.new(110/60);

(
~pf_pl = Pbind(
	\rate, Pseries(
		-0.25,
		Pclutch(
			Prand([-1, 1], inf) * 0.25,
			Pseq([0, 0, 0, 1], inf)
		),
		inf
	).wrap(-3, 3).trace,
	\dur, Pwrand([
		0.25,
		Rest(16),
	], [85, 15].normalizeSum, inf),
	\instrument, \sampler_2ch_speed_var_proto,
	\buf, ~buf_sample3,
).play(~clk1, quant: 4);
)

(
~tom_pl = Pbind(
	\dur, Pwrand([
		1,
		Rest(1),
		Rest(4),
	], [94, 5, 1].normalizeSum, inf),
	\instrument, \sampler_mono_speed_var_proto,
	\buf, ~buf_sample1,
).play(~clk1, quant: 0);
)

(
~slap_pl = Pbind(
	\dur, Pwrand(((1..8) ++ [Rest(1), Rest(2), Rest(8)]) * 0.25, Array.rand(11, 1, 10).normalizeSum, inf),
	\instrument, \sampler_mono_speed_var_proto,
	\buf, ~buf_sample2,
).play(~clk1, quant: 4);
)


~pf_pl.stop;
~tom_pl.stop;
~slap_pl.stop;
~clk1.stop;