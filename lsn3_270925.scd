// add synths
(
SynthDef(\oneclap_thor, {arg out=0, t_trig=1, amp=0.1, filterfreq=100, rq=0.1, pan=0;
var env, signal, attack,К noise, hpf1, hpf2;
	noise = WhiteNoise.ar(1)+SinOsc.ar([filterfreq/2,filterfreq/2+4 ], pi*0.5, XLine.kr(1,0.01,4));
	//noise = PinkNoise.ar(1)+SinOsc.ar([(filterfreq)*XLine.kr(1,0.01,3), (filterfreq+4)*XLine.kr(1,0.01,3) ], pi*0.5, XLine.kr(1,0.01,4));
	//signal = signal * SinOsc.ar(1,0.75);
	hpf1 = RLPF.ar(noise, filterfreq, rq);
	hpf2 = RHPF.ar(noise, filterfreq/2, rq/4);
	env = EnvGen.kr(Env.perc(0.003, 0.00035));
	signal = (hpf1+hpf2) * env;
	signal = CombC.ar(signal, 0.5, 0.03, 0.031)+CombC.ar(signal, 0.5, 0.03016, 0.06);
	//signal = Decay2.ar(signal, 0.5);
	signal = FreeVerb.ar(signal, 0.23, 0.15, 0.2);
	Out.ar(out, Pan2.ar(signal * amp, pan));
	DetectSilence.ar(signal, doneAction:2);
},
metadata: (
	credit: "published on the sc-users list 2009-01-08 by thor",
	tags: [\clap, \handclap]
	)
).add;

SynthDef("kickBlocks", {
	arg
	//Standard Values
	out = 0, pan = 2, amp = 0.4, curve = -4,
	//tone1 arguments
	t1freq = 400, t1harmonic = 2, t1glide = 0.01,
	t1att = 0.0005, t1rel = 0.01, t1curve = -4, t1del = 0, t1amp = 1,
	//tone2 arguments
	t2freq = 50, t2harmonic = 3.44, t2glide = 0.01,
	t2att = 0.0001, t2rel = 0.3, t2curve = \lin, t2del = 0.005, t2amp = 1,
	//hit1 arguments
	h1freq = 100, h1harmonic = 8, h1glide = 0.01, h1rq = 0.6,
	h1att = 0.001, h1rel = 0.02, h1curve = -4, h1del = 0.001, h1amp = 1,
	//hit2 arguments
	h2freq = 1320, h2harmonic = 1, h2glide = 0,
	h2att = 0.003, h2rel = 0.03, h2curve = -4, h2del = 0, h2amp = 0.5,
	//click arguments
	cfreq = 6100, crq = 1, camp = 1.41;

    var snd, noise, tone1, tone2, hit1, hit2, click;

	noise = Hasher.ar(Sweep.ar); //deterministic white noise

    tone1 = SinOsc.ar(
		freq: XLine.ar(start: t1freq * t1harmonic, end: t1freq, dur: t1glide),
		mul: Env.perc(attackTime: t1att, releaseTime: t1rel, level: t1amp, curve: t1curve).delay(t1del).ar);

	tone2 = SinOsc.ar(
		freq: XLine.ar(start: t2freq * t2harmonic, end: t2freq, dur: t2glide),
		mul: Env.perc(attackTime: t2att, releaseTime: t2rel, level: t2amp, curve: t2curve).delay(t2del).ar);

    hit1 = BPF.ar(
		in: noise,
		freq: XLine.ar(start: h1freq * h1harmonic, end: h1freq, dur: h1glide),
		rq: h1rq,
		mul: Env.perc(attackTime: h1att, releaseTime: h1rel, level: h1amp, curve: h1curve).delay(h1del).ar);

	hit2 = HPF.ar(
		in: noise,
		freq: XLine.ar(start: h2freq * h2harmonic, end: h2freq, dur: h2glide),
		mul: Env.perc(attackTime: h2att, releaseTime: h2rel, level: h2amp, curve: h2curve).delay(h2del).ar);

	click = BPF.ar(
		in: Impulse.ar(0) * SampleRate.ir / 48000,
		freq:  cfreq,
		rq: crq,
		mul: camp);

	snd = Mix.ar(tone1 + tone2 + hit1 + hit2 + click).tanh * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "originals by Nathan Ho aka snapizz",
	category: \drums,
	tags: [\bass]
	)
).add;
)

// perform piece
(
~metro_part1 = TempoClock.new(2); // metronome for "drum1_part" to 2 beat per second (PBS)
~metro_part2 = TempoClock.new(1); // metronome for "drum2_part" to 1 beat per second (PBS)
~metro_form = TempoClock.new(1); // metronome for musical form to 1 beat per second (PBS)
~metro_part1_change = TempoClock.new(1); // metronome for change tempo of "drum1_part"


// start part1 immediately
"Start A".postln;
~drum1_part = Pbind(
	// \instrument, \kickBlocks,
	\instrument, Pseq([\kickBlocks, \kickBlocks, \oneclap_thor, Rest(), \oneclap_thor], inf),
	\t1freq,     Pseq([400,    161,    800],    inf).trace, // print current "t1freq" value
	\t1harmonic, Pseq([2,      4.66,   1.88],   inf),
).play(~metro_part1);


~metro_form.sched(30, {
	"Start B".postln;
	// after 30 beats from begin
	~drum1_part.stop; // stop part1

	// start part2
	~drum2_part = Pbind(
		\instrument, \oneclap_thor,
	).play(~metro_part2);
});

~metro_form.sched(60, {
	"Start A2".postln;
	// after 60 beats from begin
	~drum2_part.stop; // stop part2

	// restrt part1
	~drum1_part = Pbind(
		// \instrument, \kickBlocks,
		\instrument, Pseq([\kickBlocks, \kickBlocks, \oneclap_thor, Rest(), \oneclap_thor], inf),
		\t1freq,     Prand([400,    161,    800],    inf), // randomize parameters for "kickBlocks" synth
		\t1harmonic, Prand([2,      4.66,   1.88],   inf),
	).play(~metro_part1);

	// start changing tempo of part1
	~metro_part1_change.sched(0, {
		~metro_part1.tempo = ~metro_part1.tempo * 1.017;
		// ~metro_part1.tempo = ~metro_part1.tempo * 1.05; // comment string above and uncomment this string to crash Collider ))
		["New part1 tempo = ", ~metro_part1.tempo].postln;
		0.5;
	});
});

// stop all
~metro_form.sched(90, {
	~metro_form.stop;
	~metro_part1_change.stop;
	~drum1_part.stop; // stop part1
	~metro_part1.stop;
	~metro_part2.stop;
	"End of piece".postln;
});
)

Для самостоятельной работы:

Разберите код, попробуйте поменять, посмотреть как влияют изменения на результат.

Сделать компонированную пьесу (т.е. для ее исполнения достаточно 1 раз запустить код) в collider. Форма A1-B-A2 (А2 - это вариация А1, напр., в другой тональности или темпе), длина не более 3 мин.

Напоминаю, что можно использовать:
Управление звуковысотностью, ритмом, темпом, тембром, громкостью с помощью паттернов
Pbind, Pseq, Prand, Ptuple и их комбинации
TempoClock для управление темпом, включения / выключения паттернов в определенное время, а также плавного изменения параметров.


// (
// ~test_tempo = 2;
// 60.do({
// 	~test_tempo = ~test_tempo * 1.017;
// });
// ~test_tempo.postln;
// )
//
// pow(1.05, 60)
//
// SynthDefPool.defnames;
// SCLOrkSynths.gui;
//
// C:\Users\Admin\AppData\Local\SuperCollider\downloaded-quarks\SynthDefPool
//
//
// s.plotTree;
//
// ~oneclap_thor = Synth(\oneclap_thor);