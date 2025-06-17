(
~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);
)

(

SynthDef(\player_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0;
	var out;
	out = PlayBuf.ar(2, buf, BufRateScale.kr(buf) , loop: 1);
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;

// Воспроизведение с возможностью изменения скорости
SynthDef(\sample_player_rate_var_proto, {
	arg buf = 0, rate = 1, out_bus = 0, master_send_lvl_db = 0.0;
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) *
		PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * rate,
			loop: 1
		)
	);
}).add;


// example
// ~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, 0.5]);
// ~sample_player_rate_var.free;


// Воспроизведение с возможностью изменения скорости и стартовой позиции
SynthDef(\sample_player_rate_var_start_pos_proto, {
	arg buf = 0, rate = 1, out_bus = 0, master_send_lvl_db = 0.0, start_pos_fract = 0;
	// Sample frame to start playback
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) *
		PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * rate,
			loop: 1,
			startPos: BufFrames.kr(buf) * start_pos_fract
		)
	);
}).add;


// example
// ~sample_player_rate_var_start_pos = Synth(\sample_player_rate_var_start_pos_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, -0.5, \start_pos_fract, 0.5]);
// ~sample_player_rate_var_start_pos.free;


// Воспроизведение с возможностью изменения скорости, ретриггеренгом скорости и стартовой позиции

SynthDef(\sample_player_retgig_rate_proto, {
	arg
	    rate_begin = 1.0
	  , rate_end = 1.0
	  , buf = 0
	  , out_bus = 0
	  , master_send_lvl_db = 0.0
	  , rate = 1.0
	  , start_pos_fract = 0.0
	  , env_time = 3.0;

	var
	    env_rate
	  , env_rate_gen;

	env_rate = Env.new(levels: [rate_begin, rate_begin, rate_end], times: [0.01, env_time]);
	env_rate_gen = EnvGen.kr(env_rate, \trig_rate.tr);
	// env_rate_gen = EnvGen.kr(env_rate, trig_frq);

	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) *
		PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * env_rate_gen,
			// BufRateScale.kr(buf) * rate,
			loop: 1,
			startPos: BufFrames.kr(buf) * start_pos_fract // Sample frame to start playback
		)
	);
}).add;


// example
~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\out_bus, ~master_send, \rate_begin, 2.0, \rate_end, 2.5, \trig_rate, 1]);
~sample_player_retgig_rate.set(\trig_rate, 1);
~sample_player_retgig_rate.set(\rate_begin, 2.0, \rate_end, 0.5, \env_time, 0.5, \trig_rate, 1);
~sample_player_retgig_rate.set(\rate_begin, 2.5, \rate_end, 2.0, \env_time, 5, \trig_rate, 1);
~sample_player_retgig_rate.free;

/*
SynthDef(\sample_player_retgig_rate_proto, {
	arg
	    buf = 0
	  , rate = 1
	  , out_bus = 0
	  , master_send_lvl_db = 0.0
      , rate_begin = 1.0
	  , rate_end = 1.0
	  , start_pos_fract = 0;

	var
	  env_rate
	  , env_rate_gen;

	env_rate = Env.new(
	    levels: [rate_begin, rate_begin, rate_end]
	  , times: [0.001, 3]
	);

	env_rate_gen = EnvGen.new(env_rate, \trig_rate.tr);

	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) *
		PlayBuf.ar(
			2,
			buf,
			// BufRateScale.kr(buf) * env_rate_gen,
			BufRateScale.kr(buf) * rate,
			loop: 1,
			startPos: BufFrames.kr(buf) * start_pos_fract // Sample frame to start playback
		)
	);
}).add;


// example
// ~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \start_pos_fract, 0.5, \trig_rate, 1]);
// ~sample_player_retgig_rate.free;
*/

SynthDef(\granulator2_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0;
	var out, center_pos, dur = 1, env, env_form;
	env_form = Env.new(
		levels: [0.5, 0.5, 0.05],
		times: [0.01, 1]
	);
	env = EnvGen.kr(env_form, \trig_dur.tr);
	dur = dur * env;
	center_pos = (SinOsc.kr(0.3).range(dur/2, BufDur.kr(buf)/2))*LFNoise2.kr(0.7).range(0.3, 1);
	// out = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1);
	out = TGrains.ar(
		numChannels: 2,
		trigger: Impulse.kr(LFNoise2.kr(0.7).range(0.3, 100)),
		bufnum: buf,
		rate: 1,
		// centerPos: BufDur.kr(buf)/2,
		centerPos: center_pos,
		dur: dur,
		amp: 0.5
	);

	/*
	TODO separate fx
	4.do({
		arg indx;
		out = CombC.ar(out, 0.5, 0.5 / (indx + 1), 0.1 * (indx + 1));
	});
	out = Mix.fill(6, {
		AllpassC.ar(out, 1, [0.8*rand(0.01, 1), 0.8*rand(0.01, 1)], 1*rand(0.5, 2));
	});
	out = out / 6;
	out = Compander.ar(out, out, dbamp(-3), 0.2, 1);
	out = Limiter.ar(out, 0.92);*/

	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;

)