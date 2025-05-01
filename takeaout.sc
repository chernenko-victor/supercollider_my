(
~bus_1ch_feedback = Bus.audio(s, 1);
)

(

~markov_func = {
	arg last_index, markov_arr;
	[0, 1, 2, 3, 4].wchoose(markov_arr[last_index]);
};

//===============================================================

~midi_arr1 = [63, 64, 67, 69, 66]; //eb4, e4, g4, //a4, f#4

~midi_mark_arr11 = [30,	25,	20,	15,	10].normalizeSum;
~midi_mark_arr12 = [25,	25,	30,	15,	10].normalizeSum;
~midi_mark_arr13 = [30,	25,	20,	15,	10].normalizeSum;
~midi_mark_arr14 = [25,	30,	20,	5,	3].normalizeSum;
~midi_mark_arr15 = [20,	25,	30,	3,	5].normalizeSum;

~midi_mark_arr1 = [
	~midi_mark_arr11
	, ~midi_mark_arr12
	, ~midi_mark_arr13
	, ~midi_mark_arr14
	, ~midi_mark_arr15
];

~last_index1 = 0;

//===============================================================

~midi_arr2 = [62, 65, 69, 64, 67]; //d4, f4, a4, //e4, g4
~midi_arr3 = [68, 70, 72, 66, 73]; //ab4, bb4, c5, //f#4, c#5
~midi_arr4 = [59, 61, 66, 63, 65]; //b3, c#4, f#4, //eb4, f4
)



(
SynthDef(\tuba, {
	arg out = 0, frq = 440.0, amp = 0.9, gate = 1,
	attackTimeFrq = 0.01, decayTimeFrq = 0.3, sustainLevelFrq = 0.5, releaseTimeFrq = 1.0, peakLevelFrq = 1.0, curveFrq = -4,
	attackTimeAmp = 0.01, decayTimeAmp = 0.3, sustainLevelAmp = 0.5, releaseTimeAmp = 1.0, peakLevelAmp = 1.0, curveAmp = -4;
	var num_obertone = 16, res;
	res = Mix.fill(num_obertone, {
		arg i;
		var frq_obertone, amp_obertone, frq_dither, amp_dither, frq_env, amp_env;
		//var attackTimeFrq = 0.01, decayTimeFrq = 0.3, sustainLevelFrq = 0.5, releaseTimeFrq = 1.0, peakLevelFrq = 1.0, curveFrq = -4;
		//var attackTimeAmp = 0.01, decayTimeAmp = 0.3, sustainLevelAmp = 0.5, releaseTimeAmp = 1.0, peakLevelAmp = 1.0, curveAmp = -4;
		frq_obertone = frq * (i + 1);
		amp_obertone = amp / ((i + 1)**2.5);
		frq_dither = LFNoise2.kr({Rand(10.5, 50.5)}).range(0.997, 1.002);
		amp_dither = LFNoise2.kr({Rand(0.5, 5.5)}).range(0.75, 1.7);
		frq_env = EnvGen.kr(
			Env.adsr(attackTimeFrq, decayTimeFrq, sustainLevelFrq, releaseTimeFrq, peakLevelFrq, curveFrq)
			, gate
			, doneAction: 2);
		amp_env = EnvGen.kr(
			Env.adsr(attackTimeAmp, decayTimeAmp, sustainLevelAmp, releaseTimeAmp, peakLevelAmp, curveFrq)
			, gate
			, doneAction: 2);
		SinOsc.ar(
			frq_obertone * frq_dither //* frq_env
			, 0
			, amp_obertone * amp_dither * amp_env);
	});
	//res = SinOsc.ar(frq);
	Out.ar(out, (res/(0.5*num_obertone))!2);
}).add;

SynthDef(\fm_perc, {
	arg out = 0, sig, env_amp, gate = 1, frq = 440.0, amp = 0.8,
	attackTime = 0.1, releaseTime = 0.5, level = 1.0, curve = -4.0, depth_feedback = 0.5;
	var in_feedback;
	var frq_feedback;
	env_amp = EnvGen.kr(
		Env.perc(attackTime, releaseTime, level, curve)
		, gate
		, doneAction: 2
	);
	//in_feedback = In.ar(~bus_1ch_feedback, 1).range(0, 2.0*pi);
	frq_feedback = frq * 10 * (1 + (env_amp * 2/3.0));
	frq_feedback = depth_feedback * frq_feedback;
	in_feedback = LFNoise2.ar(frq_feedback).range(0, 2.0*pi);
	//in_feedback = DelayC.ar(in_feedback, maxdelaytime: 0.2, delaytime: 0.01, mul: 1.0, add: 0.0);

	sig = SinOsc.ar(
		frq + SinOsc.ar(frq/10.0).range(-10, 20)
		, in_feedback
	);
	Out.ar(out, (sig * env_amp * amp) ! 2);
	//Out.ar(~bus_1ch_feedback, sig);
}).add;


SynthDef(\feedback_synt_another, {
	var source, local;
	source = Decay.ar(
		Impulse.ar(
			0.5
		)
	) * WhiteNoise.ar(0.2);
	local = LocalIn.ar(2) + [source, 0];
	//local = [source, 0];
	local = DelayN.ar(local);
	LocalOut.ar(local.reverse * 0.8);
	Out.ar(0, local);
}).add;
)



~tuba1 = Synth(\tuba, [\frq, 880.0]);
~tuba2 = Synth(\tuba, [\frq, 110.0]);
~tuba1.set(\gate, 0);
~tuba2.release;

~tuba1.free;
~tuba2.free;

//{LFNoise2.kr({Rand(50.5, 105.5)}).range(0.997, 1.002)}.plot(10);


//Env.adsr(attackTime: 0.01, decayTime: 0.3, sustainLevel: 0.5, releaseTime: 1.0, peakLevel: 1.0, curve: -4.0,).test(2).plot;

//Env.perc(attackTime: 0.1, releaseTime: 0.5, level: 1.0, curve: -4.0).test(2).plot;

{LFNoise2.ar(20).range(0, 2.0*pi)}.plot(5);

(
~fm_perc1 = Synth(\fm_perc, [
	\frq, (220.0.rand + 440.0)
	, \amp, (0.7.rand + 0.2)
	, \attackTime, exprand(0.01, 0.2)
	, \depth_feedback, exprand(0.001, 1)
]);
)



(
var last_frq;
//~sin_osc1.set(\midi, ~midi_arr[~last_index]);
~last_index1.postln;
last_frq = ~midi_arr1[~last_index1].midicps;
last_frq.postln;
~tuba1 = Synth(\tuba, [\frq, last_frq]);
~last_index1 = ~markov_func.value(~last_index1, ~midi_mark_arr1);
)
~tuba1.set(\gate, 0);