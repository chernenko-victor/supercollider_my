(
{
	SinOsc.ar(440) * SinOsc.ar(660)
}.play;
)
FreqScope.new;

(
~glitch_loops_buf = Buffer.read(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav");
~glitch_loops_buf.numChannels;
~glitch_loops_buf.play;


~bird_calls_buf = Buffer.read(s, "C:/home/Admin/audio/40780__crk365__bird-calls.wav");
~bird_calls_buf.numChannels;
~bird_calls_buf.play;

~glitch_loops_mono_buf = Buffer.readChannel(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav", channels: [0]);

~glitch_loops_mono_buf.play;

~pf_buf = Buffer.read(s, "D:/audio/samples/05-rec line 2-231130_1232.wav"); // mono
~pf_buf.play;
~pf_buf.numChannels;
)

2**11

(
{
	var
	  buf = ~glitch_loops_buf,
	  rate = 1,
	  sin_in,
	  chain,
	  out_sig,
	  out_sig2,
	  stretch = MouseX.kr(0.1, 10),
	// stretch = 1,
	shift = MouseY.kr(-100, 100),
	sig_in2,
	buf2 = ~pf_buf,
	chain2
	;
	sin_in = PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * rate,
			loop: 1
		);

	sig_in2 = PlayBuf.ar(
			2,
			buf2,
			BufRateScale.kr(buf2) * rate,
			loop: 1
		);

	// sig_in2 = DelayC.ar(sin_in, 2, 2);

	chain = FFT(LocalBuf(2048.dup(2), 1), sin_in);
	chain2 = FFT(LocalBuf(2048.dup(2), 1), sig_in2);
	// Прямое преобразование Фурье
	// chain = PV_BinShift(chain, stretch: stretch, shift: shift);
	// chain = PV_BinScramble(chain, MouseX.kr(0.1, 1), 0.1, MouseY.kr > 0.5);
	/*chain = PV_ConformalMap(
		chain,
		MouseX.kr(0.01,2.0, 'exponential'),
		MouseY.kr(0.01,10.0, 'exponential')
	);*/
	// chain = PV_Diffuser(chain, MouseY.kr > 0.5);
	// chain = PV_MagFreeze(chain, MouseY.kr > 0.5);
	// chain = PV_MagSmear(chain, MouseX.kr(0, 100));
	// chain = PV_RectComb(chain, MouseX.kr(0, 32), MouseY.kr, 0.2);
	// chain = PV_MagMul(chain2, chain);
	chain = PV_CopyPhase(chain, chain2);
    out_sig = IFFT(chain); // Обратный FFT
	// out_sig2 = IFFT(chain2); // Обратный FFT

	out_sig;
}.play;
)

PV_CopyPhase
PV_MagMul

PV_Diffuser
PV_JensenAndersen
PV_MagFreeze
PV_LocalMax
PV_MagAbove
PV_MagBelow
PV_MagSmear
PV_PhaseShift
PV_RandComb
PV_RandWipe
PV_RectComb

Convolution
PartConv