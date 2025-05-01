{WhiteNoise.ar(0.2)!2}.play;

(
{
	Impulse.ar(
		LFTri.kr(
			LFTri.kr(
				0.2,
				0,
				8,
				10
			),
			0,
			400,
			800
		),
		0,
		0.1
	)
}.scope(1, zoom: 4);
)

~buff_bomb = Buffer.read(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg3.wav");
~buff_bomb.query;


~buff_bomb_mono = Buffer.readChannel(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg3.wav", channels: 1);
~buff_bomb_mono.query;


~buff_klav = Buffer.read(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg2.wav");
~buff_klav.query;

~buff_klav_mono = Buffer.readChannel(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg2.wav", channels: 1);
~buff_klav_mono.query;

{PlayBuf.ar(2, ~buff_bomb, 1, loop: 1)}.play;

(
SynthDef(\help_PlayBuf, {
	| out = 0, bufnum = 0, loop = 1, chnum = 2 |
    Out.ar(out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), loop: loop)
    )
}).add;
)
~player1 = Synth(\help_PlayBuf, [\bufnum, ~buff_bomb]);
~player1.free;


(
// mouse control of trigger rate and startpos
SynthDef(\help_PlayBuf_trig, {
	arg out=0, bufnum=0;
    var trig, env, env_adsr, env_gate;
	env_adsr = Env.adsr();
	trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
	env_gate = LFPulse.kr(MouseY.kr(0.5, 200, 1), 0, 0.8);
	env = EnvGen.kr(env_adsr, env_gate);
    Out.ar(out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1) * env
    )
}).add;
)

{Pulse.kr(5, 0.9)}.scope(1, zoom: 4);
{LFPulse.kr(500, 0, 0.5)}.scope(1, zoom: 4);


~player2 = Synth(\help_PlayBuf_trig, [\bufnum, ~buff_bomb]);
~player2.free;

Env.new(levels: [0, 1, 1, 0], times: [0.1, 0.5, 0.1], curve: [0, 0, 0]).plot;

(
SynthDef(\play_buff_frag, {
	arg out = 0, bufnum = 0, startPos = 0.5, length = 2.0, gate = 1;
	var env_line, env, sig;
	env_line = Env.new(levels: [0, 1, 1, 0], times: [0.1, length, 0.1], curve: [0, 0, 0]);
	env = EnvGen.kr(env_line, gate, doneAction: 2);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: BufFrames.kr(bufnum)*startPos) * env;
	// Compander
	Out.ar(
		out,
		sig
	);
}).add;
)

~player3 = Synth(\play_buff_frag, [\bufnum, ~buff_bomb, \startPos, 0.5]);
~player3.free;

(
~player_buff_rout = {
	inf.do{
		arg i;
		var timeprop = (i/199.0)**3;
		Synth(\play_buff_frag, [\bufnum, ~buff_bomb, \startPos, (0.1.rrand(0.9)), (i+1)*0.9]);
		// i.postln;
		// i.wait;
		rrand((timeprop*0.1).max(0.01), 3).wait;
	}
}.fork
)
~player_buff_rout.stop;


(
~player_buff_rout2 = {
	inf.do{
		arg i;
		var timeprop = (i/199.0)**3;
		Synth(\play_buff_frag, [\bufnum, ~buff_klav, \startPos, (0.1.rrand(0.9)), (i+1)*0.9]);
		// i.postln;
		// i.wait;
		rrand((timeprop*0.1).max(0.01), 3).wait;
	}
}.fork
)
~player_buff_rout2.stop;


// ===========================================================
// play part of buffer

Env.new([0, 1, 1, 0], [0.1, 1, 0.1], [0, 0, 0]).plot;

(
SynthDef(\play_buf_frag2, {
	arg out = 0, bufnum = 0, startPosPercent = 0.5, gate = 1, len = 1.0;
	var sig, env_line, env;
	env_line = Env.new([0, 1, 1, 0], [0.1, len, 0.1], [0, 0, 0]);
	env = EnvGen.kr(env_line, gate, doneAction: 2);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: BufFrames.kr(bufnum)*startPosPercent);
	Out.ar(out, sig*env);
}).add;
)

Synth(\play_buf_frag2, [\bufnum, ~buff_bomb, \startPosPercent, 0.01.rrand(0.9), \len, 0.1.rrand(2)]);


// ~play_buf_frag2.free;

// fork sample play - from granular to rythm

(
~play_sample_rout1 = {
inf.do{
	arg i;
	var timeprop = (i/199.0)**3;
	// i.postln;
	Synth(\play_buf_frag2, [\bufnum, ~buff_bomb, \startPosPercent, 0.01.rrand(0.9), \len, 0.1.rrand(2)]);
	rrand((timeprop*0.1).max(0.01), 3).wait;
};
}.fork;
)

~play_sample_rout1.stop;

(
~play_sample_rout2 = {
inf.do{
	arg i;
	var timeprop = (i/199.0)**3;
	// i.postln;
	Synth(\play_buf_frag2, [\bufnum, ~buff_klav, \startPosPercent, 0.01.rrand(0.9), \len, 0.1.rrand(2)]);
	rrand((timeprop*0.1).max(0.01), 3).wait;
};
}.fork;
)

// ========================================================================
//                          start piece
// ========================================================================


(
SynthDef(\buf_grain_test, {
	| out, gate = 1, amp = 1, sndbuf, envbuf, trigger_rate = 1, dur = 0.1 |
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
        GrainBuf.ar(
			2, //numChannels
			Impulse.kr(trigger_rate), //trigger
			dur, //dur
			sndbuf,
			LFNoise1.kr.range(0.5, 2), // sample rate
            LFNoise2.kr(0.1).range(0, 1), //the playback position for the grain to start with (0 is beginning, 1 is end of file)
			2, //the interpolation method used for pitchshifting grains
			pan,
			envbuf
	    ) * env)
}).add;
)

// use built-in env
x = Synth(\buf_grain_test, [\sndbuf, ~buff_bomb_mono, \envbuf, -1]);
x.set(\trigger_rate, 50);
x.set(\dur, 0.01);
x.set(\gate, 0);

(
~flag_rout2 = 0;
~flag_rout_klav = 0;
~flag_rout2_stop = 0;
~flag_klav_stop = 0;

~seq1 = TempoClock.new(1);
~seq1.sched(1, {
	arg beat;
	beat.postln;
	// drums start
	if(
		beat > 5,
		{
			if(
				~flag_rout2 == 0,
				{
					"Start!".postln;
					~flag_rout2 = 1;
					~grain_drum = Synth(\buf_grain_test, [\sndbuf, ~buff_bomb_mono, \envbuf, -1]);
				},
				{
					"Nothing!".postln;
					~grain_drum.set(\trigger_rate, 5.0.rrand(50.0));
					~grain_drum.set(\dur, 0.01.rrand(2.0));
				}
			);
			"More than 5 beats!".postln;
		},
		{
			"Less than 5 beats. Keep calm )".postln;
		}
	);
	// klav start
	if(
		beat > 15,
		{
			if(
				~flag_rout_klav == 0,
				{
					"Start klav!".postln;
					~flag_rout_klav = 1;
					~grain_klav = Synth(\buf_grain_test, [\sndbuf, ~buff_klav_mono, \envbuf, -1]);
				},
				{
					"Nothing klav!".postln;
					~grain_klav.set(\trigger_rate, 5.0.rrand(50.0));
					~grain_klav.set(\dur, 0.01.rrand(2.0));
				}
			);
			"More than 15 beats!".postln;
		},
		{
			"Less than 15 beats. Keep calm )".postln;
		}
	);
	// stop drums
	if(
		beat > 35,
		{
			if(
				~flag_rout2_stop == 0,
				{
					"Stop Drums!".postln;
					~flag_rout2_stop = 1;
					~grain_drum.set(\gate, 0);
				},
				{
					// "Nothing!".postln;
				}
			);
			// "More than 5 beats!".postln;
		},
		{
			// "Less than 5 beats. Keep calm )".postln;
		}
	);

	// stop klav
	if(
		beat > 45,
		{
			if(
				~flag_klav_stop == 0,
				{
					"Stop Klavs!".postln;
					~flag_klav_stop = 1;
					~grain_klav.set(\gate, 0);
					~seq1.stop;
				},
				{
					// "Nothing!".postln;
				}
			);
			// "More than 5 beats!".postln;
		},
		{
			// "Less than 5 beats. Keep calm )".postln;
		}
	);

	0.25.rrand(4.0);
});
)

(
~grain_drum.set(\gate, 0);
~grain_klav.set(\gate, 0);
~seq1.stop;
)


// fm synth, tempoClock freq by Markov chain, dur, amp

[60, 62, 65, 67, 70].wchoose([0.5, 0.25, 0.1, 0.05, 0.1]);

(
~rnd_arr = [];
100.do({
	~rnd_arr = ~rnd_arr.add([60, 62, 65, 67, 70].wchoose([0.5, 0.25, 0.1, 0.05, 0.1]));
});
~rnd_arr.plot;
)

// =============================================================
//                     discr
// =============================================================
(
~system1 = [60, 62, 65, 67, 70];
~system2 = [60, 62, 65, 67, 70] + 5;
~system3 = [60, 62, 65, 67, 70] - 10;
~weight = [0.5, 0.25, 0.1, 0.05, 0.1];
)

[0.5, 0.25, 0.1, 0.05, 0.1];
[0.5, 0.25, 0.1, 0.05, 0.1].rotate;

~weight = ~weight.rotate;

[100, 79, 34, 22, 11].normalizeSum;

(
var midi = ~system3.wchoose([0.5, 0.25, 0.1, 0.05, 0.1]);
~synth_def = Synth(\default, [\freq, midi.midicps]);
)
~synth_def.set(\gate, 0);

// =============================================================
//                          markov
// =============================================================

(
~mark1_row1 = [50, 10, 15, 30, 10].normalizeSum;
~mark1_row2 = [10,	15,	30,	10,	50].normalizeSum;
~mark1_row3 = [10,	50,	10,	15,	30].normalizeSum;
~mark1_row4 = [50,	10,	15,	10,	30].normalizeSum;
~mark1_row5 = [10,	30,	50,	10,	15].normalizeSum;

~mark1 = [~mark1_row1, ~mark1_row2, ~mark1_row3, ~mark1_row4, ~mark1_row5];
)

~current_index = 0.rrand(4);

(
~current_midi = ~system1[~current_index];
~current_midi.postln;
~current_index = [0, 1, 2, 3, 4].wchoose(~mark1[~current_index]);
)


(
~note_on = 0;
~seq2 = TempoClock.new(1);
~seq2.sched(1, {
	if(
		~note_on == 0,
		{
			~current_midi = ~system1[~current_index];
			~current_midi.postln;
			~synth_def = Synth(\default, [\freq, ~current_midi.midicps]);
			~current_index = [0, 1, 2, 3, 4].wchoose(~mark1[~current_index]);
			~note_on = 1;
		},
		{
			~synth_def.set(\gate, 0);
			~note_on = 0;
		}
	);

	0.25.rrand(4.0);
});
)


// ========================================================================
//                          end piece
// ========================================================================


// ========================================================================
//                          ideas
// ========================================================================

// additive synth
// Pbind, frequency by different stokh distrib, duration by weihted discrete, amp


// final limiter





// drums from noise
// tempoClock drums, duration from sequence (arythm, geom)


// sidechain compressor Compander
// from drums to other

// aux to delay with feedback

// form of piece - tempoClock

// GUI for stokh limit