// ~express_sound_test_proto = {Limiter.ar(WhiteNoise.ar(0.1), dbamp(-0.7))};
// ~express_sound_test = ~express_sound_test_proto.play;
// ~express_sound_test.free;


(
~express_stereo_test_proto = {
	Pan2.ar(
		Limiter.ar(
			WhiteNoise.ar(0.1),
			dbamp(-0.7)
		),
		pos: SinOsc.kr(0.5)
	);
};
)
~express_stereo_test = ~express_stereo_test_proto.play;
~express_stereo_test.free;

// include server.scd for varios server info and actions
// if there is no sounds see synth stack (node tree) to ensure all exemplars of synths
// works and order is right:
// 1. signals goes from top to bottom,
// 2. exemplar of synth added to top of stack