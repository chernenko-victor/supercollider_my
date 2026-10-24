===============================================

семплы (sampling)

===============================================

(
// Загружаем семпл в специальную область памяти - буфер (Buffer). Это одномерный массив чисел, индексы начинаются с 0/
~buf1 = Buffer.read(s, "D:/audio/samples/pf/04-mic2-231205_1439.wav"); // Путь к файлу надо заменить
~buf1.numChannels; //показывает кол-во каналов
// ~buf1.play;

~buf2_chnl1 = Buffer.readChannel(s, "D:/audio/music/chernenko/lyra8_230426_2.wav", channels: [0]);
~buf2_chnl1.numChannels;
// ~buf2_chnl1.play;

~buf3_chnl1 = Buffer.readChannel(s, "D:/audio/samples/vocal/numbers.wav", channels: [0]);
~buf3_chnl1.numChannels;
// ~buf3_chnl1.play;


~buf4_glitch_loops = Buffer.read(s, "C:/home/Admin/audio/44446__looplicator__glitch-loops-102025/830048__looplicator__128-bpm-industrial-glitch-loop-15441-wav.wav");
~buf4_glitch_loops.numChannels;

~buf5_rock_breakbeat = Buffer.read(s, "D:/audio/samples/perc/570888__kaypira_fp__drum-loop-120bpm-rock-breakbeat.wav");
)


~buf1.play;
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
(
SynthDef(\player__proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, rate = 1.0, loop = 0;
	var out;
	out = PlayBuf.ar(
		2,
		bufnum: buf,
		rate: rate * BufRateScale.kr(buf),
		/*
		trigger: 1.0,
		startPos: 0.0,
		*/
		loop: loop,
		doneAction: 2
	);
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * out
	);
}).add;
)


~player1 = Synth(\player__proto, [\buf, ~buf1, \out_bus, ~master_send, \rate, 0.5]);
~player1.set(\rate, -1);
~player1.free;


~player2 = Synth(\player__proto, [\buf, ~buf5_rock_breakbeat, \out_bus, ~master_send, \rate, -1, \loop, 1]);
~player2.set(\rate, -0.3);
~player2.free;


// BufRd - свободное управление скоростью и направлением воспроизведения
(
SynthDef(\player_var_speed_proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, begin = 0, end = 1;
	var out, trig_rnd, len;
	trig_rnd = Dust.kr(1);
	len = TRand.kr(0.1, 1.0, trig_rnd).poll;
	out = BufRd.ar(
		2,
		buf,
		LFNoise1.ar(1) * BufFrames.ir(buf) * len
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

~buf1.play;

~player_var_speed = Synth(\player_var_speed_proto, [\buf, ~buf1, \out_bus, ~master_send]);
~player_var_speed.free;
// , \begin, 0.3, \end, 0.7


~player_var_speed2 = Synth(\player_var_speed_proto, [\buf, ~buf5_rock_breakbeat, \out_bus, ~master_send]);
~player_var_speed2.free;
////////////////////////////////////////////////


// ~granulator1 = Synth(\granulator_rate_ctrl_rec_1fx_send__proto, [\buf, ~buf2_chnl1, \out_bus, ~master_send]);

(
{
	arg buf = 1000;
	var trig, rate;
	var raw = LFNoise2.kr(0.2).clip2(1);
    var dur = Select.kr(raw > 0, [
        raw.lincurve(-1, 0, 0.005, 0.05, 8),
        raw.lincurve(0, 1, 3, 4, -8)
    ]); // Контрастные длительности - или очень короткие, или длинные
	rate = 1/dur;
	// rate = ((LFNoise2.kr(0.3).exprange(0.01, 50))**(-1));

	trig = Impulse.kr(
		rate.poll
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

-------------------------------------------------
изменение звуковысоты без изменения скорости
PitchShift.ar(sig, pitchRatio: stretchFactor)


-------------------------------------------------
изменение скорости без изменения звуковысоты (time stretch)

(
SynthDef(\warp__proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, pointerSpeed = 0.5;
	var out;
    var pointer = LFSaw.ar(pointerSpeed / BufDur.ir(~buf1)).range(0, 1);
    out = Warp1.ar(1, ~buf1, pointer, freqScale: 1, windowSize: 0.1, overlaps: 8);
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * out
	);
}).add;
)

~warp1 = Synth(\warp__proto, args: [\buf, ~buf1, \out_bus, ~master_send, \pointerSpeed, 2]);
~warp1.free;


//////
Другой вариант
(
SynthDef(\time_stretch__proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, pointerSpeed = 0.5;
	var out;
	var stretchFactor = 1/pointerSpeed; // 2 = медленнее в 2 раза
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) / stretchFactor, loop: 1);
    out = PitchShift.ar(sig, pitchRatio: stretchFactor); // Возвращаем высоту
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * out
	);
}).add;
)

~time_stretch1 = Synth(\time_stretch__proto, args: [\buf, ~buf1, \out_bus, ~master_send, \pointerSpeed, 0.5]);
~time_stretch1.free;


//////
// WarpOverlap (из sc3-plugins, библиотека JoshUGens)
// дополнительно запись во временный буфер
(
// stretch = 30 означает очень сильное замедление
SynthDef(\warpstretch__proto, {
	arg buf = 0, out_bus = 0, master_send_lvl_db = 0.0, pointerSpeed = 0.5, buf4rec = 1000, buf4rec_lvl_db = 0.0;
	var out;
	var stretchFactor = 1/pointerSpeed; // 2 = медленнее в 2 раза
    out = WarpOverlap.ar(1, buf, overlaps: 8, stretch: stretchFactor, windowsize: 6) * 0.3;
	Out.ar(
		out_bus,
		dbamp(master_send_lvl_db) * out
	);
	RecordBuf.ar(out, buf4rec, loop: 1, doneAction: 0);
}).add;
)

~warpstretch1 = Synth(\warpstretch__proto, args: [\buf, ~buf1, \out_bus, ~master_send, \pointerSpeed, 0.25]);
~warpstretch1.free;

~warpstretch2 = Synth(\warpstretch__proto, args: [\buf, ~buf5_rock_breakbeat, \out_bus, ~master_send, \pointerSpeed, 2]);
~warpstretch2.free;


//////
// пишем параллельно в буфер и потом из него играем с помощью \player_var_speed_proto
~rec_buf1 = Buffer.alloc(s, s.sampleRate * 4, 1);

(
~warpstretch_rec2 = Synth(\warpstretch__proto, args: [
	\buf, ~buf5_rock_breakbeat,
	\out_bus, ~master_send,
	\pointerSpeed, 2,
	\master_send_lvl_db, -96,
	\buf4rec, ~rec_buf1
]);
)
~warpstretch_rec2.free;

(
~warpstretch_rec1 = Synth(\warpstretch__proto, args: [
	\buf, ~buf1,
	\out_bus, ~master_send,
	\pointerSpeed, 0.25,
	\master_send_lvl_db, -96,
	\buf4rec, ~rec_buf1
]);
)
~warpstretch_rec1.free;


(
~warpstretch_rec3 = Synth(\warpstretch__proto, args: [
	\buf, ~buf2_chnl1,
	\out_bus, ~master_send,
	\pointerSpeed, 0.25,
	\master_send_lvl_db, -3,
	\buf4rec, ~rec_buf1
]);
)
~warpstretch_rec3.free;

(
~warpstretch_rec4 = Synth(\warpstretch__proto, args: [
	\buf, ~buf4_glitch_loops,
	\out_bus, ~master_send,
	\pointerSpeed, 0.25,
	\master_send_lvl_db, -96,
	\buf4rec, ~rec_buf1
]);
)
~warpstretch_rec4.free;

~player_var_speed_recorder = Synth(\player_var_speed_proto, [\buf, ~rec_buf1, \out_bus, ~master_send]);
~player_var_speed_recorder.free;


/*
Спектральный подход: фазовый вокодер (PV_RecordBuf / PV_PlayBuf)
Это метод из мира анализа-синтеза. Он даёт более «гладкий», но иногда «металлический» или «размытый» звук, особенно на резких транзиентах. Идея в том, чтобы записать спектральные кадры звука в буфер, а затем проигрывать их с другой скоростью.

PV_RecordBuf: записывает FFT-цепочку в большой буфер в виде последовательности спектральных кадров.

PV_PlayBuf: проигрывает эти записанные кадры с произвольной скоростью, независимо от высоты тона.

Этот подход требует, чтобы весь звук был предварительно проанализирован и записан в буфер, поэтому он не подходит для реального времени «на лету» с живым входом (без дополнительной задержки).
*/

/*
Сторонние плагины: RubberBand и другие
Для максимального качества и гибкости стоит обратить внимание на плагины, использующие специализированные алгоритмы.

RubberBandStretcher / RubberBandPS (из библиотеки flexplugins): это обёртки над известной библиотекой RubberBand, которые обеспечивают очень качественный тайм-стретчинг и питч-шифтинг с сохранением формант.

PV_PlayBufStretch: ещё один плагин для фазового вокодера, специально заточенный под тайм-стретчинг с опциональными алгоритмами фазовой блокировки для лучшего качества.
*/


// ==========================================
//             types of musical texture
//             типы музыкальной фактуры
// ==========================================

// melody
(
Pbind(
	// \instrument, \var_saw_proto,
	\degree, Prand((0..8), inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(((1..6) ++ [Rest(2), Rest(4)]) * 0.25, inf),
).play;
)

// accords
(
Pbind(
	// \instrument, \sin_sum_proto,
	// \degree, Prand((0..8), inf).clump(3),
	\degree, Ptuple([
		Prand((-3..4), inf),
		Pseq([5, 7, 8], inf),
		Prand((8..12), inf),
	], inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(([2, 4, 6] ++ [Rest(2)]), inf),
).play;
)

// bass
(
Pbind(
	// \instrument, \var_saw_proto,
	\degree, Prand((0..8), inf) - 14,
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(((1..6) ++ [Rest(2), Rest(4)]) * 0.25, inf),
).play;
)

// line movement
(
Pbind(
	// \instrument, \var_saw_proto,
	// \note, Pwalk((1..12), 1, 1, 7).trace, // chromatic movement, up direction
	\note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7) + 14, // up-down direction
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace, // step variation
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace, // random direction
	\amp, Pwalk((1..8) * 0.1, 1, Prand([-1, 1]), 3),
	\dur, 0.25,
).play;
)



======================================================
                  вложенные паттерны III
=======================================================

(
SynthDef(\idmPerc, { |out = 0, amp = 0.1, pan = 0, freq = 800, sustain = 0.05, noiseMix = 0.5|
    var env, sig, noise;
    env = EnvGen.ar(Env.perc(0.001, sustain, curve: -8), doneAction: 2);

    // Смешиваем чистый тон и отфильтрованный белый шум
    noise = BPF.ar(WhiteNoise.ar, freq * 1.5, 0.3);
    sig = SinOsc.ar(freq) * (1 - noiseMix) + (noise * noiseMix);

    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

{
	arg freq = 440, amp = 0.4; // два входа
	var sig = SinOsc.ar(freq) * amp; // меняем амплитуду
	// добавляем гармоники
	sig = sig + (SinOsc.ar(2 *freq) * amp/2);
	sig = sig + (SinOsc.ar(3 *freq) * amp/3);
	sig = sig + (SinOsc.ar(4 *freq) * amp/4);
	sig.scope;
	Limiter.ar( // на всяк случай лимитируем выход по -0.4 dB
		sig, // входной сигнал
		level: dbamp(-0.4) // переводми децибелы в rms
	);
}.asSynthDef(fadeTime: 0.1, name: \sin_synth_proto).add;

SCLOrkSynths.gui; // загружаем библиотеку
)

(
~rand_seq = Pxrand(
	[
		Pbind(
			\instrument, \sin_synth_proto,
			\freq, Pser([1, 2, 3] * 110, inf).trace,
			\dur, Pser([1, 2, 3], 4)
		),
		Pbind(
			\instrument, \default,
			\freq, Pser([1, 2, 3] * 440, inf).trace,
			\dur, Pser([1, 2, 3] * 0.25, 4)
		),
		Pbind(
			\instrument, \idmPerc,
			\dur, Pseq([
				Prand([0.125, 0.25], 4), // Быстрые глитчи
				Pseq([0.125, 0.125], 1),
				Prand([0.5, 0.25], 2)    // Сбивки
			], 12),
			// Прыгающие частоты в верхнем регистре
			\freq, Pwhite(1000, 8000),
			// Случайное соотношение синуса и шума для каждого клика
			\noiseMix, Pwhite(0.2, 0.9),
			\sustain, Pwhite(0.01, 0.08),
			// Панорама: звуки прыгают из левого уха в правое
			\pan, Pwhite(-0.8, 0.8),
			\amp, Pexprand(0.03, 0.15)
		),
		Pbindef( \feedbackPad3,
			\instrument, "feedbackPad3",
			\dur, 2,
			\legato, 0.9,
			\sampleRate, Pwhite(20.0, 25.0),
			\midinote, Pseq([ // Welcome to the ocean!
				[43, 47], [41, 48], [43, 47], [41, 48],
				[43, 47], [41, 48], [41, 45], [39, 46],
			])
		),
	],
	10
).play;
)

~rand_seq.stop;

(
~seq_of_seq = Pser(
	[
		Pbindef(
			\seq1_in_prand,
			\instrument, \sin_synth_proto,
			\freq, Pser([1, 2, 3] * 110, inf).trace,
			\dur, Pser([1, 2, 3], 4)
		),
		Pbindef(
			\seq2_in_prand,
			\instrument, \default,
			\freq, Pser([1, 2, 3] * 440, inf).trace,
			\dur, Pser([1, 2, 3] * 0.25, 4)
		)
	],
	inf
).play;
)

(
Pbindef(
	\seq1_in_prand,
	\freq, Pser([3, 2, 1] * 110, inf).trace,
)
)

~seq_of_seq.stop;


=============================================
         lace, clump
=============================================

x = [ [1, 2, 3], 6, List["foo", 'bar']];
y = x.lace(12);
x.postln;
y.postln;

-> [ [ 1, 2, 3 ], 6, List[ foo, bar ] ]
-> [ 1, 6, foo, 2, 6, bar, 3, 6, foo, 1, 6, bar ]

(1 .. 20).clump(4).lace(20).clump(4)




//////////////////////////////
//
// legato, arpeggiato (strum)

~test_clk = TempoClock.new(1);
~test_clk.beats;

(
Pdef(\test_ptrn_pl,
	Pbind(
		\degree, Prand(
			// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
			//([0, 0, 0, 0] + {rrand(1, 7)}),
			//(1 .. 20).clump(4),
			(1 .. 20).clump(4).lace(20).clump(4),
			inf
		),
		\dur, Prand((1 .. 6) * 0.25, inf),
		\strum, Pwhite(0.05, 0.5, inf),
		\legato, Pexprand(0.1, 1, inf),
		\instrument, Pser([Pn(\default, 10), Pn(\feedbackPad3, 10), Pn(\idmPerc, 50)], inf),
		\scale, Scale.choose,
		\amp, Pexprand(0.001, 0.3, inf),
	).trace
).play(~test_clk);
)

~test_clk.tempo = 0.3

~test_clk.tempo = 10;

(
Pdef(\test_ptrn_pl).stop;
~test_clk.stop;
)


===================================================
          Отложенный старт/ стоп
===================================================


~form_clck = TempoClock.new(1);

// method "sched" of "TempoClock" object starts function after N seconds
// TempoClock -> sched(N, { function })
// If last string of function returns number M, function will be retarted after M seconds
(
~form_clck.sched(3, {
	"bang".postln;
});
)

(
~metro_part2 = TempoClock.new(2); // metronome for "drum2_part" to 2 beat per second (PBS)

~form_clck.sched(30, {
	"Start B".postln;
	// after 30 beats from begin

	// start part2
	~drum2_part = Pbind(
		\instrument, "kickRingz",
	).play(~metro_part2);
});

~form_clck.sched(90, {
	~metro_form.stop;
	~drum2_part.stop;
	"End of piece".postln;
});
)


Следующий пример проигрывает ноты ровно 4 бита, а затем останавливается, даже если последовательность нот могла бы продолжаться дальше.

~clck3 = TempoClock.new(120/60);

(
Pfindur(4,
  Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq(
		[
			1,
				Pxrand([Rest(1/4), 1/2, 2/3, Rest(2/3)], 2),
			1,
			Prand([1, Rest(1/2), 2, Rest(1/4)], 1)
		], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
  )
).play(~clck3);
)

~clck3.tempo = 2;




===================================================
            паттерны разной длины
            синхронизация каждый 4 бита
===================================== =============

(
Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq(
		[
				Pn(1, 3), Rest(1/4), 3/4, Pn(1, 3), Rest(1)
		], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).play(~clck3, quant: 1);

Pdef(
\ppolyrythm1,
Pn(
// Паттерн играет случайное количество нот длительностью 0.3 бита.
// 0.3 не делится ровно на 1 или 4.
  Psync(
    Pbind(
        \dur, 0.3,
        \note, Pseq([0, 2, 4, 7], 3) // Всего 12 нот по 0.3 = 3.6 бита
    ),
    quant: 1.0, // Округлить общую длительность до целого бита
    maxdur: 4.0 // Но не дольше 4 битов
  ),
  inf
)
).play(~clck3);
)

Pbindef(\seq3).stop;
Pdef(\ppolyrythm1).stop;


=======================================================
           LFO
=======================================================

(
{
	// arg freq =440, amp = 0.2;
	var
	  sig,
	  pulse_witdth,
	  amp_env,
	  duration = 0.5,
	  freq =440,
	  amp = 0.2
	;

	freq = LFNoise0.kr(1).range(1, 10).ceil / (LFNoise0.kr(0.72).range(2, 6).ceil) * 440;

	duration = LFNoise0.kr(0.25).range(1, 10).ceil * 0.25;

	pulse_witdth = LFNoise2.kr(0.3).range(0.2, 1.5);
	amp_env = SinOsc.kr(freq: duration);
	// amp_env = LFSaw.kr(freq: 0.1).poll;
	sig = LFPulse.ar(
		freq: freq,
		iphase: 0,
		width: (0.5 * pulse_witdth).poll
	) * amp_env * amp;

	sig = Limiter.ar(in: sig, level: dbamp(-0.4));
}.asSynthDef(fadeTime: 0.2, name: \self_trig__proto).add;
)

~self_trig1 = Synth(\self_trig__proto);
~self_trig1.release(0.3);

==============================================
             Огибающие в паттернах
==============================================
(
Pbind(
    \note, Env(
            levels: [0, 0.1, 0.2, 0.3] * 12,
            times: [0.1, 0.1, 0.1] * 20,
            curve: 8,
		    loopNode: 1
        ),
    \dur, 0.1
).play;
)
// не повторяется

(
Pbind(
    \note, Pseg(Pseq([1, 5], inf), Pseq([4, 1], inf), \linear),
    \dur, 0.1
).play;
)

// это не работает, поскольку Pseg связан с таймером, а plot работает в своем режиме
Pseg(Pseq([1, 5], inf), Pseq([4, 1], inf), \linear).asStream.nextN(10).plot("Pattern from random");


================================================
              Повторение
================================================

(
Pdef(
	\arithm,
	Pbind(
		\dur, Pclutch(
			Prand(((1..5)**2*0.1) ++ Rest(1), inf),
			0.7.coin.binaryValue
		).trace,
	),
).stop;
)


//////////////////////////////////
//
//      discrete random distribution


// we want 2nd and 5th number to have a higher probability
~midi_seq1_arr = [1, 2, 4, 5, 7, 9];
~midi_seq1_weigth_arr = [10, 20, 30, 10, 10, 30].normalizeSum;


{~midi_seq1_arr.choose}.dup(1000).histo.plot; // equal discrete  distr

{~midi_seq1_arr.wchoose(~midi_seq1_weigth_arr)}.dup(1000).histo.plot; // weighted discrete distr

~midi_seq1_arr.scramble; // change elements which will appear more frequently


//////////////////////////////////
//
//      markov chain
//
//      марковская цепь

// we want dictr that "remember" step before this
// it's "contitional random"
//
// случайный процесс с памятью

/*
markov table
марковская таблица

   A   B   C   D
A  10  20  30  10 // C appears after A more frequently then D
B  10  10  20  30 // после B чаще появляется D, чем A
C  30  10  10  20
D  20  30  10  10



Values [A, B, C, D] are in an array. We want Markov process say us index of next elemet by index of current element.

A, B, C, D - условные знаки. Они могут обозначать что угодно: ритмические деления, семплы, высоту звука.

Markov process (MP) find current value in the vertical list, then takes its index. Then MP brings correspondent string - it becomes array of weigth. With "windex" function MP finds index of next element, it's like "wchoose" but returns an index itself.


--------------------------
Цикл получения марковских величин:

Берем текущий элемент, напр A.

Находим соответсвующую строку, в данном случае 10  20  30  10

Это будут веса для дискретного распределения (надо поместить их в массив и применить метод .normalizeSum)

Теперь  мы можем применить к этому массиву wchoose и определить индекс следующего элемента

По индексу определяем сам это элемент, он становится текущим элементом.

Далее все повторяется
--------------------------


В начале использования алгоритма можно выбрать текущий элемент случаным способом
*/

(
~dur_arr = [1,   2,   4 ,  6] * 0.25; // our elements

~curr_index = 0; // default value

~markov_arr = [
	[10,  20,  30,  10].normalizeSum,
	[10,  10,  20,  30].normalizeSum,
	[30,  10,  10,  20].normalizeSum,
	[20,  30,  10,  10].normalizeSum
];
)

(
~curr_index = ~markov_arr[~curr_index].windex; // get next index and save it
~dur_arr[~curr_index]; // get next elenemt by this index
)


(
Pdef(
	\fb_sin__player,
	Pbind(
		// \instrument, \fb_sin__proto,
		// \freq, Pser([1, 2, 4, 1] * 440, inf),
		\degree, Pdefn(
			\degree_at_fb_sin__player,
			Pser([1, 2, 4, 1], inf)
		),
		\dur, Pfunc({
			~curr_index = ~markov_arr[~curr_index].windex;
			~dur_arr[~curr_index];
		}),
		\legato, 0.8,
	)
).play;
)



///////////////////////////////////////
//
//       feedback, chaos
//
////////////////////////////////////////

// but for using in patterns we must make it synth
(
{
	arg freq = 440; // inputs of synth
	// we can send values from Pbind by arg's name
	// for ex., \freq, 220,

	var feedback_mod = LFNoise2.kr(1) * 1.9;
	SinOscFB.ar(freq, 0.1 * 2 * 3.14 * feedback_mod ) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \fb_sin__proto).add;
)


/////////////////////////////////////////////
//
(
~power_map = {
	arg res, param;
	res = 1 - (param * res.pow(2));
}
)

Ключевой факт: орбита power map при c ∈ (1, 2] не равномерна. Для c = 2 инвариантная плотность строго арксинусная: ρ(x) = 1/(π√(1-x²)) — значения «залипают» у ±1. Для c = 1.4 плотность мультифрактальная, но тоже с концентрацией у границ аттрактора (примерно [-0.4, 1]

(
~mapRange = { |x, inLo, inHi, outLo, outHi|
    x.clip(inLo, inHi).linlin(inLo, inHi, outLo, outHi);
};
)

(
// var res = 0.5, param = 2.2; // chaotic // extra-wide diapason

var res = 0.5, param = 1.999;

// var res = 0.1, param = 1.88;
// param = 1.81 // 1.82 .. 86 - more random | 1.87 - more regular | 88 .. 99 - random
// >= 2 - goes infinity

// var res = 0.1, param = 1.75; // 1.77
// var res = 1.1003, param = 1.5001;

// var res = 0, param = 1.4;
// var res = 1/(1.4.pow(1/2)), param = 2.001 ;// 1.6;
// var res = 1.1003, param = 1.5001;
// var res = 0, param = 2;
~power_map_arr = Array.fill(50, {
	res = ~power_map.(res, param);
});
~power_map_arr.plot;
~power_map_arr.postln;
)



вообще никакой разницы нет с ~mapRange это подозрительно
(
// Гиперболический тангенс: мягко ограничивает в [-1,1]
~softClip = { |x, k = 2| (x * k).tanh };


// atan: ещё мягче, медленнее насыщается
~softClip2 = { |x, k = 2| (2 / pi) * (x * k).atan };

// Сигмоида: для маппинга в [0,1]
~sigmoid = { |x| 1 / (1 + exp(-1 * x)) };

~toFreq = { |x| x.linexp(0, 1, 100, 2000) };

~arcsine2uniform = { |x| (1/pi) * acos(x.clip(-1, 1)) };
)



(
~indx = 0;
Pbind(
	\dur, 1,
	\amp, 0.3,
	// \freq, Pser(~power_map_arr, inf).linlin(-1, 1, 110, 2000).trace, // works
	// \freq, ~mapRange.(Pser(~power_map_arr, inf), -1, 1, 110, 2000).trace, // fails
	\freq, Pfunc({
		// arg ...args;
		var res;
		// 10.rand.postln;
		// args.postln;
		res = ~power_map_arr.foldAt(~indx).postln;
		~indx = ~indx + 1;
		~mapRange.(res, -1, 1, 110, 2000);
	}),
).play;
)


~softClip.(0.5)

// значения начальных условий
// C:\home\Admin\src\csound\csound_learn\test_chaos.v2.3.orc


/*
opcode logistic, k, kk
    kRes, kParam xin
    kRes = kParam * kRes * (1 - kRes)
    xout kRes
endop

opcode hennon, kk, kkkk
    kX, kY, kFi, kDelta xin
    kXNext = kY + 1 - kFi * kX * kX
	kYNext = kDelta * kX
    xout kXNext, kYNext
endop

opcode ikeda, kk, kkkk
    kX, kY, kMu, kT xin
    kXNext = 1 + kMu * (kX * cos(kT) - kY * sin(kT))
    kYNext = kMu * (kX * sin(kT) + kY * cos(kT))
    xout kXNext, kYNext
endop

opcode Lorenz, kkk, kkkkkkk
    kx,ky,kz,kdt,ks,krwwww,kb xin

    kdx = ks*(ky-kx)
    kdy = kx*(krwwww-kz)-ky
    kdz = kx*ky-kb*kz

    kx += kdt*kdx
    ky += kdt*kdy
    kz += kdt*kdz

    xout kx,ky,kz
endop

*/

(
var a = 1.4, b = 0.3, x0 = 0, x1 = 1, size = 64;
plot(size.collect { var aux = 1 - (a * (x1 ** 2)) + (b * x0); x0 = x1; x1 = aux; aux });
)


(
// as a frequency control
{ SinOsc.ar(
	HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	)*800+900
)
* 0.04 ! 2 }.scope();
)

LatoocarfianL

(
{
HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	);
}.scope;
)

FBSineC

{ SinOsc.ar(Lag.ar(LorenzL.ar(MouseX.kr(1, 200)), 3e-3)*800+900)*0.4 }.play(s);

{ SinOsc.ar(StandardL.ar(40, MouseX.kr(0.9, 4))*800+900)*0.4 }.play(s);


Logistic



// ....




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


//////////////////////////
//
// Exchange data between synth by Bus.control


Changed

(
{
    var changingSignal = LFNoise0.ar(1000);
    var changed = Changed.ar(changingSignal);
    [changingSignal, changed]
}.plot
);




================================================
дополнения
================================================

(
{
	"test fork".postln;
	3.wait;

	rrand(1, 11).postln;
	Pdef(\test_ptrn_pl,
		Pbind(
			\degree, Prand(
				// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
				//([0, 0, 0, 0] + {rrand(1, 7)}),
				(1 .. 20).clump(4),
				inf
			)
		).trace
	).play;
	10.wait;

	"end function fork".postln;
	Pdef(\test_ptrn_pl).stop;
}.fork;
)

================================


нельзя использовать индекс, который больше или равен размера массива
чтобы не проверять, можно вместо [] использовать методы:
.clipAt(index)
.wrapAt(index)
.foldAt(index)


rotate(n: 1) // перестановка элементов в массиве

.reshape( ... shape) //

.windex //Interprets the array as a list of probabilities which should sum to 1.0 and returns a random index value based on those probabilities.



==============================================
итеграция в VS code
==============================================
/*
vscode-supercollider (originally developed by scztt and maintained via community contributors). It uses the Language Server Protocol (LSP) to communicate directly with SuperCollider (sclang).


FluCoMa Gerard Roma
*/
