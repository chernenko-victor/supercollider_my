FreqScope.new;

{SinOsc.ar()*0.3}.play

{SinOsc.ar()*0.3}.asSynthDef(fadeTime: 0.1, name: \test_osc).add;


{Saw.ar()*0.2}.asSynthDef(fadeTime: 0.1, name: \test_saw).add;


(
{
	SinOscFB.ar(feedback: SinOsc.kr(3).range(0, 0.5)) * 0.3;
}.asSynthDef(fadeTime: 0.1, name: \test_sin_feedback).add;
)

//

x = Synth(\test_osc);
x.free;

(
Pdef(\test_osc_pl,
	Pbind(
		\instrument, \test_osc
	)
).stop;
)

s.plotTree;

(
Pdef(\test_saw_pl,
	Pbind(
		\instrument, \test_saw
	)
).stop;
)


(
Pdef(\test_sin_feedback_pl,
 	Pbind(
 		\instrument, \test_sin_feedback
 	)
).stop;
)

// =======================

(
~test_sin_feedback = {
	SinOscFB.ar(feedback: SinOsc.kr(3).range(0, 0.5)) * 0.3;
}.asDefName;
)

~test_sin_feedback1 = Synth(~test_sin_feedback);

~test_sin_feedback1.free;


// fails !!!
// (
// Pdef(\test_sin_feedback_pl,
// 	Pbind(
// 		// \instrument, \test_sin_feedback
// 		\instrument, ~test_sin_feedback1,
// 	)
// ).stop;
// )


// ======================

(
{
	Impulse.ar() * 0.3;
}.play;
)

(
{
	Klang.ar(`[[200, 400, 800], [0.5, 0.3, 0.1], [0, 0, 0]], 1, 0);
}.play;
)


(
{
	Dust.kr(2) * 0.1;
}.plot(5);
)

(
{
	var in = WhiteNoise.ar(0.2);
	BPF.ar(
		in: in,
		freq: SinOsc.kr(0.2).exprange(200, 2000),
		rq: SinOsc.kr(0.2).exprange(0.05, 0.1)
	) * 3;
}.play;
)

(
{
	arg freq = 440;
	var in = WhiteNoise.ar(0.2), out;

	out = Mix.fill(8, {
		arg i;
		BPF.ar(
			in: in,
			freq: freq * (i + 1),
			rq: SinOsc.kr(0.2).exprange(0.05, 0.1)
		) / (i + 1);
	});
	out;
}.play(args: [\freq, 600]);
)


(
{
	arg freq = 440;
	var in = WhiteNoise.ar(0.2), out;

	out = Mix.fill(8, {
		arg i;
		BPF.ar(
			in: in,
			freq: freq * (i + 1),
			rq: SinOsc.kr(0.2).exprange(0.05, 0.1)
		) / (i + 1);
	});
	out = LPF.ar(out, 4000);
}.asSynthDef(fadeTime: 0.1, name: \substr_synth).add;
)

(
Pdef(\substr_synth_pl,
	Pbind(
		\instrument, \substr_synth,
		// \freq, Pseq([220, 440, 660, 220, 330], inf).trace,
		// \midinote, Pseq([60, 62, 63, 65, 67], inf).trace,
		\degree, Pseq([0, 1, 2, 3, 4], inf).trace,
		\dur, Prand([1, 0.5, Rest(1), 1, 0.5, Rest(1)], inf).trace,
	)
).stop;
)

// ==============================================

(
{
	arg freq = 440;
	var in = Pulse.ar(50), out;

	out = Mix.fill(8, {
		arg i;
		BPF.ar(
			in: in,
			freq: freq * (i + 1),
			rq: SinOsc.kr(0.2).exprange(0.05, 0.1)
		) / (i + 1);
	});
	out = HPF.ar(out, 70);
	out = HPF.ar(out, 70);
	out = HPF.ar(out, 70);
	out = LeakDC.ar(out);
	out = LPF.ar(out, 4000);
}.asSynthDef(fadeTime: 0.1, name: \substr_impls_synth).add;
)

(
Pdef(\substr_synth_pl,
	Pbind(
		\instrument, \substr_impls_synth,
		// \freq, Pseq([220, 440, 660, 220, 330], inf).trace,
		// \midinote, Pseq([60, 62, 63, 65, 67], inf).trace,
		\degree, Pseq([0, 1, 2, 3, 4], inf).trace,
		\dur, Prand([1, 0.5, Rest(1), 1, 0.5, Rest(1)], inf).trace,
	)
).stop;
)