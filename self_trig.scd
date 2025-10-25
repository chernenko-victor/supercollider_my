//required(./lib/stokhastic)

~test_ptrn = Pseries(32, [2, 3].choose, inf);

~test_ptrn.asStream.nextN(10);

Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) });
Prand(Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }), 1);

(
~part1 = Pbind(
	\midinote, Prand(
		Pseries(43, [2, 3].choose, 12).asStream.nextN(10),
		60
	),
	\dur, 0.25
).play;
)
~part1.stop;

/////////////////////////////////////////




(
~part2 = Pbind(
	\midinote, Pseq([67, Rest(), 68, 54, 72, Rest(), 72, 72], 1),
	\dur, 0.25
).play;
)
~part2.stop;


(
SynthDef(\white_noise_substr_adsr_proto, {
	arg freq = 440, gate = 1;
	var out_sound, env_form, env_amp;
	// env_form = Env.perc(0.5, 2.5, curve: 4); // Envelope form
	env_form = Env.adsr();
	env_amp  = EnvGen.kr(env_form, gate, doneAction: 2); // Envelope generator.
	/*
	              "doneAction: 2" deletes synth instance after
	              envelope ends or gate set to 0.
	*/
	out_sound = 0;
	16.do({
		arg index;
		out_sound = out_sound + BPF.ar(
			WhiteNoise.ar(0.1),
			freq * (index + 1),
			0.05 * (1.1 - env_amp) // Modulate band width with envelope used for amplitude
		)
	});
	out_sound = LPF.ar(
		out_sound,
		1800
	);
	out_sound = 3 * out_sound * env_amp;
	out_sound = Limiter.ar(out_sound);
	Out.ar(0, [out_sound, out_sound]); // Bus
}).add;
)

~white_noise_substr_adsr = Synth.new(\white_noise_substr_adsr_proto, [\freq, ~lin_min_distr.value(110, 660)]);
~white_noise_substr_adsr.set(\gate, 0);


(
~part2 = Pbind(
	\instrument, \white_noise_substr_adsr_proto,
	\midinote, Pseq([67, Rest(), 68, 54, 72, Rest(), 72, 72], 1),
	\dur, 0.25
).play;
)
~part2.stop;


/////////////////////////////////////////////////////
/////////////////////      tempo clock    /////////////////
/////////////////////////////////////////////////////

(
~part1  = TempoClock.new(1);
~part1_pause = 0;
)

(
~part1.sched(0.1, {
	if(
		~part1_pause == 0,
		{
			~white_noise_substr_adsr = Synth.new(\white_noise_substr_adsr_proto, [\freq, ~lin_min_distr.value(110, 660)]);
			~part1_pause = 1;
		},
		{
			~white_noise_substr_adsr.set(\gate, 0);
			~part1_pause = 0;
		}
	);
	3.rand + 0.25;
});
)

(
~white_noise_substr_adsr.set(\gate, 0);
~part1.stop;
)


/////////////////////////////////////////////////////
/////////////////////      selftrig    /////////////////
/////////////////////////////////////////////////////

// s

~send_bass_drum = Bus.audio(s, 1);
// ~send_impulse = Bus.control(s, 1);

(
// snare
SynthDef(\selftrig_drum_proto, {
	arg gate = 1;
	var out_audio, src = 0, amp_env_form, amp_env, dur, impulse;
	amp_env_form = Env.perc(0.1, 0.9);
	dur = 0.1 + 0.9;
	impulse = Impulse.ar(0.5 + LFNoise2.ar(0.3, 1.5, 0.8));
	amp_env = EnvGen.ar(amp_env_form, impulse, doneAction: 0);
	src = WhiteNoise.ar(0.05);
	src = LPF.ar(src, 3000 - (1500 * amp_env));
	out_audio = src * amp_env;
	out_audio = Limiter.ar(out_audio, 0.92);
	out_audio = out_audio * 2;
	Out.ar(0, Pan2.ar(out_audio, 0.3));
	Out.ar(~send_bass_drum, impulse);
}).add;


//bass drum
SynthDef(\bass_drum_proto, {
	var out_audio, src, amp_env_form, amp_env, dur, impulse;
	impulse = In.ar(~send_bass_drum, 1);
	amp_env_form = Env.perc(0.07, 1.3);
	amp_env = EnvGen.ar(amp_env_form, gate: impulse, doneAction: 0);
	src = SinOsc.ar(80);
	out_audio = DelayC.ar(src * amp_env, 3, 1);
	out_audio = out_audio / 2;
	Out.ar(0, Pan2.ar(out_audio, -0.3));
}).add;

)

~bass_drum = Synth(\bass_drum_proto);
~selftrig_drum = Synth(\selftrig_drum_proto);


~selftrig_drum.free;
~bass_drum.free;

///////////////////////////////////////////

s.prepareForRecord("C:/home/chernenko/audio/samples/self_trig.wav", 2);

s.record;

s.pauseRecording;

s.stopRecording;

///////////////////////////////////////////

~sample1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/self_trig.wav");
~sample1_buf.numChannels;
~sample1_buf.sampleRate;
~sample1_buf.numFrames;


~sample2_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia1.wav");

(
SynthDef(\my_player_proto, {
	arg buf;
	var out_audio;
	out_audio = PlayBuf.ar(2, buf, BufRateScale.kr(1)*LFNoise2.kr(0.3, 0.5, 0.7), loop: 1);
	Out.ar(0, out_audio);
}).add;
)

~my_player1 = Synth(\my_player_proto, [\buf, ~sample1_buf]);
~my_player1.free;

~my_player2 = Synth(\my_player_proto, [\buf, ~sample2_buf]);
~my_player2.free;

