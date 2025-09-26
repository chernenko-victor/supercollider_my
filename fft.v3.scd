///////////////////////////////////////////
//         Подготовка к работе
///////////////////////////////////////////

// Надо запустить код из fx.scd

// Включаем финальную обработку
(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

///////////////////////////////////////////
//         ПАттерны. Продолжение
///////////////////////////////////////////

// Арифметическая прогрессия
Pseries

// Геометрическая прогрессия
Pgeom

Pdup //repeat input stream values

//////////////////////
(
var data = [7, 13, 12, 2, 2, 2, 5];
var indices = [0, 0, 2, 0, 4, 6, 7];
Pbind(
	// \instrument, \help_pindex,
    \choice, Prand(indices, inf),
    \degree, Pindex(data, Pkey(\choice), inf),
    \dur, 0.7
).play
)

//////////////////////////


// Ptuple создает созвучия, выбирая по одному элементу с одинаковыми индексами из нескольких списков
//
// Ptuple(
// 	[1, 2, 3, ...]
// 	[-1 , 0 , 1 ...]
// 	[440, 300, 1000]
// )
//
// Pbind будет исполнять:
// [1, -1, 440], [2, 0, 300], ....


(
~freq1_arr = [220, 440, 580, 700, 850];

~accord_ptrn = Ptuple([
	Prand(~freq1_arr, inf),
	Pser(~freq1_arr + 200, inf),
	Prand(~freq1_arr, inf) + 400
], inf);

~accord_part_play = Pbind(
	\freq, ~accord_ptrn
).play;

)
~accord_part_play.stop;


//////////////////////////
// Pclump - еще один способ получать списки

~clumb_prn = Pclump(3, Prand(~freq1_arr, inf));

~clumb_stream = ~clumb_prn.asStream;
~clumb_stream.next();


//////////////////////////
/*Частичное повторение элементов, аналог sample & hold для паттернов.

Если элемент во втором паттерне true или 1, то первый паттерн работает как обычно,

если элемент во втором паттерне false или 0, то первый паттерн повторяет предыдущее значение */
(
Pclutch(
	Pseq([1, 2, 3, 4, 5], 3),
	Pseq([0, 0, 1, 0, 0, 0, 1, 1])
).asStream.nextN(10);
)



/////////////////////////////////////////
/*Последвательное исполнение Pbind*/

// Pxrand([
// 	Pbind,
// 	Pbind,
// 	...
// 	]

// Играет разыми Pbind в случайном порядке
(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
		\instrument, \default,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\default,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\default,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\default,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

// Последовательное включение Pbind
(
Pser([
	Pbind(
		\freq, Pseq([\rest], 1),
		\dur, 10
	), // Пауза 10 секунд
	Pbind(
		// \instrument, \am_synth_proto,
		// \freq, ~degree2_ptrn,
		\freq, Prand([1108.70, 987.75, 659.26, 739.98, 2217.40, 1975.50, 1480.00, 1318.50], 5),
		\dur, Prand([1, 2, 3, 4, 6, 8]*0.5, 5),
		\amp, 0.1
	),
	Pbind(
		\freq, Pseq([Rest()], 1),
		\dur, 3
	), // Пауза 3 секунды
	Pbind(
		// \instrument, \am_synth_proto,
		\freq, Prand([1, 2, Rest(0), 4, 6, 8, Rest(0)]*440, 20),
		\dur, Prand([1, 2, 3, 4, 6, 8]*0.25, 20),
		\amp, 0.1
	)
], 7).play;
)


/////////////////////////////////////////
// Изменение паттернов во время работы Pbind
(
~degree = PatternProxy(Pn(Pseries(0, 1, 8), inf));
~dur = PatternProxy(Pn(0.25, inf));

p = Pbind(
    \degree, ~degree,
    \dur, ~dur
).play;
)

~degree.source = (Pexprand(1, 8, inf) - 1).round;
~degree.source = (Pn(Pseries(0, 1, 8), inf));

~dur.source = Pwrand(#[0.25, 0.5, 0.75], #[0.5, 0.3, 0.2], inf);

p.stop;


/////////////////////

// samples =================================

(
// Загружаем семпл в специальную область памяти - буфер (Buffer). Это одномерный массив чисел, индексы начинаются с 0/
~buf1 = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia1.wav"); // Путь к файлу надо заменить
~buf1.numChannels; //показывает кол-во каналов

~buf1_chnl1 = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia1.wav", channels: [0]);
~buf1_chnl1.numChannels;

~buf2 = Buffer.read(s, "C:/home/chernenko/src/supercollider/hse/2023_24/lsn13/cl_solo_am.wav");
~buf2.numChannels;

~buf3 = Buffer.read(s, "C:/home/chernenko/audio/cons/2_2023_24/rec105/Media/05-rec line 2-231130_1232.wav");
~buf3.numChannels;


~buf4 = Buffer.read(s, "C:/home/chernenko/audio/cons/4_2023_24/record_korg/record_korg3.wav");
~buf4.numChannels;

~v_ni_buf_mono = Buffer.readChannel(s, "C:/home/chernenko/src/supercollider/hse/20024_25/discrete_midi_in/discrete_midi_in_frag1.wav", channels: [0]);


~pad_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/45426__timkahn__super-fm-pad-c3.aiff");
~pad_buf.numChannels;
)

////////////////////////
//   simple play buf
////////////////////////


// Воспроизведение с возможностью изменения скорости
(
SynthDef(\sample_player_proto, {
	arg buf = 0;
	Out.ar(
		~master_send,
		PlayBuf.ar(
			2,
			buf,
			BufRateScale.kr(buf),
			loop: 1
		)
	);
}).add;
)

~test_sample = Synth(\sample_player_proto, [\buf, ~pad_buf]);
~test_sample.free;

////////////////////////////////////
// BufRd - свободное управление скоростью и направлением воспроизведения
(
SynthDef(\player_var_speed_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, begin = 0, end = 1;
	var out;
	out = BufRd.ar(
		2,
		buf,
		LFNoise1.ar(100) * BufFrames.ir(buf)
		// Варианты обхода буфера:
		// SinOsc.ar(0.1, 0, 0.5, 0.5) * BufFrames.ir(buf) // последовательное изменение направления
		/*
		(1-LFSaw.ar(BufDur.ir(buf).reciprocal)).
		    range(BufFrames.ir(buf) * begin, BufFrames.ir(buf) * end)
		// Обратное воспроизведение части семпла
		*/
	);
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * out
	);
}).add;
)


~player_var_speed = Synth(\player_var_speed_proto, [\buf, ~pad_buf, \out_bus, ~master_send]);
~player_var_speed.free;
// , \begin, 0.3, \end, 0.7


///////////


// Гранулярный синтез

// GrainBuf
// TGrains
// используются только одноканальные буферы

(
SynthDef(\granulator_proto, {
	var out, buf = 1;
	out = GrainBuf.ar(
		2,
		Impulse.kr(
			TRand.kr(0.01, 2, Dust.kr(0.3))
		),
		0.9,
		buf,
		LFNoise2.kr(0.1).exprange(0.2, 1.5),
		LFNoise2.kr(0.1).range(0, 1),
		pan: 0.7
	);
	Out.ar(~dynamic_send, out * (2.dbamp));
	Out.ar(~space_send, out * (-6.dbamp));
	// Out.ar(0, out);
}).add;
)


/////////////////////////////////////////////
//     pitch sihift / time stretch
/////////////////////////////////////////////

// В Warp1 используются только одноканальные буферы

(
SynthDef(\timestretch_pitchsift_proto, {
	arg envbuf = -1, buf = 0, speed = 1, out_bus = 0, master_send_lvl_db = 0.0, pitch = 1;
    var pointer, dur, freq_phasor, out;

	dur = BufDur.ir(buf);
	freq_phasor = (1/dur)*speed;
	freq_phasor = freq_phasor * LFNoise2.kr(0.5).range(0.5, 2);
    pointer = LFSaw.ar(freq_phasor).range(0, 1);
    // Управление с помощью положения мыши на экране, очень удобно для тестирования разных значений параметров
	pitch = MouseX.kr(0.5, 2); //MouseY

    out = Warp1.ar(
        numChannels:1,
        bufnum:buf,
        pointer:pointer,
        freqScale:pitch,
        windowSize:0.1,
        envbufnum:envbuf,
        overlaps:8,
        windowRandRatio:0.1,
        interp:2
    );
	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

~timestretch_pitchsift = Synth(\timestretch_pitchsift_proto, [\buf, ~buf2, \out_bus, ~master_send]);
~timestretch_pitchsift.free;
// \speed, 0.001, \pitch, 0.25

// Другие объекты для pitch sihift / time stretch
// WarpZ
// WarpOverlap



/////////////////////////////
////         FFT         ////
/////////////////////////////

FreqScope.new;

///////////////////////////////////
// Преобразование Фурье для моно-сигнала:
// chainL = FFT(LocalBuf(2048), in);
// используется локальный буфер, которые доступен только внутри синта

(
SynthDef(\fft_demo_proto, {
	arg out_bus = 0, master_send_lvl_db = 0.0;
    var out, in, chain;

	in = WhiteNoise.ar(0.1);
    chain = FFT(LocalBuf(2048), in); // Прямое преобразование Фурье
	//// FD begin

	// chain = FFT_Obj(chain)

    out = IFFT(chain); // Обратный FFT

	// TD begin

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

~fft_demo = Synth(\fft_demo_proto, [\out_bus, ~master_send]);
~fft_demo.free;



// Со стерео так не работает
//fft = FFT(LocalBuf(2048, 2), aStereoSignal);

// Но можно сделать так
//fft = FFT(LocalBuf(2048.dup(2), 1), aStereoSignal);

(
SynthDef(\fft_stereo_sample_proto, {
	arg out_bus = 0, master_send_lvl_db = 0.0, buf = 0;
    var out, in, chain;

	in = PlayBuf.ar(2, buf, BufRateScale.kr(buf), doneAction: 2);
	chain = FFT(LocalBuf(2048.dup(2), 1), in);
	//Здесь можно вставлять объекты для работы со спектром
    out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

/////////////////////////////////////////
// PV_BinShift Сдвигает и растягивает частотные корзины
// shift - кол-во частотных корзин, на которое будет произведен сдвиг
// stretch - коэффициент, на который будут умножены частоты всех корзин
(
SynthDef(\fft_bin_shift_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, stretch = 1, shift = 0;
    var out, in, chain;

	stretch = MouseX.kr(-10.1, 10.1);
	// shift = SinOsc.kr(0.5).range(5, 100);
	shift = LFNoise2.kr(0.5).range(5, 100);

	in = PlayBuf.ar(2, buf, BufRateScale.kr(buf), doneAction: 2);
    chain = FFT(LocalBuf(2048.dup(2), 1), in); // Прямое преобразование Фурье
	chain = PV_BinShift(chain, stretch: stretch, shift: shift);
    out = IFFT(chain); // Обратный FFT

	// out = Compander.ar(out, out, 0.1, 3.5, 0.3);

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~buf3, \out_bus, ~master_send]);
~sample_player_rate_var.free;


1 / ((2048 / s.sampleRate))

~fft_bin_shift = Synth(\fft_bin_shift_proto, [\buf, ~buf3, \out_bus, ~master_send, \shift, 10, \stretch, 1]);
~fft_bin_shift.free;

////////////////////////////////////////////////////

// Как тестировать разные значения параметров:

// 1. MouseX
// 2. LFNoise...
// 3. Ретриггер огибающей:
// Пример см. env_retrigg.scd

///////////////////////////////////////////
// PV_MagShift сдвигает только амплитуды частотных корзин, фазы остаются на месте

(
SynthDef(\fft_mag_shift_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, stretch = 1, shift = 0;
    var out, in, chain;

	in = PlayBuf.ar(2, buf, BufRateScale.kr(buf), doneAction: 2);
	// in = SinOsc.ar();
    chain = FFT(LocalBuf(2048.dup(2), 1), in);
	//Здесь можно вставлять объекты для работы со спектром
	chain = PV_MagShift(chain, stretch, shift);
	out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;

)

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~buf3, \out_bus, ~master_send]);
~sample_player_rate_var.free;

~fft_mag_shift = Synth(\fft_mag_shift_proto, [\buf, ~buf3, \out_bus, ~master_send, \shift, 100, \stretch, 2]);
~fft_mag_shift.free;

// PV_Copy(chainA, LocalBuf(2048)) - если нужно сделать "разветвление" в цепи обработки сигнала во frequency domain

/////////////////////////////////////////////
// Выключаем блок финальной обработки

(
~master.free;
)

