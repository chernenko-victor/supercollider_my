(
// Загружаем семпл в специальную область памяти - буфер (Buffer). Это одномерный массив чисел, индексы начинаются с 0/
~buf1 = Buffer.read(s, "D:/audio/samples/04-mic2-231205_1439.wav"); // Путь к файлу надо заменить
~buf1.numChannels; //показывает кол-во каналов

~buf2_chnl1 = Buffer.readChannel(s, "D:/audio/music/chernenko/lyra8_230426_2.wav", channels: [0]);
~buf2_chnl1.numChannels;

~buf3_chnl1 = Buffer.readChannel(s, "D:/audio/samples/vocal/numbers.wav", channels: [0]);
~buf3_chnl1.numChannels;
)

~buf3_chnl1.play;


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