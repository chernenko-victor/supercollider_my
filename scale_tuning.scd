~major_scl = Scale.major;
~dorian_scl = Scale.dorian;
~major_pyth_scl = Scale.major(\pythagorean);

~major_scl.degrees;
~major_scl.semitones;
~major_scl.cents;
~major_scl.ratios.collect(_.round(0.001));

~dorian_scl.degrees;
~dorian_scl.semitones;
~dorian_scl.cents;
~dorian_scl.ratios.collect(_.round(0.001));

(
Pdef(\pl1,
	Pbind(
		// \degree, Pser((0..7), inf),
		\degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\just),
		\scale, Scale.major,
		\dur, 2,
	)
).play;
Pdef(\pl2,
	Pbind(
		// \degree, Pser([0, 2], inf),
		\degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		\scale, Scale.major.tuning_(\just),
		// \scale, Scale.major,
		\dur, 2,
	)
).play;
Pdef(\pl3,
	Pbind(
		// \degree, Pser([0, 2], inf),
		\degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		\scale, Scale.major.tuning_(\pythagorian),
		// \scale, Scale.major,
		\dur, 2,
	)
).play;
)

Pdefn(\pl1_degree, Pser([0, 2], inf));

Tuning.directory;
/*
\ catler: Jon Catler
\ chalmers: John Chalmers
\ et12: ET12
\ et19: ET19
\ et22: ET22
\ et24: ET24
\ et31: ET31
\ et41: ET41
\ et53: ET53
\ harmonic: Harmonic Series 24
\ harrison: Lou Harrison
\ johnston: Ben Johnston
\ just: 5-Limit Just Intonation
\ kirnberger: Kirnberger III
\ lu: Chinese Shi-er-lu scale
\ mean4: Meantone, 1/4 Syntonic Comma
\ mean5: Meantone, 1/5 Pythagorean Comma
\ mean6: Meantone, 1/6 Pythagorean Comma
\ michael_harrison: Michael Harrison 24 tone 7-limit
\ partch: Harry Partch
\ perret: Wilfrid Perret
\ pythagorean: Pythagorean
\ reinhard: Mayumi Reinhard
\ sept1: Septimal Tritone Just Intonation
\ sept2: 7-Limit Just Intonation
\ sruti: Sruti
\ vallotti: Vallotti
\ wcAlpha: Wendy Carlos Alpha
\ wcBeta: Wendy Carlos Beta
\ wcGamma: Wendy Carlos Gamma
\ wcHarm: Wendy Carlos Harmonic
\ wcSJ: Wendy Carlos Super Just
\ werckmeister: Werckmeister III
\ young: Young
*/

Tuning.et12.semitones;
Tuning.et12.ratios.collect(_.round(0.001));

Tuning.just.semitones;
Tuning.just.ratios.collect(_.round(0.001));

Tuning.catler.semitones;
Tuning.catler.ratios.collect(_.round(0.001));

Tuning.partch.semitones.collect(_.round(0.001));
Tuning.partch.size;
Tuning.partch.octaveRatio;

(
Pdef(\pl4,
	Pbind(
		\degree, Pser((0..7), inf),
		// \degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		\scale, Tuning.et12.semitones,
		\dur, 2,
	)
).play;
Pdef(\pl5,
	Pbind(
		// \degree, Pser((0, 2..14), inf),
		// \degree, Pser((0..7), inf),
		\degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		// \scale, Tuning.partch.semitones,
		\scale, ~duodec_et12_tun.semitones,
		\dur, 2,
	)
).play;
)

(1..11).collect(_*((2 + 3/2)**(1/12)));

(
~duodec_et12_tun = Tuning.new(
	(0..11).collect(_*((2 + 3/2)**(1/12))),
	(2 + 3/2),
	"duodec_et12"
);
)

a = Scale.choose(7, 12).tuning_(Tuning.choose(12));
a.tuning.name;

(
// or make up your own arbitrary scales and tunings
~duodec_et12_sc = Scale.new(
    #[0, 2, 4, 5, 7, 9, 10],
    12,
    ~duodec_et12_tun,
    "duodec_et12_scale"
);
)


(
Pdef(\pl6,
	Pbind(
		\degree, Pser((0..7), inf),
		// \degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		\scale, Tuning.et12.semitones,
		\dur, 2,
	)
).play;
Pdef(\pl7,
	Pbind(
		// \degree, Pser((0, 2..14), inf),
		// \degree, Pser((0..7), inf),
		\degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		// \scale, Tuning.partch.semitones,
		\scale, ~duodec_et12_sc,
		\dur, 2,
		\root, -3,
	)
).play;
)

// work with degree only
(
Pdef(\pl8,
	Pbind(
		\note, Pser((0, 2..14), inf),
		// \degree, Pser((0..7), inf),
		// \degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		// \scale, Tuning.partch.semitones,
		\scale, ~duodec_et12_sc,
		\dur, 2,
	)
).play;
Pdef(\pl9,
	Pbind(
		\note, Pser((0, 2..14), inf),
		// \degree, Pser([[0, 2, 4], [0, 2, 4] + 2, [0, 2, 4] - 2], inf),
		// \scale, Scale.major.tuning_(\pythagorian),
		\scale, Scale.major,
		\dur, 2,
	)
).play;
)
