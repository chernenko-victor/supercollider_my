(
b = Buffer.alloc(s,2048,1);
c = Buffer.alloc(s,2048,1);
//d = Buffer.read(s,"sounds/oceanMONO.aif");
//d = Buffer.read(s,"G:\\src\\music\\sc\\lsn5\\ClassGuit.wav");
~buf1 = Buffer.read(s, "E:\\src\\sc\\hse\\2022_23\\lsn7\\K01Bass125A-04.wav"); //моно файл
d = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\beats.wav");
e = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\cl_solo_a1_mono.wav");
f = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\fox.wav");
)

(
SynthDef(\binStretch_live, {
	arg out=0;
    var in, chain;
    in = LFSaw.ar(200, 0, 0.2);
    chain = FFT(LocalBuf(2048), in); //or use b = Buffer.alloc(s,2048,1)
    chain = PV_BinShift(chain, MouseX.kr(0.25, 4, \exponential) );
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).add;

SynthDef(\binStretch_sample, {
	arg out=0, soundBufnum1 = 0;
    var in, chain;
    in = PlayBuf.ar(1, soundBufnum1, BufRateScale.kr(soundBufnum1), loop: 1);
    chain = FFT(LocalBuf(2048), in); //or use b = Buffer.alloc(s,2048,1)
    chain = PV_BinShift(
		chain
		, LFNoise1.kr(
			freq: LFNoise1.kr(0.5, 0.5, 0.5)
			, mul: 2.0
			, add: 2.25
		)
	);
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).add;
)

{LFNoise1.kr(freq: 1.0, mul: 4.0, add: 2.25)}.scope();

~binStretch_live1 = Synth(\binStretch_live);
~binStretch1_live.run(false);
~binStretch1_live.run();
~binStretch1_live.free();


~binStretch_sample1 = Synth(\binStretch_sample, [\soundBufnum1, d.bufnum]);
~binStretch_sample1.run(false);
~binStretch_sample1.run();
~binStretch_sample1.free();