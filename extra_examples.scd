s.boot;

~clck1 = TempoClock.new(60/60);


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
