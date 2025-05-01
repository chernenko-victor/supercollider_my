s.plotTree;

~bus_send_to_fft_mul1 = Bus.audio(s, 2);
~bus_send_to_fft_mul2 = Bus.audio(s, 2);
~bus_send_to_compress = Bus.audio(s, 2);
~bus_send_to_limit = Bus.audio(s, 2);


// Загружаем семпл в специальную область памяти - буфер (Buffer). Это одномерный массив чисел, индексы начинаются с 0/
~buf1 = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia1.wav"); // Путь к файлу надо заменить
~buf1.numChannels; //показывает кол-во каналов

~buf2 = Buffer.read(s, "C:/home/chernenko/src/supercollider/hse/2023_24/lsn13/cl_solo_am.wav");
~buf2.numChannels;


~buf3 = Buffer.read(s, "C:/home/chernenko/audio/cons/2_2023_24/rec105/Media/05-rec line 2-231130_1232.wav");
~buf3.numChannels;


~buf4 = Buffer.read(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg3.wav");
~buf4.numChannels;


~buf5 = Buffer.read(s, "C:/home/chernenko/audio/music/chernenko/kirpich/kirpich.v5.wav");
~buf5.numChannels;


// {PlayBuf.ar(2, ~buf5, BufRateScale.kr(~buf5), loop: 1)}.play;

(
SynthDef(\limiter_proj, {
	arg out = 0, bus = 0, limit_lvl = 0.4, lookAheadTime = 0.01;
	var sig;
	sig = In.ar(bus, 2);
	Out.ar(out, Limiter.ar(sig, limit_lvl, lookAheadTime));
}).add;

SynthDef(\fft_mul_proj, {
	arg amp = 0.5, out = 0, bus1 = 0, bus2 = 0, limit_lvl = 0.5, limit_bus = 0;
	var inA, chainA, inB, chainB, chain, sig;
    inA = In.ar(bus1, 2);
	inB = In.ar(bus2, 2);
    chainA = FFT({ LocalBuf(2048) } ! 2, inA);
    chainB = FFT({ LocalBuf(2048) } ! 2, inB);
    chain = PV_Mul(chainA, chainB);
	sig = IFFT(chain);
    Out.ar(out, amp * sig);
	Out.ar(limit_bus, limit_lvl * sig);
}).add;

SynthDef(\sample_player_proj, {
	arg soundBufnum = 0, dry_lvl = 0.5, fft_mul_lvl = 0.5, fft_mul_bus = 0, limiter_bus = 0;
	var sig;
	sig = PlayBuf.ar(2, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	Out.ar(limiter_bus, sig*dry_lvl);
	Out.ar(fft_mul_bus, sig*fft_mul_lvl);
}).add;
)


~out_stereo = Synth(\limiter_proj, [\bus, ~bus_send_to_limit, \limit_lvl, 0.9]);

(
~fft_mul = Synth(\fft_mul_proj, [
	\bus1, ~bus_send_to_fft_mul1,
	\bus2, ~bus_send_to_fft_mul2,
	\limit_bus, ~bus_send_to_limit,
	\limit_lvl, 0.9,
	\amp, 0.1
]);
)


~sample_player1 = Synth(\sample_player_proj, [\soundBufnum, ~buf5, \limiter_bus, ~bus_send_to_limit, \fft_mul_bus, ~bus_send_to_fft_mul1, \dry_lvl, 0.9, \fft_mul_lvl, 0.01]);


~sample_player1.set(\dry_lvl, 0.0);
~sample_player1.run(false);
~sample_player1.run();
~sample_player1.free;

//========================================
~perc_selftrig_send1 = Synth(\sample_player_proj, [\soundBufnum, ~buf2, \fft_mul_bus, ~bus_send_to_fft_mul1, \dry_lvl, 0.0, \fft_mul_lvl, 0.2]);


~perc_selftrig_send1.free;

~perc_selftrig_send2 = Synth(\sample_player_proj, [\soundBufnum, ~buf3, \fft_mul_bus, ~bus_send_to_fft_mul2, \dry_lvl, 0.0, \fft_mul_lvl, 0.2]);
~perc_selftrig_send2.free;

~perc_selftrig_send1.set(\fft_mul_lvl, 0.2);
~perc_selftrig_send2.set(\fft_mul_lvl, 0.2);

/*
~perc_selftrig_send1.set(\dry_lvl, 0.1);
~perc_selftrig_send1.set(\fft_mul_lvl, 0.9);
~perc_selftrig_send2.set(\dry_lvl, 0.1);
~perc_selftrig_send2.set(\fft_mul_lvl, 0.9);
*/
