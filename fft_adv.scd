// start Подготовка к работе from lsn8_080125, load samples in buffers

// PV_CopyPhase

(
SynthDef(\copy_phase_fft_proto, {
	arg
	  out_bus = 0,
	  send_lvl = -3,
	  in_bus = 1000
	;
	var in, out, src, chain, chain_mod, chain_out;

	src = VarSaw.ar(
		LFNoise2.kr(0.5, add: 1.001).exprange(50, 200),
		width: SinOsc.kr(0.33).range(0.07, 0.94)
	);

	in = In.ar(in_bus, 2);

	chain = FFT(LocalBuf(2048.dup(2), 1), in);
	chain_mod = FFT(LocalBuf(2048.dup(2), 1), src);

	chain_out = PV_CopyPhase(chain, chain_mod);

	// out = in + (WhiteNoise.ar(0.2))!2;
	out = IFFT(chain_out);

	Out.ar(out_bus, dbamp(send_lvl) * out);
}).add;
)

~send1_bus = Bus.audio(s, 2);


(
~copy_phase_fft = Synth(\copy_phase_fft_proto, args: [
	\in_bus, ~send1_bus,
	\out_bus, ~master_send,
]);

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [
	// \buf, ~glitch_loops_buf,
	\buf, ~pf_buf,
	\out_bus, ~send1_bus,
	\rate, 0.5
]);
)

(
~sample_player_rate_var.free;
~copy_phase_fft.free;
)


////////////////////////////////
// PV_JensenAndersen

/// ... from lsn8_081125

////////////////////////////////
// PV_Diffuser
(
SynthDef(\diffuser_fft_proto, {
	arg
	  out_bus = 0,
	  send_lvl = -3,
	  in_bus = 1000
	;
	var in, out, src, chain, chain_out;

	in = In.ar(in_bus, 2);
	chain = FFT(LocalBuf(2048.dup(2), 1), in);
	chain_out = PV_Diffuser(chain, MouseY.kr > 0.5);
	out = IFFT(chain_out);

	Out.ar(out_bus, dbamp(send_lvl) * out);
}).add;
)



(
~diffuser_fft = Synth(\diffuser_fft_proto, args: [
	\in_bus, ~send1_bus,
	\out_bus, ~master_send,
]);

~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [
	// \buf, ~glitch_loops_buf,
	// \buf, ~bird_calls_buf,
	\buf, ~pf_buf,
	\out_bus, ~send1_bus,
	\rate, 0.5
]);
)

(
~sample_player_rate_var.free;
~diffuser_fft.free;
)