// fft fx

(
SynthDef(\fft_rand_comb_proto, {
	arg master_send_lvl_db = 0, in_bus = 100, out_bus = 0;
	var in, chain, out;

	//in = [WhiteNoise.ar(0.8), WhiteNoise.ar(0.8)];
	in = In.ar(in_bus, 2);

	//chain = FFT(LocalBuf(2048), in); // encode to frequency domain
	chain = FFT(LocalBuf([2048, 2048]), in); // stereo buffer
    chain = PV_RandComb(chain, 0.95, Impulse.kr(0.4)); // process
    out = IFFT(chain); // decode to time domain
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;
)