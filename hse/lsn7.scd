//////////////////////////
//
// Change data between synth by OSC


s.boot;

// Создаем синт, который отсылает значение генератора 10 раз в секунду (Impulse.kr)
(
x = {
    // var freq = LFNoise2.kr(10).range(200, 1000); // Генерируем случайную частоту
	var freq =
	  HenonC.ar(
		0.3,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	  )*800+900
    ;

    // Отправляем 'freq' на клиент по команде '/my_frequency'
    SendReply.kr(Impulse.kr(10), '/my_frequency', freq);
    // SinOsc.ar(freq) * 0.1;
}.play;
)

// Регистрируем OSC-обработчик на клиенте
(
~oscFunc = OSCFunc({ |msg|
    var frequency = msg[3]; // Значения начинаются с 3-го индекса
    ("Полученное значение частоты:" + frequency).postln;
	~additive_example1.set(\freq, frequency);
}, '/my_frequency').add;
)

// Очистка
~oscFunc.free;
x.free;


~additive_example1 = Synth(\additive_example__proto, args: [\freq, 220 + (10.rand * 20)]);


~additive_example1.set(\freq, 220 + (10.rand * 20));


~additive_example1.release;

//////////////////////////

(
{ SinOsc.ar(StandardL.ar(40, MouseX.kr(0.9, 4))*800+900)*0.4 }.asSynthDef(fadeTime: , name: \standard_control__proto).add;
)


/////////////////////////

NetAddr.langPort;

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off

~substr_example = Synth(\additive_example__proto, args: [\freq, 440]);


(
// 1. Слушатель ТОЛЬКО для высоты тона первого синтезатора
OSCdef(\pitchListener, { |msg|
    // var pitchValue = msg[3]; // Берем полезные данные
	var freq;
	freq = msg.midicps;
	freq.postln;
	~substr_example.set(\freq, freq);
    // "Синтезатор 1 сменил ноту на: %".format(pitchValue).postln;
    // Здесь ваш код для изменения паттерна или графики

}, '/synth1/pitch'); // Жестко привязан к этому пути


// 2. Слушатель ТОЛЬКО для громкости второго синтезатора
OSCdef(\ampListener, { |msg|
    var ampValue = msg[3]; // Берем полезные данные

    "Синтезатор 2 сменил громкость на: %".format(ampValue).postln;
    // Здесь ваш код управления громкостью

}, '/synth2/amp'); // Жестко привязан к этому пути
)

~substr_example.release;

//////////////////////////////
//
// OSC send


~remote_port = 65535
~remote_ip = 1.2.3.4

// send message to remote
b = NetAddr.new(~remote_ip, ~remote_port);    // create the NetAddr
b.sendMsg("/fader1", 0.5);
b.free;



===============================================

семплы (sampling)

===============================================

(
// Загружаем семпл в специальную область памяти - буфер (Buffer). Это одномерный массив чисел, индексы начинаются с 0/
~buf1 = Buffer.read(s, "D:/audio/samples/04-mic2-231205_1439.wav"); // Путь к файлу надо заменить
~buf1.numChannels; //показывает кол-во каналов

~buf2_chnl1 = Buffer.readChannel(s, "D:/audio/music/chernenko/lyra8_230426_2.wav", channels: [0]);
~buf2_chnl1.numChannels;

~buf3_chnl1 = Buffer.readChannel(s, "D:/audio/samples/vocal/numbers.wav", channels: [0]);
~buf3_chnl1.numChannels;


~buf4_glitch_loops = Buffer.read(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav");
~buf4_glitch_loops.numChannels;

~buf5_rock_breakbeat = Buffer.read(s, "D:/audio/samples/570888__kaypira_fp__drum-loop-120bpm-rock-breakbeat.wav");

)

~buf5_rock_breakbeat.play;


///////////////////////////////////////////
//         Подготовка к работе
///////////////////////////////////////////

// Надо запустить код из lib/fx.scd
// lib/sample.scd

// Включаем финальную обработку
(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)


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


~player_var_speed = Synth(\player_var_speed_proto, [\buf, ~buf1, \out_bus, ~master_send]);
~player_var_speed.free;
// , \begin, 0.3, \end, 0.7


////////////////////////////////////////////////


// ~granulator1 = Synth(\granulator_rate_ctrl_rec_1fx_send__proto, [\buf, ~buf2_chnl1, \out_bus, ~master_send]);


(
{((LFNoise2.kr(1).range(0.1, 10))**(-1)).poll}.play;
)

(
{((LFNoise2.kr(0.1).exprange(0.01, 50))**(-1)).poll}.play;
)

(
{
	arg buf = 1000;
	var trig, rate;
	rate = ((LFNoise2.kr(0.3).exprange(0.01, 50))**(-1));
	trig = Impulse.kr(
		rate
	);
	TGrains.ar(
		numChannels: 2,
		trigger: trig,
		bufnum: buf,
		centerPos: BufDur.kr(buf) * LFNoise2.kr(1).range(0.01, 0.99),
		dur: BufDur.kr(buf) * 0.1,
		amp: 1,
	);
}.play(args: [\buf, ~buf3_chnl1]);
)

//////////////////////////
// fft

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

~fft_bin_shift = Synth(\fft_bin_shift_proto, [\buf, ~buf3_chnl1, \out_bus, ~master_send, \shift, 10, \stretch, 1]);
~fft_bin_shift.free;


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

~fft_mag_shift = Synth(\fft_mag_shift_proto, [\buf, ~buf5_rock_breakbeat, \out_bus, ~master_send, \shift, 4, \stretch, 2]);
~fft_mag_shift.free;


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

(
{
	var
	  buf = ~buf1,
	  rate = 1,
	  sin_in,
	  chain,
	  out_sig,
	  out_sig2,
	  stretch = MouseX.kr(0.1, 10),
	  // stretch = 1,
	  shift = MouseY.kr(-100, 100),
	  sig_in2,
	  buf2 = ~buf5_rock_breakbeat,
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
	/*
    chain = PV_ConformalMap(
		chain,
		MouseX.kr(0.01,2.0, 'exponential'),
		MouseY.kr(0.01,10.0, 'exponential')
	);
    */
	// chain = PV_Diffuser(chain, MouseY.kr > 0.5); // Adds a different constant random phase shift to each bin. When triggered, it selects a new set of random phases.
	// chain = PV_MagFreeze(chain, MouseY.kr > 0.5);
	// chain = PV_MagSmear(chain, MouseX.kr(0, 100));
	// chain = PV_RectComb(chain, MouseX.kr(0, 32), MouseY.kr, 0.2);
	// chain= PV_Mul(chain2, chain); // full complex mult
	// chain = PV_MagMul(chain2, chain); // Multiplies magnitudes of two inputs and keeps the phases of the first input.
	// chain = PV_CopyPhase(chain, chain2); // Combines magnitudes of first input and phases of the second input.
    out_sig = IFFT(chain); // Обратный FFT
	// out_sig2 = IFFT(chain2); // Обратный FFT

	out_sig;
}.play;
)