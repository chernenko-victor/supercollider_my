~express_sound_test_proto = {Limiter.ar(WhiteNoise.ar(0.1), dbamp(-0.7))};
~express_sound_test = ~express_sound_test_proto.play;
~express_sound_test.free;


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