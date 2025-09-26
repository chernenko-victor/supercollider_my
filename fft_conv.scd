///////////////////////////////////////////
//         Подготовка к работе
///////////////////////////////////////////

// Надо запустить код из fx.scd

// Включаем финальную обработку
(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

/////////////////////
//    samples
/////////////////////

// Надо запустить код из sampler.scd

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

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, 0.5]);
~sample_player_rate_var.free;

////////////////////////

(

~diffuser_send = Bus.audio(s, 2);

SynthDef(\fx_fft_diffuser_proto, {
	arg buf = 0, out_bus = 0, in_bus = 100, master_send_lvl_db = 0.0;
    var out, in, chain;

	in = In.ar(in_bus, 1);

    chain = FFT(LocalBuf(2048.dup(2), 1), in); // Прямое преобразование Фурье
	// chain = PV_BinShift(chain, stretch: stretch, shift: shift);
	chain = PV_Diffuser(chain, MouseY.kr > 0.5 );
    out = IFFT(chain); // Обратный FFT

	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;
)

////////////////////////////
(
~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [
	\buf, ~pad_buf,
	\out_bus, ~diffuser_send,
	\rate, 0.5
]);
)
~sample_player_rate_var.free;

(
~fx_fft_diffuser = Synth(\fx_fft_diffuser_proto, [
	\in_bus, ~diffuser_send,
	\out_bus, ~master_send]
);
)
~fx_fft_diffuser.free;

///////////////////////////


/*
Спектральные данные кодируются в комлексных числах. У них свои арифметические правила. Напр., умножение комплексных чисел не по

(RealA * RealB) - (ImagA * ImagB), (ImagA * RealB) + (RealA * ImagB)

Чтобы не кодировать вручную, есть объект PV_Mul
*/
(
~fft_modulation_send1 = Bus.audio(s, 2);
~fft_modulation_send2 = Bus.audio(s, 2);

SynthDef(\fx_fft_modulation_proto, {
	arg
	  out_bus = 0,
	  in_bus1 = 100,
	  in_bus2 = 101,
	  master_send_lvl_db = 0.0;
    var
	  out,
	  in1,
	  in2,
	  chain1,
	  chain2,
	  chain_out;

	in1 = In.ar(in_bus1, 1);
	in2 = In.ar(in_bus2, 1);

    chain1 = FFT(LocalBuf(2048.dup(2), 1), in1);
	chain2 = FFT(LocalBuf(2048.dup(2), 1), in2);
	chain_out = PV_Mul(chain1, chain2);

    out = IFFT(chain_out); // Обратный FFT
	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;
)

///////////////////////////////

(
~sample_player_rate_var1 = Synth(\sample_player_rate_var_proto, [
	\buf, ~pad_buf,
	\out_bus, ~fft_modulation_send1,
	\rate, 1.2
]);

~sample_player_rate_var2 = Synth(\sample_player_rate_var_proto, [
	\buf, ~buf4,
	\out_bus, ~fft_modulation_send2,
	\rate, 0.4
]);
)

(
~sample_player_rate_var1.free;
~sample_player_rate_var2.free;
)

(
~fx_fft_modulation_proto = Synth(\fx_fft_modulation_proto, [
	\in_bus1, ~fft_modulation_send1,
	\in_bus2, ~fft_modulation_send2,
	\out_bus, ~master_send]
);
)
~fx_fft_modulation_proto.free;


////////////////////////////////////////
// PV_CopyPhase: Берет магнитуды из первого сигнала, а фазы от второго
////////////////////////////////////////

(
~fft_copy_phase_send1 = Bus.audio(s, 2);
~fft_copy_phase_send2 = Bus.audio(s, 2);

SynthDef(\fx_fft_copy_phase_proto, {
	arg
	  out_bus = 0,
	  in_bus1 = 100,
	  in_bus2 = 101,
	  master_send_lvl_db = 0.0;
    var
	  out,
	  in1,
	  in2,
	  chain1,
	  chain2,
	  chain_out;

	in1 = In.ar(in_bus1, 1);
	in2 = In.ar(in_bus2, 1);

    chain1 = FFT(LocalBuf(2048.dup(2), 1), in1);
	chain2 = FFT(LocalBuf(2048.dup(2), 1), in2);
	chain_out = PV_CopyPhase(chain1, chain2);

    out = IFFT(chain_out); // Обратный FFT
	Out.ar(out_bus, dbamp(master_send_lvl_db) * out);
}).add;
)

///////////////////////////////

(
~sample_player_rate_var1 = Synth(\sample_player_rate_var_proto, [
	\buf, ~pad_buf,
	\out_bus, ~fft_copy_phase_send1,
	\rate, 1.2
]);

~sample_player_rate_var2 = Synth(\sample_player_rate_var_proto, [
	\buf, ~buf4,
	\out_bus, ~fft_copy_phase_send2,
	\rate, 0.4
]);
)

(
~sample_player_rate_var1.free;
~sample_player_rate_var2.free;
)

(
~fx_fft_copy_phase = Synth(\fx_fft_copy_phase_proto, [
	\in_bus1, ~fft_copy_phase_send1,
	\in_bus2, ~fft_copy_phase_send2,
	\out_bus, ~master_send]
);
)
~fx_fft_copy_phase.free;


////////////////////////////////////////
// PV_MagMul Multiplies magnitudes of two inputs and keeps the phases of the first input.
////////////////////////////////////////

//...

////////////////////////////////////////




/*
Объекты для преобразования спектра в Frequency Domain

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
Convolution
*/

