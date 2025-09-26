{ FSinOsc.ar(440, 0, 0.3) }.scope(1, bounds:  Window.screenBounds)


(
{
	Saw.kr(10);
}.plot(2, name: "Saw", bounds: Window.screenBounds)
)


(
b = {LFPulse.ar(LFNoise0.kr(0.33).exprange(0.1, 10))}.asBuffer(10, fadeTime: 0.1);
)

b.plot(bounds: Window.screenBounds);

(
{
	var trig;
	trig = PlayBuf.ar(b.numChannels, b, 1, loop: 1);
}.scope(1);
)

// wave table too big (Osc)
// lol kek ))
(
{
	Osc.ar(b.bufnum, 440, 0, 0.2);
}.scope(1);
)

// 44100 sample    2048 sample
// 1 sec           x sec
//
// 2048/44100 = 0.046439909297052

