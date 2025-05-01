
s.latency;
s.options.memSize; //8192
s.options.memSize_(8192 * 2);



////////

(
{
	/*BHiPass4.ar(
		WhiteNoise.ar(0.1),
		200,
		SinOsc.kr(0.5, 0).range(0.1, 2)
	);*/

	var src;
	src = WhiteNoise.ar(0.1);
	/*10.do({
		src = HPF.ar(
			src,
			25
		);
	});*/

	// src = LeakDC.ar(src, 0.95);
	src = BLowShelf.ar(src, 20, 0.6, -24);
	src;
}.play;
)

{ LeakDC.ar(DC.ar(0.5)) }.plot(0.5);
{ HPF.ar(DC.ar(0.5), 10) }.plot(0.5);

{ LeakDC.ar(SinOsc.ar + DC.ar(0.5)) }.plot(0.02);
{ HPF.ar(SinOsc.ar + DC.ar(0.5), 10) }.plot(0.02);
////////////////////


(
{
	var delta = 0.5, trig, env, env_form, dur, attc_ratio = 0.05, out;
	var level, times;
	delta = LFNoise0.kr(3).range(1, 5).floor;
	dur = delta * 0.8;
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	// env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	// env_form = Env.adsr(0.1, 0.05, 1, 0.5);
	level = [0, 1, 1, 0.3, 1, 0];
	times = [0.2, 0.2,  0.2, 0.2, 0.2];
	env_form = Env.new(level, times);
	env = EnvGen.kr(env_form, trig);
	out = env * SinOsc.ar();
	env;
}.plot(duration: 20);
)

//play

/////////////////////
(
{
	var delta = 0.5, trig, env, env_form, dur, attc_ratio = 0.05, out;
	delta = LFNoise0.kr(3).range(1, 5).floor;
	dur = delta * 0.8;
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	// env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	env_form = Env.adsr(0.1, 0.05, 1, 0.5);
	env = EnvGen.kr(env_form, trig);
	out = env * SinOsc.ar();
}.plot(duration: 20);
)

(
{
	var delta = 0.5, trig, env, env_form, dur, attc_ratio = 0.05, out;
	delta = LFNoise0.kr(3).range(1, 5).floor;
	dur = delta * 0.8;
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	// env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	env_form = Env.adsr(0.1, 0.05, 1, 0.5);
	env = EnvGen.kr(env_form, trig);
	out = env * SinOsc.ar();
}.play;
)

////////////////////////////
(
{
	var delta = 0.5, trig, env, env_form, dur, attc_ratio = 0.05, out;
	dur = delta * 0.8;
	delta = LFNoise0.kr(3).range(1, 5).floor;
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	env = EnvGen.kr(env_form, trig);
	out = env * SinOsc.ar();
}.plot(duration: 5);
)

(
{
	var delta = 0.5, trig = 0, env, env_form, dur, attc_ratio = 0.05, out;
	delta = LFNoise0.kr(3).range(1, 5).floor;
	delta = delta * 0.25;
	// delta = 0.25 * TRand.kr(1, 4, (1 - trig)); //DOESNT WORK HERE
	dur = delta * 0.8;
	// trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	/*env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	env = EnvGen.kr(env_form, trig);
	out = env * SinOsc.ar();*/
	// 1 - trig;
	// delta = 0.25 * TRand.kr(1, 4, (1 - trig)); DOESNT WORK
	// delta = LFNoise0.kr(0.3).range(1, 4); DOESNT HERE, but see upper
	//DC ???
	trig;
}.plot(duration: 5);
)

(
{
	var delta;
	delta = LFNoise0.kr( //delta change speed
		LFNoise2.kr(0.3).range(
			3, //min
			10 //max
		)
	).range( //delta limits
		1,
		SinOsc.kr(0.05, 0, 3, 5)
	).floor;
	delta;
}.plot(duration: 20);
)

/////////////////////////////////////////////
(
~master_send = Bus.audio(s, 2);
~revv_send = Bus.audio(s, 1);
~pitch_shifter_send = Bus.audio(s, 2);

~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
~arturia0_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia1.wav");
~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);
)


// Rand It generates this when the SynthDef first starts playing, and remains fixed for the duration of the synth's existence
//
// ExpRand, IRand, LinRand, NRand, TExpRand, TIRand, TRand


(
SynthDef(\selftrig_additive_proto, {
	arg
	freq = 440,
	master_send_lvl_db = -1.0,
	revv_send_lvl_db = -3.0,
	pitch_shifter_send_lvl_db = -6.0;
	var delta = 0.5, trig, env, env_form, dur, attc_ratio = 0.05, out;
	delta = LFNoise0.kr( //delta change speed
		LFNoise2.kr(0.3).range(
			3, //min
			10 //max
		)
	).range( //delta limits
		1,
		SinOsc.kr(0.05, 0, 3, 5)
	).floor;
	delta = delta * 0.5;
	dur = delta * 0.8;
	trig = Trig.kr(Impulse.kr(1/delta), dur: dur);
	env_form = Env.perc(dur * attc_ratio, dur * (1 - attc_ratio));
	env = EnvGen.kr(env_form, trig);

	out =
	SinOsc.ar() +
	(
		0.3 * (
			SinOsc.ar(
				TRand.kr(400, 500, trig)
			) *
			SinOsc.ar(
				XLine.kr(20, 100, dur)
			)
		)
	);

	out = out * env;
	/*
	out = SinOsc.ar(freq);
	out = out * SinOsc.ar(
		XLine.kr(0.5, 100, 5)
	);*/

	Out.ar(~master_send, (out * dbamp(master_send_lvl_db)).dup(2));
	Out.ar(~revv_send, out * dbamp(revv_send_lvl_db));
	Out.ar(~pitch_shifter_send, out * dbamp(pitch_shifter_send_lvl_db));
}).add;


SynthDef(\revv_proto, {
	arg master_send_lvl_db = -6.0;
	var out, in;
	in = In.ar(~revv_send, 2);
	out = in!2;
	4.do({
		arg indx;
		out = CombC.ar(out, 0.5, 0.5 / (indx + 1), 0.1 * (indx + 1));
	});
	out = Mix.fill(6, {
		AllpassC.ar(out, 1, [0.8*rand(0.01, 1), 0.8*rand(0.01, 1)], 1*rand(0.5, 2));
	});
	// out = out / 6;
	Out.ar(~master_send, out * dbamp(master_send_lvl_db));
}).add;


SynthDef(\pitch_shifter_proto, {
	arg master_send_lvl_db = -6.0, pos = 0, phase = 2 * 3.14;
	var out, in;
	in = In.ar(~pitch_shifter_send, 2);
	// out = LeakDC.ar(in);
	out = PitchShift.ar(
		in,
		0.02, // grain size
		// Line.kr(0.1,4,20), // pitch shift ratio
		SinOsc.kr(0.1, phase).range(0.1, 4), // pitch shift ratio
		0, // pitch dispersion
		0.0001 // time dispersion
	);
	Out.ar(
		~master_send,
		Pan2.ar(out * dbamp(master_send_lvl_db), pos)
	);
}).add;


SynthDef(\master_proto, {
	var out, in;
	in = In.ar(~master_send, 2);
	out = LeakDC.ar(in);
	out = Limiter.ar(out, 0.92);
	Out.ar(0, out);
}).add;
)

///////////////////////


~master = Synth(\master_proto);
~revv = Synth(\revv_proto);
~pitch_shifter1 = Synth(\pitch_shifter_proto, [\pos, -0.4]); //, \master_send_lvl_db, -3.5
~pitch_shifter2 = Synth(\pitch_shifter_proto, [\pos, 0.4, \phase, (0.5 * 3.14)]);

~selftrig_additive1 = Synth(\selftrig_additive_proto, [\revv_send_lvl_db, -36]);
~selftrig_additive1.set(\revv_send_lvl_db, -96);
~selftrig_additive1.set(\pitch_shifter_send_lvl_db, -6);

~selftrig_additive1.free;
~pitch_shifter2.free;
~pitch_shifter1.free;
~revv.free;
~master.free;


//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
(
~master = Synth(\master_proto);
~revv = Synth(\revv_proto);
~pitch_shifter1 = Synth(\pitch_shifter_proto, [\pos, -0.4]); //, \master_send_lvl_db, -3.5
~pitch_shifter2 = Synth(\pitch_shifter_proto, [\pos, 0.4, \phase, (0.5 * 3.14)]);
)

(
// *_state vars values :: -1 = before, 0 = works, 1 = after
~part1_state = -1;
~parts = TempoClock(1);

~parts.sched(0, {
	arg beats;

	[beats, ~part1_state, ((beats > 30 ) && (~part1_state == 0))].postln;
	case
	{ ~part1_state == -1 } {
		~selftrig_additive1 = Synth(\selftrig_additive_proto, [\revv_send_lvl_db, -36]);
		"part1 starts".postln;
		~part1_state = 0;
	}
	{ (beats > 30 ) && (beats <= 60 ) && (~part1_state == 0) } {
		~selftrig_additive1.free;
		"part1 stops".postln;
		~part1_state = 1;
	}
	// restart part1
	{ (beats > 60 ) && (beats <= 90 ) && (~part1_state == 1) } {
		~selftrig_additive1 = Synth(\selftrig_additive_proto, [\revv_send_lvl_db, -36]);
		"part1 starts".postln;
		~part1_state = 0;
	}
	{ (beats > 90 ) && (~part1_state == 0) } {
		~selftrig_additive1.free;
		"part1 stops".postln;
		~part1_state = 1;
	}
	;

	1;
});
)

(
~parts.stop;
~selftrig_additive1.free;
~pitch_shifter2.free;
~pitch_shifter1.free;
~revv.free;
~master.free;
)