s.boot;

~clck1 = TempoClock.new(60/60);

~clck1.beats;


================================================
    при изменении проекта синта звучашие экземпляры не меняются
================================================

(
{
	LFTri.ar(220) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \tri_synth__proto).add;
)


~tri_synth1 = Synth(\tri_synth__proto);


(
{
	LFTri.ar(440) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \tri_synth__proto).add;
)

~tri_synth2 = Synth(\tri_synth__proto);

~tri_synth1.free;
~tri_synth2.free;

================================================
    синхронизация с offbeat
================================================
(
Pbindef(\def_seq1,
	\dur, 1
).clock_(~clck1).quant_(1);
)

(
Pbindef(\kick808_float_quant_seq,
	\dur, 1,
	\instrument, "kick808",
	\amp, 0.5,
).clock_(~clck1).quant_(1.5); // задает сетку 1.5 * n, n = 1, 2, 3  ... Так что может и на третьей доле вступить и на 1.5 ))

)

Pbindef(\def_seq1).play;

Pbindef(\kick808_float_quant_seq).play;

Pbindef(\kick808_float_quant_seq).quant = 1.33; // обновится только после рестарта

Pbindef(\kick808_float_quant_seq).quant = Quant.new(quant: 1, phase: 0.5); // Тут он сначала ищет бит кратный значению quant, а потом от него откладывает еще полбита, так что всегда гарантированно запустится в offbeat

// чтобы сдеать phasing, надо 2 клока и одному из них менять темп

Pbindef(\def_seq1).stop;

Pbindef(\kick808_float_quant_seq).stop;
Pbindef(\kick808_float_quant_seq).clear;


================================================
    примеры разных паттернов
================================================
(
Pbindef(\kick808_my,
	// \instrument, "kick808",
	\instrument, "distortedGuitar",
	\freq, [135, 149],
	\dur, Pseq([
		3/4, 1/4,
		1/2, 1/2,
		Rest(1/2), 1/2,
		Rest(1/4), 3/4
	], inf),
	\amp, 0.2,
	/*
	\rel, 0.7,
	\dist, Pseries(0.1, 0.1, 16),
	*/
	\pickPos, Pwhite(0.2, 0.8),
	\muteSus, Pseq([
		    0.15, 0.15, 0.15, 0.15, 0.25, 0, 0.15, 0.15,
		    0.15, 0.3, 0, 0.15, 0.2, 0, 0.15, 0.15], inf),
).clock_(~clck1).quant_(1);
)


Pbindef(\kick808_my).play;
Pbindef(\kick808_my).clear;
Pbindef(\kick808_my).stop;


// ~clck1.tempo_(88/60);
~clck1.tempo_(120/60);



(
Pbindef(\kick808_2_my,
	\instrument, "kick808",
	\dur, Pseq([
		4,
		Rest(2), 2,
		4,
		Rest(2), 2,
	], inf) * 0.4,
	\amp, 0.8,
	\rel, 0.7,
	\dist, Pser((0.1, 0.2..1), inf),
).clock_(~clck1).quant_(1);
);

Pbindef(\kick808_2_my).play;
Pbindef(\kick808_2_my).clear;
Pbindef(\kick808_2_my).stop;



(
Pbindef( \snareOto309_my,
	// \instrument, "snareOto309",
	\instrument, "subBass2",
	\dur, Pseq([2/3, 1/3, 1/3, 1], inf),
	// \freq, 78,
	\amp, 0.5,
	\ctranspose, -20,
	\blend, Pwhite(0.25, 0.75, inf),
	\degree, Pseq([
				-2, -2, -2, -2, 5, -2, -2, -2, 2, 1,
				0, 0, 0, 0, 4, 0, 5, 0, 6, 0, 7, 7,
				-2, -2, -2, -2, 5, -2, -2, -2, 2, 1,
				0, 0, 0, 0, 4, 2, 5, 2, 0, -2], inf),
	/*
	\att, Pwhite(0.01, 0.1),
	\dec, Pwhite(0.01, 0.1),
	\rel, Pwhite(0.05, 0.25),
	\curve, Pwhite(-8, -2),
	\preamp, Pwhite(1.2, 2),
	\filterHarmonic, Pwhite(1.2, 5),
	\oscsHarmonic, Pwhite(1.5, 3),
	\blend, Pwhite(0.333, 0.667),
	\oscsAmp, Pwhite(0.1, 1),
	\noiseRatio, Pwhite(0.3, 0.7),
	\noiseAmp, Pwhite(0.1, 1),
	*/
).clock_(~clck1).quant_(1);
);

Pbindef(\snareOto309_my).play;
Pbindef(\snareOto309_my).clear;
Pbindef(\snareOto309_my).stop;
