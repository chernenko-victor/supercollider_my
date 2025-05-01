~send_delay = Bus.audio(s, 1);

(
SynthDef(\filtered_proto, {
	arg base_frq = 440, amp_base = 0.7, gate = 1;
	var res = 0, src, amp_form, amp;

	amp_form = Env.adsr(0.2);
	amp = EnvGen.kr(amp_form, gate, doneAction: 2);

	src = WhiteNoise.ar(0.1);

	/*res = HPF.ar(res, SinOsc.kr(
		LFNoise2.kr(0.3, 1, 1.3),
		0,
		1000,
		1000));*/

	16.do({
		arg indx;
		var amp;
		amp = amp_base / (indx + 1);
		res = res + (BPF.ar(src, base_frq * (indx + 1), 0.1 *(1.01 - amp)) * amp);
	});

	// res = BPF.ar(res, 1000, 0.05);
	// res = res * 5;
	res = LPF.ar(res, 2500);
	res = res * amp * 7;
	Out.ar(~send_delay, res);
	Out.ar(0, [res, res*0.3]);
}).add;

SynthDef(\my_delay_proto, {
	var in, res = 0;
	in = In.ar(~send_delay, 1);
	5.do({
		arg index;
		res = res + DelayC.ar(
			in,
			3,
			0.5 * (index + 1),
			0.5/(index + 1)
		);
	});

	Out.ar(0, [res*0.3, res]);
}).add;
)

~my_delay = Synth(\my_delay_proto);
~my_delay.free;

FreqScope.new;

~filtered = Synth(\filtered_proto, [\base_frq, 220 + 440.rand]);
// ~filtered.set(\base_frq, 220 + 440.rand);
~filtered.set(\gate, 0);
~filtered.run(0);
~filtered.run(1);
~filtered.free;

(
~part1 = TempoClock.new(1);
~filtered = Synth(\filtered_proto, [\base_frq, 220 + 440.rand]);
)

(
~part1.sched(0.01, {
	~filtered.set(\gate, 0);
	~filtered = Synth(\filtered_proto, [\base_frq, 220 + 440.rand]);
	2;
});

)

(
~part1.stop;
~filtered.free;
)


{
	WhiteNoise.ar(0.1)
}.play;