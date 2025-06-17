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
//

(
~master = Synth(\master_proto, [\in_bus, ~master_send]);
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


~sample_player_rate_var_start_pos = Synth(\sample_player_rate_var_start_pos_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \rate, -0.5, \start_pos_fract, 0.5]);
~sample_player_rate_var_start_pos.free;


~sample_player_retgig_rate = Synth(\sample_player_retgig_rate_proto, [\buf, ~pad_buf, \out_bus, ~master_send, \start_pos_fract, 0.5, \trig_rate, 1]);
~sample_player_retgig_rate.free;

////////////////////////////////////////////////
//
// finalize

(
    ~master.free;
)