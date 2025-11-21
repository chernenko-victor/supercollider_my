~read_write_buf = Buffer.alloc(s, 44100 * 10, 1);
~buf_write_bus = Bus.audio(s, 1);

(
SynthDef.new(\write_buf, {
	arg buf = 0, feedback_lvl = 0.1;
	var src = SinOsc.ar(
		SinOsc.kr(1).range(220, 440)
	);
	src = src + (feedback_lvl * In.ar(~buf_write_bus, 1));
	RecordBuf.ar(
		src,
		bufnum: buf,
		loop: 1
	);
}).add;
)

~write_buf1 = Synth(\write_buf, args: [\buf, ~read_write_buf]);

// ~read_write_buf.play;

(
{
	arg buf = 0;
	var sig_out, in;

	in = SoundIn.ar(0);
	// in = WhiteNoise.ar(0.1);

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: BufRateScale.ir(buf) * LFDNoise0.kr(0.1).range(-2.0, 2.0),
		doneAction: 0,
		loop: 1,
	);
	sig_out = Decay2.kr(Dust.kr(1), 0.1, 1) * sig_out;
	sig_out = in + sig_out;
	sig_out = Compander.ar(sig_out, sig_out, 0.7, slopeBelow: 1.3, slopeAbove: 1/5) * 5;
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
	Out.ar(~buf_write_bus, sig_out);
	sig_out;
}.play(args: [\buf, ~read_write_buf]);
)

~write_buf1.set(\feedback_lvl, 0.85);

~write_buf1.free;



s.plotTree;


// working version

(
SynthDef.new(\write_read_buf_v2, {
	arg buf = 0, feedback_lvl = 0.1;
	var src = SoundIn.ar(0), sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: BufRateScale.ir(buf),
		doneAction: 0,
		loop: 1,
	);

	src = src + (feedback_lvl * sig_out);
	RecordBuf.ar(
		src,
		bufnum: buf,
		loop: 1
	);
	Out.ar(0, src);
}).add;
)

~write_read_buf_v2_1 = Synth(\write_read_buf_v2, args: [\buf, ~read_write_buf]);

~write_read_buf_v2_1.set(\feedback_lvl, 0.7);
~write_read_buf_v2_1.free;