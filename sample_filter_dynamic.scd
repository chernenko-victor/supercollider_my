~arturia_sample1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia1.wav");

// ~send_bus

(
SynthDef(\play_buf_proto, {
	arg buf, filter_frq = 200, above_ratio = 1, mul = 1;
	var out_audio = 0;
	// out_audio = WhiteNoise.ar(0.05);
	out_audio = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1);
	3.do({
		// out_audio = BPF.ar(out_audio, 200, 0.05, 3);
		// out_audio = Resonz.ar(out_audio, 200, 0.01, 3);
		out_audio = BBandPass.ar(out_audio, filter_frq, 0.05, 3);
	});
	out_audio = Compander.ar(out_audio, out_audio, 0.1, 0.7, above_ratio, mul: mul);
	out_audio = Limiter.ar(out_audio);
	Out.ar(0, out_audio);
}).add;
)

// ampdb()

~play_buf2 = Synth(\play_buf_proto, [\buf, ~arturia_sample1_buf, \filter_frq, 200, \mul, 2]);
~play_buf2.free;

(
~play_buf1 = Synth(\play_buf_proto, [
	\buf, ~arturia_sample1_buf,
	\filter_frq, 1000,
	\above_ratio, 1/3,
	\mul, 0.3
]);
)
~play_buf1.free;


FreqScope.new;