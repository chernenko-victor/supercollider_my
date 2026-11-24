(
Ndef(\mod, {LFNoise1.kr(3).exprange(200, 700)})
)

(
Ndef(\carr, {
	arg freq = 440;
	SinOsc.ar(freq) * 0.2;
}).play;
)

(
Ndef(\carr).map(\freq, Ndef(\mod));
)

Ndef(\carr).stop;