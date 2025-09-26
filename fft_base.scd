(
~fft_bins_freq = Array.fill(10, {
	arg indx;
	indx * (44100 / 2048);
});
)

// (
// ~fft_bins_freq = Array.fill(10, {
// 	arg indx;
// 	indx * ((s.sampleRate) / 2048);
// });
// )

Demand
collect
poll

~fft_bins_freq.poll;


(
~printed = 0;
{
	var src, chain, fft_base_frq, fft_size, numframes;
	// src = 1;
	numframes = 10;
	fft_size = 2048;
	fft_base_frq = 44100 / fft_size;

	/*numframes.do({
		var indx;
		src = src + SinOsc.ar((indx + 1) * fft_base_frq);
	});*/

	src = Mix.fill(numframes, {
		arg indx;
		SinOsc.ar((indx + 1) * fft_base_frq);
	});

	chain = FFT(LocalBuf(fft_size), src);
	// ================ change src there ============
	// chain = PV_BinShift(chain, 1, 0);

	chain.pvcalc(numframes, {
		| magnitudes, phases |
		if(
			~printed == 0,
			{
				~printed == 1;
				magnitudes.poll;
				phases.poll;
			}
		);
		[magnitudes, phases]
	}, frombin: 0, tobin: numframes, zeroothers: 0);

}.play;

)


(
{
    var in, chain, v;
    in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop: 1);
    chain = FFT(LocalBuf(1024), in);
​
    chain = chain.pvcalc(1024, {|mags, phases|
//////// Try uncommenting each of these lines in turn and re-running the synth:
        [mags * {1.5.rand}.dup(mags.size), phases + {pi.rand}.dup(phases.size)]; // Arbitrary filter, arbitrary phase shift
        //[mags.reverse, phases.reverse]; // Upside-down!
        //[mags.differentiate, phases.differentiate]; // Differentiate along frequency axis
        //[mags[30..] ++ mags[..30], phases[30..] ++ phases[..30]]; // ".rotate" doesn't work directly, but this is equivalent
    }, frombin: 0, tobin: 250, zeroothers: 0);
​
    0.5 * IFFT(chain).dup
}.play
)

