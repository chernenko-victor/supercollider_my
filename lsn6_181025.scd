// lsn6
s.plotTree;

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
		).trace,
		inf
	).wrap(-8, 8),
	\dur, 0.25,
	\instrument, \additive_env_proto,
).play;
)

// ================================
//       Envelopes
// ================================

Env.perc(releaseTime: 0.1).plot;

Env.perc(releaseTime: (0.1 + 1.0.rand)).test;

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

// Env.linen
// Env.sine


Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]).plot;

(
{
	Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]).kr(doneAction: 2) * Saw.ar(440) * 0.2;
}.play;
)

(
{
	EnvGen.kr(
		Env(
            levels: [0, 0.1, 0.2, 0.3, 0],
            times: [0.1, 0.1, 0.1, 0.2],
            curve: 8
        ),
		gate: 1,
		doneAction: 2
	);
}.plot(duration: 2);
)

(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 0.1, 0.2, 0.3, 0],
            times: [0.1, 1, 1, 0.5],
            curve: 8
        ),
		gate: 1,
		doneAction: 2
	);
	LFTri.ar(440) * env * 0.2;
}.play;
)

// envelope as pattern
(
Pbind(
    \note, Env(
            levels: [0, 12, 6, 13, 0],
            times: [1, 5, 2, 10],
            curve: 8
        ),
    \dur, 0.1
).play;
)

// EnvGen.kr
(
{
	Trig.kr(Impulse.kr(3), dur: 0.3)
}.plot(4);
)


// adsr
(
SynthDef(\env_help, { |out, gate = 1, amp = 0.1, release = 0.1|
    var env = Env.adsr(0.02, release, amp);
    var gen = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    Out.ar(out, PinkNoise.ar(1 ! 2) * gen)
}).add
);

a = Synth(\env_help);
b = Synth(\env_help, [\release, 2]);
a.set(\gate, 0); // alternatively, you can write a.release;
b.set(\gate, 0);



{Trig.kr(Impulse.kr(0.1), dur: 5)}.plot(20);

{Trig.kr(Dust.kr(0.5), dur: 5)}.plot(20);

(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 1, 0],
            times: [0.1, 1],
            curve: 8,
			//releaseNode: 1,
        ),
		gate: Trig.kr(Impulse.kr(0.2), dur: 1),
		doneAction: 0
	);
	LFTri.ar(440) * env * 0.2;
}.play;
)

// loopNode
(
{
	var env;
	env = EnvGen.kr(
		Env(
            levels: [0, 1, 0.2, 1, 0.3, 1, 0],
            times: [0.1, 0.5, 0.5, 0.5, 0.1, 1],
            curve: 8,
			releaseNode: 5,
			loopNode: 1,
        ),
		// gate: Trig.kr(Impulse.kr(0.1), dur: 5),
		gate: Trig.kr(Dust.kr(0.5), dur: 5),
		doneAction: 0
	);
	LFTri.ar(440) * env * 0.2;
}.play;// plot(10);
)



// ================================
//            Filter
// ================================
(
{
	Decay2.kr(Impulse.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
}.play;
)

(
{
	Decay2.kr(Dust.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
}.play;
)

(
{
	var sig_out;
	sig_out = Lag2.kr(Dust.kr(1), 0.1, 1) * WhiteNoise.ar(0.2);
	sig_out = Compander.ar(sig_out, sig_out, 0.1, slopeBelow: 0.9, slopeAbove: 1/10) * 20;
	sig_out = Limiter.ar(sig_out, dbamp(-1));
}.play;
)


// ================================
//            Filter
// ================================

FreqScope.new;

(
SynthDef(\dynklanks, {arg freqs = #[200, 671, 1153, 1723];
    Out.ar(0,
        DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007]))
    )
}).add
)

a = Synth(\dynklanks);
a.set(\freqs, [333, 444, 555, 666])
a.set(\freqs, [333, 444, 555, 666].rand)
a.free;

(
{
	HPF.ar(
		WhiteNoise.ar(0.1),
		SinOsc.kr(0.1).range(50, 500)
	);
}.play;
)

(
{
	BPF.ar(
		WhiteNoise.ar(0.1),
		SinOsc.kr(0.1).range(500, 5000),
		rq: 0.1,
	);
}.play;
)

(
{
	MidEQ.ar(
		WhiteNoise.ar(0.1),
		SinOsc.kr(0.1).range(500, 5000),
		0.01,
		12)
}.play
)

(
{
	RLPF.ar(
		WhiteNoise.ar(0.1),
		SinOsc.kr(0.1).range(500, 5000),
		rq: 0.05,
	) * 0.2;
}.play;
)

(
{
	Resonz.ar(
		WhiteNoise.ar(0.1),
		SinOsc.kr(0.1).range(500, 5000),
		bwr: 0.05,
	);
}.play;
)

// a short impulse won't resonate
{ Resonz.ar(Dust.ar(0.5), 2000, 0.1) }.play

// for that we use Ringz
{ Ringz.ar(Dust.ar(2, 0.6), MouseX.kr(200,6000,1), 2) * 0.2 }.play

MoogFF


// ================================
//       Substractive synth
// ================================

//...

// ================================
//       Samples
// ================================

~buf_sample1 = Buffer.read(s, "D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic/R-8bend tom.wav");
~buf_sample1.plot;
~buf_sample1.numChannels;
~buf_sample1.numFrames;
~buf_sample1.sampleRate;
~buf_sample1.duration;

~buf_sample2 = Buffer.read(s, "D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic/R-8slap2.wav");

~buf_sample3 = Buffer.read(s, "D:/audio/samples/pf_STE-000.wav");

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

//
(
{
	arg buf = 0;
	var sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: BufRateScale.ir(buf) * LFDNoise0.kr(0.1).range(-2.0, 2.0),
		doneAction: 0,
		loop: 1,
	);
	sig_out = Decay2.kr(Dust.kr(1), 0.1, 1) * sig_out;
	sig_out = Compander.ar(sig_out, sig_out, 0.7, slopeBelow: 1.3, slopeAbove: 1/5) * 5;
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
}.play(args: [\buf, ~buf_sample3]);
)

// directory to sampler
(
~dr_buff_arr = PathName("D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic").entries.collect({
	// arg ...args;
	arg sample_path;
	// sample_path.fullPath.postln;
	Buffer.read(s, sample_path.fullPath);
});
)

~dr_buff_arr.choose.play;

(
~dr2_buff_arr = PathName("D:/audio/samples/90s-sample-cds/(SN-R8-01) Contemporary Percussion").entries.collect({
	// arg ...args;
	arg sample_path;
	// sample_path.fullPath.postln;
	Buffer.read(s, sample_path.fullPath);
});
)

~dr2_buff_arr.choose.play;


~aligator_buff = Buffer.read(s, "D:/audio/samples/90s-sample-cds/Amiga ST-XX samples/ST-XX_AIFF/ST-01/Aligator.aiff");
~aligator_buff.play;


(
// ~amiga1_buff_arr = PathName("D:/audio/samples/90s-sample-cds/Amiga ST-XX samples/ST-XX_AIFF/ST-01").entries.collect({
// 	// arg ...args;
// 	arg sample_path;
// 	if(
// 		(sample_path.extension == "aiff") || (sample_path.extension == "wav"),
// 		{
// 			// sample_path.fullPath.postln;
// 			Buffer.read(s, sample_path.fullPath);
// 		}
// 	);
// });


~amiga1_all_arr = PathName("D:/audio/samples/90s-sample-cds/Amiga ST-XX samples/ST-XX_AIFF/ST-01").entries;


~amiga1_buff_list = List.new();
~amiga1_all_arr.do({
	// arg ...args;
	arg sample_path;
	if(
		(sample_path.extension == "aiff") || (sample_path.extension == "wav"),
		{
			sample_path.fullPath.postln;
			//Buffer.read(s, sample_path.fullPath);
			~amiga1_buff_list.add(Buffer.read(s, sample_path.fullPath));
		}
	);
});
)

~amiga1_buff_list.choose.play;


(
SynthDef(\play_buff_proto, {
	arg buf = 0;
	var sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: BufRateScale.ir(buf),
		doneAction: 2
	);
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(0, sig_out);
}).add;
)

(
Pbind(
	\instrument, \play_buff_proto,
	\buf, Prand(~dr_buff_arr, inf),
	\dur, Prand(
		((1..6) ++ [Rest(1), Rest(3)]) * 0.125,
		inf
	);
).play;

Pbind(
	\instrument, \play_buff_proto,
	// \buf, Prand(~dr2_buff_arr, inf),
	\buf, Prand(~amiga1_buff_list, inf),
	\dur, Prand(
		((1..6) ++ [Rest(1), Rest(2), Rest(2), Rest(4)]) * 0.125,
		inf
	);
).play;
)




