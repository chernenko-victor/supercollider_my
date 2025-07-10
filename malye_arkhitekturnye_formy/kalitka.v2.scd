////////////////////////////////////////////////////////////////////////////////
//                                                                           ///
//                                 kalitka                                   ///
//                                                                           ///
//                                                                           ///
//                   from "malye_arkhitekturnye_formy" cycle                 ///
//                                                                           ///
//                        generative electronic music                        ///
//                                                                           ///
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////
//
// init once area
//
// include lib/common.scd
// and test audio
//
// include lib/fx.scd
// include lib/change_device.scd
//     and change out to ReaRoute
//
// include lib/additive
// include lib/fft_fx

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
)

// (
// ~master.set(
// 	\thresh, 0.5
// 	, \slopeBelow, 1
// 	, \slopeAbove, 1
// 	, \compressor_out_lvl_db, 0
// );
// )

(
~fft_rand_comb1_send = Bus.audio(s, 2);
~fft_rand_comb1 = Synth(\fft_rand_comb_proto, [
	  \master_send_lvl_db, 0
	, \in_bus, ~fft_rand_comb1_send
	, \out_bus, ~master_send
]);
)

(
// ~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
// ~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);

~pf1_buf = Buffer.read(s, "D:/audio/samples/04-mic2-231205_1439.wav");
~pf1_mono_buf = Buffer.readChannel(s, "D:/audio/samples/04-mic2-231205_1439.wav", channels: 0);

~pf2_buf = Buffer.read(s, "D:/audio/samples/pf_zoom_rrecorder1.wav");
~pf2_mono_buf = Buffer.readChannel(s, "D:/audio/samples/pf_zoom_rrecorder1.wav", channels: 0);

~morning_bang_on_a_cans1_buf = Buffer.read(s, "D:/audio/samples/STE-001.wav");
~morning_bang_on_a_cans1_mono_buf = Buffer.readChannel(s, "D:/audio/samples/STE-001.wav", channels: 0);

~v_teni_berez_instr_1_p1_buf = Buffer.read(s, "D:/audio/music/suno/v_teni_berez_instr_1_p1.wav");
~v_teni_berez_instr_1_p1_mono_buf = Buffer.readChannel(s, "D:/audio/music/suno/v_teni_berez_instr_1_p1.wav", channels: 0);

~v_teni_berez_instr_1_p2_buf = Buffer.read(s, "D:/audio/music/suno/v_teni_berez_instr_1_p2.wav");
~v_teni_berez_instr_1_p2_mono_buf = Buffer.readChannel(s, "D:/audio/music/suno/v_teni_berez_instr_1_p2.wav", channels: 0);

// 672652__cassondratarola__kicks
// 356723__mtg__clarinet-asharp3-bad-pitch-errors
// 661118__evapofficial__synth-bass-loop-27
// D:\audio\samples\90s-sample-cds\(SN-R8-01) Contemporary Percussion.zip
// D:\audio\samples\90s-sample-cds\(SN-R8-04) Electronic.zip

)

////////////////////////////////////////////////
//
// test
//

(
~ob1 = Synth(\add_synth_long_proto, [
	  \freq: 220.rand + 220
	, \out_bus, ~master_send
	, \attackTime, 0.07
	, \decayTime, 0.02
	, \releaseTime, 0.01
	, \amp: 0.5
	, \pos: 0.1
]);
)

~ob1.release;


// ~sample_player_rate_var = Synth(\sample_player_rate_var_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, 0.5]);
// ~sample_player_rate_var.free;


(
~master.set(
 	\thresh, 0.37
 	, \slopeBelow, 1
 	, \slopeAbove, 1/4
 	, \compressor_out_lvl_db, 1.5
);
)

(
~sample_player_rate_var_start_pos = Synth(\sample_player_rate_var_start_pos_proto, [
	  \buf, ~pf1_buf
	, \out_bus , ~master_send
	, \master_send_lvl_db, -12
	, \rate, -0.5
	, \start_pos_fract, 0.5
	, \send_fx1_bus, ~fft_rand_comb1_send
	, \send_fx1_lvl_db, 12
]);
)
// ~sample_player_rate_var_start_pos.free;
~sample_player_rate_var_start_pos.release;

(
~sample_player_rate_var_start_pos2 = Synth(\sample_player_rate_var_start_pos_proto, [
	  \buf, ~pf2_buf
	, \out_bus, ~master_send
	, \master_send_lvl_db, -6
	, \rate, -0.33
	, \start_pos_fract, 0.67
	, \send_fx1_bus, ~fft_rand_comb1_send
	, \send_fx1_lvl_db, 12
]);
)
~sample_player_rate_var_start_pos2.release;

(
~sample_player_rate_var_start_pos3 = Synth(\sample_player_rate_var_start_pos_proto, [
	  \buf, ~morning_bang_on_a_cans1_buf
	, \out_bus, ~master_send
	, \master_send_lvl_db, -12
	, \rate, -2.7
	, \start_pos_fract, 0.1
	, \send_fx1_bus, ~fft_rand_comb1_send
	, \send_fx1_lvl_db, 12
]);
)
~sample_player_rate_var_start_pos3.release;


(
~sample_player_rate_var_start_pos4 = Synth(\sample_player_rate_var_start_pos_proto, [
	  \buf, ~v_teni_berez_instr_1_p1_buf
	, \out_bus, ~master_send
	, \master_send_lvl_db, -48
	, \rate, -2.7
	, \start_pos_fract, 0
	, \send_fx1_bus, ~fft_rand_comb1_send
	, \send_fx1_lvl_db, 6
]);
)
~sample_player_rate_var_start_pos4.release;


(
~sample_player_rate_var_start_pos5 = Synth(\sample_player_rate_var_start_pos_proto, [
	  \buf, ~v_teni_berez_instr_1_p2_buf
	, \out_bus, ~master_send
	, \master_send_lvl_db, -20
	, \rate, 0.7
	, \start_pos_fract, 0
	, \send_fx1_bus, ~fft_rand_comb1_send
	, \send_fx1_lvl_db, 12
]);
)
~sample_player_rate_var_start_pos5.release;

/*
~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \start_pos_fract, 0.5, \trig_rate, 1]);
~sample_player_retgig_rate.free;
*/

{XLine.kr(1, 10, 1, doneAction: 2).poll}.play(s);
{XLine.kr(1, 10, 1, doneAction: 2)}.plot(1);


// (
// {
// 	var env_pairs
// 	Env.pairs().poll;
// }.play(s);
// )

(
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~piece_form.plot;
~form_cur_val = 0;
)


(
{
	~form_cur_val = EnvGen.kr(~piece_form, 1, levelScale: 10, timeScale: 10, doneAction: 2)
	//.poll;
}.play(s);
{
	Poll.kr(Impulse.kr(0.1), ~form_cur_val, \form_cur_val);
}.play(s);
)
////////////////////////////////////////////////
//
// finalize

(
    ~fft_rand_comb1.free;
    ~master.free;
)