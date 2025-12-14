//Установка языковых расширений (quarks)

// Ищем нужное на https://quarks.supercollider.online/
//
// Проверяем, есть ли такой пакет в Language -> Quarks, если есть, устанавливаем оттуда.
//
// Или с помощью кода Quarks.install("Название");
//
// например
//
// Quarks.install("MathLib");
//
//
// Так же можно указать ссылку на репозиторий
//
// Quarks.install("https://github.com/redFrik/Bjorklund");



/*UGens - дополнительные серверные плагины (server plugins)

Например https://github.com/supercollider/sc3-plugins (см. PV_Morph, PV_SoftWipe и др.)

или VST плагины в SC https://git.iem.at/pd/vstplugin/-/releases


1. Скачиваем https://github.com/supercollider/sc3-plugins/releases архив для нужной ОС

2. Определяем директорию для расширений

Platform.userExtensionDir;

3. Создаем в ней поддиректорию

4. Распаковываем туда архив

5. Перезапускаем грфическую оболочку Super Collider
При старте вы увидите сообщения
compiling class library...
...
Compiling directory "Название директории"

Там будет название поддиректории, значит все установилось, можно пользоваться*/






///////////////////////////////////////////
//         Подготовка к работе
///////////////////////////////////////////

(
// Воспроизведение с возможностью изменения скорости
SynthDef(\sample_player_rate_var_proto, {
	arg buf = 0, rate = 1, out_bus = 0, master_send_lvl_db = 0.0;
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) *
		PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf) * rate,
			loop: 1
		)
	);
}).add;


~master_send = Bus.audio(s, 2);

SynthDef(\master_proto, {
	arg
	    limit_lvl_db = -0.7
	  , thresh = 0.5
	  , slopeBelow = 1
	  , slopeAbove = 1
	  , compressor_out_lvl_db = 0
	;
	var in, out, master_send_lvl_db = 0, out_bus = 0, in_bus = 100;
	in = In.ar(~master_send, 2);
	// in = In.ar(in_bus, 2);
	in = Compander.ar(
		  in: in
		, control: in
		, thresh: thresh
		, slopeBelow: slopeBelow
		, slopeAbove: 1.0
		, clampTime: 0.01
		, relaxTime: 0.1
		, mul: dbamp(compressor_out_lvl_db)
	);
	out = Limiter.ar(in, dbamp(limit_lvl_db));
	out = LeakDC.ar(out);
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;
)

// Включаем финальную обработку
(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

/////////////////////
//    samples
/////////////////////

// Надо запустить код из sampler.scd

(
~glitch_loops_buf = Buffer.read(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav");
~glitch_loops_buf.numChannels;

~bird_calls_buf = Buffer.read(s, "C:/home/Admin/audio/40780__crk365__bird-calls.wav");
~bird_calls_buf.numChannels;

~glitch_loops_mono_buf = Buffer.readChannel(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav", channels: [0]);

~glitch_loops_mono_buf.play;

~pf_buf = Buffer.read(s, "D:/audio/samples/05-rec line 2-231130_1232.wav"); // mono
~pf_buf.play;
~pf_buf.numChannels;
)


////////////////////////
//   simple play buf
////////////////////////

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~glitch_loops_buf, \out_bus, ~master_send, \rate, 0.5]);
~sample_player_rate_var.free;

(
~bin_shift_send = Bus.audio(s, 2);
~bin_shift_send2 = Bus.audio(s, 2);
~bin_shift_send3 = Bus.audio(s, 2);
~fft_scramble_send = Bus.audio(s, 2);
~fft_conformal_send = Bus.audio(s, 2);

/*
SynthDef(\fft_test_signal_proto, {
	arg out_bus = 0, master_send_lvl_db = 0.0, pos = 0.0;
    var out = 0, in;

	10.do({
		arg indx;
		out = out + SinOsc.ar(~test_signal_freq_arr[indx]);
	});

	Out.ar(out_bus, Pan2.ar(dbamp(master_send_lvl_db) * out, pos));
}).add;
*/

SynthDef(\fx_fft_bin_shift_proto, {
	arg buf = 0, out_bus = 0, in_bus = 100, master_send_lvl_db = 0.0, stretch = 1, shift = 0;
    var out, in, chain;

	// in = In.ar(~bin_shift_send, 1);
	in = In.ar(in_bus, 1);

    chain = FFT(LocalBuf(2048.dup(2), 1), in); // Прямое преобразование Фурье
	chain = PV_BinShift(chain, stretch: stretch, shift: shift);
    out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;


SynthDef(\fx_fft_scramble_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, stretch = 1, shift = 0, in_bus = 100;
    var out, in, chain;

	in = In.ar(in_bus, 1);

    chain = FFT(LocalBuf(2048.dup(2), 1), in); // Прямое преобразование Фурье
	chain = PV_BinScramble(chain, MouseX.kr, 0.1, MouseY.kr > 0.5 );
    out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;


SynthDef(\fx_fft_conformal_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, stretch = 1, shift = 0, in_bus = 100;
    var out, in, chain;

	in = In.ar(in_bus, 1);

    chain = FFT(LocalBuf(2048.dup(2), 1), in); // Прямое преобразование Фурье

	chain = PV_ConformalMap(chain, MouseX.kr(0.01,2.0, 'exponential'), MouseY.kr(0.01,10.0, 'exponential'));

	out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

////////////////////////////////////////////////
////////////           test area  //////////////
////////////////////////////////////////////////



// ~fft_test_signal = Synth(\fft_test_signal_proto, [\out_bus, ~bin_shift_send]);
// ~fft_test_signal.free;


// sample player
//
// \/
//
// shifter
//
// \/
//
// master

// Запускаем "снизу вверх", следим чтобы стек синтов соответствовал схеме
s.plotTree;

(
~fx_fft_bin_shift = Synth(\fx_fft_bin_shift_proto, [
	// \buf, ~buf1_chnl1,
	\in_bus, ~bin_shift_send,
	\out_bus, ~master_send,
	\shift, 10,
	\stretch, 1]
);
)
~fx_fft_bin_shift.free;

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~bird_calls_buf, \out_bus, ~bin_shift_send, \rate, 0.5]);
~sample_player_rate_var.free;


//////////////////////////////////////////////////
// sample player
//
// \/
//
// scrambler
//
// \/
//
// master

(
~fx_fft_scramble = Synth(\fx_fft_scramble_proto, [
	// \buf, ~buf1_chnl1,
	\in_bus, ~fft_scramble_send,
	\out_bus, ~master_send]
);
)
~fx_fft_scramble.free;

(
~sample_player_rate_var_scramble = Synth(\sample_player_rate_var_proto, [
	\buf, ~glitch_loops_buf,
	\out_bus, ~fft_scramble_send,
	\rate, 0.5]
);
)
~sample_player_rate_var_scramble.free;


//////////////////////////////////////////////////
// sample player
//
// \/
//
// scrambler
//
// \/
//
// shifter
//
// \/
// master

(
~fx_fft_bin_shift2 = Synth(\fx_fft_bin_shift_proto, [
	\in_bus, ~bin_shift_send,
	\out_bus, ~master_send,
	\shift, 5,
	\stretch, 1]
);
)
~fx_fft_bin_shift2.free;

(
~fx_fft_scramble = Synth(\fx_fft_scramble_proto, [
	\in_bus, ~fft_scramble_send,
	\out_bus, ~bin_shift_send]
);
)
~fx_fft_scramble.free;

(
~sample_player_rate_var_scramble = Synth(\sample_player_rate_var_proto, [
	\buf, ~bird_calls_buf,
	\out_bus, ~fft_scramble_send,
	\rate, 0.5]
);
)
~sample_player_rate_var_scramble.free;


//////////////////////////////////////////////////
// sample player
//
// \/
//
// shifter1   shifter2   shifter
//
// \/            \/         \/
//  \            /          /
//           scrambler
//
//               \/
//             master


/////////////////////////
(
~fx_fft_scramble = Synth(\fx_fft_scramble_proto, [
	\in_bus, ~fft_scramble_send,
	\out_bus, ~master_send]
);
)
~fx_fft_scramble.free;


//////////

(
~fx_fft_bin_shift1 = Synth(\fx_fft_bin_shift_proto, [
	\in_bus, ~bin_shift_send,
	\out_bus, ~fft_scramble_send,
	\shift, 5,
	\stretch, 1]
);
~fx_fft_bin_shift2 = Synth(\fx_fft_bin_shift_proto, [
	\in_bus, ~bin_shift_send2,
	\out_bus, ~fft_scramble_send,
	\shift, -100,
	\stretch, 2]
);
~fx_fft_bin_shift3 = Synth(\fx_fft_bin_shift_proto, [
	\in_bus, ~bin_shift_send3,
	\out_bus, ~fft_scramble_send,
	\shift, 200,
	\stretch, 0.5]
);
)

(
~fx_fft_bin_shift1.free;
~fx_fft_bin_shift2.free;
~fx_fft_bin_shift3.free;
)

/////////////////////////
(
~sample_player_rate_var_scramble = Synth(\sample_player_rate_var_proto, [
	\buf, ~glitch_loops_buf,
	\out_bus, ~bin_shift_send,
	\rate, 0.5]
);

~sample_player_rate_var_scramble2 = Synth(\sample_player_rate_var_proto, [
	\buf, ~glitch_loops_buf,
	\out_bus, ~bin_shift2_send,
	\rate, 0.5]
);

~sample_player_rate_var_scramble3 = Synth(\sample_player_rate_var_proto, [
	\buf, ~bird_calls_buf,
	\out_bus, ~bin_shift3_send,
	\rate, 0.5]
);
)

(
~sample_player_rate_var_scramble.free;
~sample_player_rate_var_scramble2.free;
~sample_player_rate_var_scramble3.free;
)

//////////////////////////////////////////////////
// sample player
//
// \/
//
// fft conformal
//
// \/
//
// master

(
~fx_fft_conformal = Synth(\fx_fft_conformal_proto, [
	\in_bus, ~fft_conformal_send,
	\out_bus, ~master_send]
);
)
~fx_fft_conformal.free;


(
~sample_player_rate_var_conformal = Synth(\sample_player_rate_var_proto, [
	\buf, ~bird_calls_buf,
	\out_bus, ~fft_conformal_send,
	\rate, 0.5]
);
)
~sample_player_rate_var_conformal.free;

////////////////////////////////////
/*
PV_RandComb in fft_fx.scd
PV_BinShift in fftft
*/

/*
Объекты для преобразования спектра в Frequency Domain

PV_CopyPhase
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

*/


/*
// plot magnitudes:
~plotmags = {|buf, lbl| buf.loadToFloatArray(action:{|data| {data[0,2..]  .max(0.000001)  .log.normalize  .plot(lbl)}.defer})};

~plotmags.(~cepbuf, "cepstrum");
~plotmags.(~fftbuf, "liftered (smoothed) spectrum");

[~fftbuf, ~cepbuf].do(_.free);

// https://doc.sccode.org/Classes/Cepstrum.html


// самостоятельное редактирование магнитуд и фаз
chain = chain.pvcollect(b.numFrames, {|mag, phase, index|
		mag + DelayN.kr(mag, 1, v);
	}, frombin: 0, tobin: 256, zeroothers: 1);
*/

// process bins by user's fuction
(
{
    var chain = FFT(LocalBuf(64), hop: 1);
    chain.fftSize.poll;
    0.0
}.play;
)

chain.pvcalc(..., {
	 |magnitudes, phases| // this is array
    [mags.reverse, phases.reverse]
}
chain.pvcalc2 // same for 2 signals

.pvcollect(numframes, {
	// applying a function to each bin of an FFT chain.
	|magnitude, phase, bin, index|
    // randomize magnitudes somewhat (noisier signal)
    [magnitude * (5.0.rand2.dbamp), phase]
}

UnpackFFT
PackFFT

MovingAverage

/////////////////////////////////////////////
// Выключаем блок финальной обработки

(
~master.free;
)

