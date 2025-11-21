~buf1 = Buffer.read(s, "D:/audio/samples/04-mic2-231205_1439.wav");
~buf1.play;
(
{
	var in_sig, amp, trigger, amp_env, chain;

	amp_env = 0;

	//in_sig = PlayBuf.ar(1, ~buf1, rate: 1, trigger: 1, loop: 1);
	in_sig = In.ar(2, 1);

	/*
	amp = Amplitude.ar(in_sig, attackTime: 0.1, releaseTime: 0.1);

	// (amp > 0.01).poll;

	trigger = Select.ar(amp > 0.05, [DC.ar(1), DC.ar(0)]);

	// SetResetFF.ar(trig: 0.0, reset: 0.0);

	// https://doc.sccode.org/Classes/AttackSlope.html
	*/

	chain = FFT(LocalBuf(1024), in_sig);

	trigger = Onsets.kr(chain, threshold: MouseX.kr(0, 1).poll, mingap: 1000);

	amp_env = EnvGen.ar(Env.new(levels: [0, 1, 1, 0], times: [0.1, 5, 0.1]), gate: trigger);

	// SinOsc.ar() * trigger * 0.2;
	SinOsc.ar() * amp_env * 0.2;
}.play;
)

(
{
	var in_sig;
	in_sig = In.ar(2, 1);
	Out.ar(0, in_sig);
}.play;
)