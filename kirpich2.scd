// Сдвигает на определенный офсет и умножает на заданное число
(
SynthDef("binStretch2", { arg out=0, soundBufnum=2, limit_lvl = 0.5, limit_bus = 0;
    var in, chain;
    in = PlayBuf.ar(2, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chain = FFT({ LocalBuf(2048) } ! 2, in);
    chain = PV_BinShift(chain, MouseX.kr(0.25, 4, \exponential) ); // РАстягивает
	// Out.ar(out, 0.5 * IFFT(chain).dup);
	Out.ar(limit_bus, limit_lvl * IFFT(chain));
}).add;
)

(
~binStretch2 = Synth(\binStretch2, [
	\limit_bus, ~bus_send_to_limit,
	\soundBufnum, ~buf3,
	\limit_lvl, 0.2
]);
)

~binStretch2.set(\limit_lvl, 0.0);

~binStretch2.set(\soundBufnum, ~buf4);
~binStretch2.free;

========================================================
~buf7 = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia7.wav");

(
SynthDef(\sample_player_stokhast_phasor_prog, {
	arg bufnum = 0, limit_bus = 0, limit_lvl = 0;
	var sig, phasor;
	phasor = LFNoise1.ar(0.1) * BufFrames.ir(bufnum);
	// rate = LFNoise2.kr(0.3).range(0.3, 3);
	// sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)*rate);
	sig = BufRd.ar(
		2
		, bufnum
		, phasor
	);
	// Out.ar(0, sig);
	Out.ar(limit_bus, limit_lvl * sig);
}).add;
)


(
~test = {
	WhiteNoise.ar(0.2);
}.play;
)
~test.free;

(
SynthDef(\test2, {
	Out.ar(limiter_bus, sig);
}).add;
)

(
~sample_player_stokhast_phasor1 = Synth(\sample_player_stokhast_phasor_prog, [
	\bufnum, ~buf3,
	\limit_bus, ~bus_send_to_limit,
	\limit_lvl, 0.1
]);
)

~sample_player_stokhast_phasor1.set(\limit_lvl, 0.5);

~sample_player_stokhast_phasor1.set(\soundBufnum, ~buf1);
~sample_player_stokhast_phasor1.free;