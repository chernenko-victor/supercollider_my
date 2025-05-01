(
{
	Decay.ar(Dust.ar(0.5));
}.play;
)

plot({ Decay.ar(Impulse.ar(1), 0.01) });

plot({ Decay.ar(Dust.ar(100)) });

{Decay.ar(Dust.ar(5))}.plot(5);

{Decay.ar(Dust.ar(0.5), decayTime: 3, mul: 2)}.play;

(
{
	WhiteNoise.ar(
		Decay2.ar(
			// Impulse.ar(1)
			Impulse.ar(LFNoise0.kr(1).range(0.5, 5))
			, decayTime: 3
			, mul: 0.2
		)
	).dup;
}.play;
)

(
{
	var sig, frq_base = 330;
	/*
	sig = Resonz.ar(
		Dust.ar(LFNoise2.kr(0.1).range(300, 1000))
		, LFNoise2.kr(0.2).range(100, 300)
		, bwr: LFNoise2.kr(0.5).range(0.01, 0.1)
		, mul: 2
		, add: 0
	);
	*/
	sig = Dust.ar(LFNoise2.kr(0.1).range(300, 1000));
	10.do({
		arg indx;
		sig = Resonz.ar(
			sig
			, LFNoise2.kr(0.2).range((indx+1)*frq_base, (indx+1)*frq_base)
			, bwr: LFNoise2.kr(0.5).range(0.01, 0.1)
			, mul: 2
			, add: sig * 0.7
		);
	});
	/*
	sig = Resonz.ar(
		sig
		, LFNoise2.kr(0.2).range(2*100, 2*300)
		, bwr: LFNoise2.kr(0.5).range(0.01, 0.1)
		, mul: 2
		, add: sig * 0.5
	);
	sig = Resonz.ar(
		sig
		, LFNoise2.kr(0.2).range(3*100, 3*300)
		, bwr: LFNoise2.kr(0.5).range(0.01, 0.1)
		, mul: 2
		, add: sig * 0.5
	);
	*/
	sig * 2;
}.play;
)


(
~reson_substr_proj = {
	arg frq_base = 330, amp = 0.5, gate = 1;
	var src, sig, src_balance, env_amp, env_gen_amp;
	// src = Dust.ar(LFNoise2.kr(0.1).range(300, 1000));
	// src = WhiteNoise.ar(0.1);
	src_balance = LFNoise2.kr(0.2);
	src = (src_balance * Dust.ar(LFNoise2.kr(0.1).range(300, 1000)) * 1.2) + ((1-src_balance)*WhiteNoise.ar(0.1));
	env_amp = Env.adsr(
		attackTime: Rand(0.01, 0.1),
		decayTime: Rand(0.1, 1),
		sustainLevel: Rand(0.5, 1),
		releaseTime: Rand(0.5, 1)
	);
	env_gen_amp = EnvGen.kr(env_amp, gate);
	sig = Mix.fill(10, {
		arg indx;
		sig = Resonz.ar(
			src
			, LFNoise2.kr(0.2).range((indx+1)*frq_base, 1.5*(indx+1)*frq_base)
			// , bwr: LFNoise2.kr(0.5).range(0.01, 0.1)
			, bwr: LFNoise2.kr(0.5).range(0.005, 0.05)
			, mul: 1
			// , add: sig * 0.7
		);
	});
	sig * env_gen_amp * amp;
};
)


~reson_substr = ~reson_substr_proj.play();
~reson_substr.set(\gate, 1, \frq_base, 220.0 + 220.0.rand);
~reson_substr.set(\gate, 0);

FreqScope.new;

// Formant
