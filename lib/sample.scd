// read some test samples to buffer
(
// ~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
// ~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);

~pf1_buf = Buffer.read(s, "D:/audio/samples/04-mic2-231205_1439.wav");
~pf1_mono_buf = Buffer.readChannel(s, "D:/audio/samples/04-mic2-231205_1439.wav", channels: 0);
)


// to listen example, send it output tu master
// ~master = Synth(\master_proto, [\in_bus, ~master_send]);


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

// ========================================================================
// Sample player with rate and start position control,
// master send and 2 fx sends
SynthDef(\sample_player_rate_var_start_pos_proto, {
	arg
	    buf = 0
	  , rate = 1
	  , out_bus = 0
	  , master_send_lvl_db = 0.0
	  , start_pos_fract = 0
	  , send_fx1_bus = 0
	  , send_fx1_lvl_db = -96
	  , send_fx2_bus = 0
	  , send_fx2_lvl_db = -96
	  , gate = 1
	;
	var
	    out
	  , amp_env_form
	  , amp_env
	;

	amp_env_form = Env.asr(releaseTime: 0.01);
	amp_env = EnvGen.kr(amp_env_form, gate, doneAction: 2);

	out = PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * rate,
			loop: 1,
			startPos: BufFrames.kr(buf) * start_pos_fract
		);

	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * amp_env * out
	);
	Out.ar(
		send_fx1_bus,
		dbamp(send_fx1_lvl_db) * amp_env * out
	);
	Out.ar(
		send_fx2_bus,
		dbamp(send_fx2_lvl_db) * amp_env * out
	);
}).add;


// ========================================================================
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

	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;

SynthDef(\write_to_buf_and_wrap__proto, {
	arg bus_out = 0, bus_rec = 1000;
	var
	  buf = 0, // read_write_buf
	  pointer,
	  pitch,
	  degree,
	  bus_in = 0,
	  sig_in,
	  sig_out
	;

	sig_in = In.ar(bus_in, 1);

	RecordBuf.ar(
		sig_in,
		bufnum: buf,
		loop: 1
	);

	pointer = LFSaw.ar(1/30).range(0, 1);
    // control pitch with MouseX
	degree = TRand.kr(1, 10, Impulse.kr(0.5)).ceil; // .poll
	// pitch = MouseX.kr(0.5, 2);
	pitch = pow(1.036, degree); // .poll

	sig_out = Warp1.ar(
        numChannels: 1,
        bufnum: buf,
        pointer: pointer,
        freqScale: pitch,
        windowSize: 0.1,
        envbufnum: -1, // Hanning envelope
        overlaps: 8,
        windowRandRatio: 0.1,
        interp: 2
    );

	Out.ar(bus_out, Pan2.ar(sig_out, 0.1));
	Out.ar(bus_rec, Pan2.ar(sig_out, 0.1));
}
).add;

// granulator, send to 'write to buf + wrap'
SynthDef(\granulator_send_to_wrap__proto,
{
	arg buf = 0, bus_out = 0, bus_rec = 1000, rate_lo = 0.05, rate_hi = 30;
	var rate, sig_out, bus_send1 = 1001; // 'bus_send1' for write to buf
	sig_out = TGrains.ar(
		1,
		Impulse.ar(
			LFNoise2.kr(0.1).exprange(rate_lo, rate_hi).reciprocal //.poll
		),
		buf,
		BufRateScale.ir(buf),
		centerPos: LFNoise2.kr(0.13).range(0, BufDur.kr(buf)), // MouseX.kr(0, BufDur.kr(buf)),
		dur: LFNoise0.kr(3).range(0.01, BufDur.kr(buf)/4)
	);

	Out.ar(bus_send1, sig_out);
	Out.ar(bus_out, Pan2.ar(sig_out, -0.3));
	Out.ar(bus_rec, Pan2.ar(sig_out, -0.3));
}).add;

)

////////////////////////////////////////
//           examples

// ~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~pf1_buf, \out_bus, ~master_send, \rate, 0.5]);
// ~sample_player_rate_var.free;


// ~sample_player_rate_var_start_pos = Synth(\sample_player_rate_var_start_pos_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, -0.5, \start_pos_fract, 0.5]);
// ~sample_player_rate_var_start_pos.free;


// example
// ~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\out_bus, ~master_send, \rate_begin, 2.0, \rate_end, 2.5, \trig_rate, 1]);
// ~sample_player_retgig_rate.set(\trig_rate, 1);
// ~sample_player_retgig_rate.set(\rate_begin, 2.0, \rate_end, 0.5, \env_time, 0.5, \trig_rate, 1);
// ~sample_player_retgig_rate.set(\rate_begin, 2.5, \rate_end, 2.0, \env_time, 5, \trig_rate, 1);
// ~sample_player_retgig_rate.free;



// example
// ~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \start_pos_fract, 0.5, \trig_rate, 1]);
// ~sample_player_retgig_rate.free;