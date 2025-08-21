(
SynthDef(\cheappiano, { arg out=0, freq=440, amp=0.1, dur=1, pan=0;Ê
	var sig, in, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
	freq = freq.cpsmidi;
	hammer = Decay2.ar(Impulse.ar(0.001), 0.008, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
	sig = Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.04, 0, 0.03].at(i);
			delay = (1/(freq + detune).midicps);
			CombL.ar(hammer, delay, delay, 50 * amp)
		}) );

	sig = HPF.ar(sig,50) * EnvGen.ar(Env.perc(0.0001,dur, amp * 4, -1), doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
},
metadata: (
	credit: "based on something posted 2008-06-17 by jeff, based on an old example by james mcc",
	tags: [\casio, \piano, \pitched]
	)
).add;
)

~test_clk = TempoClock.new(1);
~test_clk.beats;

(
Pdef(\test_ptrn_pl,
	Pbind(
		\degree, Prand(
			// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
			//([0, 0, 0, 0] + {rrand(1, 7)}),
			//(1 .. 20).clump(4),
			(1 .. 20).clump(4).lace(20).clump(4),
			inf
		),
		\dur, Prand((1 .. 6) * 0.25, inf),
		\strum, Pwhite(0.05, 0.5, inf),
		\legato, Pexprand(0.1, 1, inf),
		\instrument, \cheappiano,
		\scale, Scale.choose,
		\amp, Pexprand(0.001, 0.3, inf),
	).trace
).play(~test_clk);
)

~test_clk.tempo = 0.3

(
Pdef(\test_ptrn_pl).stop;
~test_clk.stop;
)


Scale.directory

\ ahirbhairav: Ahirbhairav
\ ajam: Ajam
\ atharKurd: Athar Kurd
\ augmented: Augmented
\ augmented2: Augmented 2
\ bartok: Bartok
\ bastanikar: Bastanikar
\ bayati: Bayati
\ bhairav: Bhairav
\ chinese: Chinese
\ chromatic: Chromatic
\ chromatic24: Chromatic 24
\ diminished: Diminished
\ diminished2: Diminished 2
\ dorian: Dorian
\ egyptian: Egyptian
\ enigmatic: Enigmatic
\ farahfaza: Farahfaza
\ gong: Gong
\ harmonicMajor: Harmonic Major
\ harmonicMinor: Harmonic Minor
\ hexAeolian: Hex Aeolian
\ hexDorian: Hex Dorian
\ hexMajor6: Hex Major 6
\ hexMajor7: Hex Major 7
\ hexPhrygian: Hex Phrygian
\ hexSus: Hex Sus
\ hijaz: Hijaz
\ hijazDesc: Hijaz Descending
\ hijazKar: hijazKar
\ hindu: Hindu
\ hirajoshi: Hirajoshi
\ hungarianMinor: Hungarian Minor
\ husseini: Husseini
\ huzam: Huzam
\ indian: Indian
\ ionian: Ionian
\ iraq: Iraq
\ iwato: Iwato
\ jiao: Jiao
\ jiharkah: Jiharkah
\ karjighar: Karjighar
\ kijazKarKurd: Kijaz Kar Kurd
\ kumoi: Kumai
\ kurd: Kurd
\ leadingWhole: Leading Whole Tone
\ locrian: Locrian
\ locrianMajor: Locrian Major
\ lydian: Lydian
\ lydianMinor: Lydian Minor
\ mahur: Mahur
\ major: Major
\ majorPentatonic: Major Pentatonic
\ marva: Marva
\ melodicMajor: Melodic Major
\ melodicMinor: Melodic Minor
\ melodicMinorDesc: Melodic Minor Descending
\ minor: Natural Minor
\ minorPentatonic: Minor Pentatonic
\ mixolydian: Mixolydian
\ murassah: Murassah
\ mustar: Mustar
\ nahawand: Nahawand
\ nahawandDesc: Nahawand Descending
\ nairuz: Nairuz
\ nawaAthar: Nawa Athar
\ neapolitanMajor: Neapolitan Major
\ neapolitanMinor: Neapolitan Minor
\ nikriz: Nikriz
\ partch_o1: Partch Otonality 1
\ partch_o2: Partch Otonality 2
\ partch_o3: Partch Otonality 3
\ partch_o4: Partch Otonality 4
\ partch_o5: Partch Otonality 5
\ partch_o6: Partch Otonality 6
\ partch_u1: Partch Utonality 1
\ partch_u2: Partch Utonality 2
\ partch_u3: Partch Utonality 3
\ partch_u4: Partch Utonality 4
\ partch_u5: Partch Utonality 5
\ partch_u6: Partch Utonality 6
\ pelog: Pelog
\ phrygian: Phrygian
\ prometheus: Prometheus
\ purvi: Purvi
\ rast: Rast
\ rastDesc: Rast Descending
\ ritusen: Ritusen
\ romanianMinor: Romanian Minor
\ saba: Saba
\ scriabin: Scriabin
\ shang: Shang
\ shawqAfza: Shawq Afza
\ sikah: Sikah
\ sikahDesc: Sikah Descending
\ spanish: Spanish
\ superLocrian: Super Locrian
\ suznak: Suznak
\ todi: Todi
\ ushaqMashri: Ushaq Mashri
\ whole: Whole Tone
\ yakah: Yakah
\ yakahDesc: Yakah Descending
\ yu: Yu
\ zamzam: Zamzam
\ zanjaran: Zanjaran
\ zhi: Zhi

Scale.minor

Scale(degree: \ionian)

(
{
				[0, 1, 4].choose;
			}.value
)

(
Prand((1, 3 .. 16), 10).do({
	arg val;
	val.postln;
})
)

lace

x = [ [1, 2, 3], 6, List["foo", 'bar']];
y = x.lace(12);
x.postln;
y.postln;

-> [ [ 1, 2, 3 ], 6, List[ foo, bar ] ]
-> [ 1, 6, foo, 2, 6, bar, 3, 6, foo, 1, 6, bar ]

(1 .. 20).clump(4).lace(20).clump(4)


(
{
	"test fork".postln;
	3.wait;

	rrand(1, 11).postln;
	Pdef(\test_ptrn_pl,
		Pbind(
			\degree, Prand(
				// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
				//([0, 0, 0, 0] + {rrand(1, 7)}),
				(1 .. 20).clump(4),
				inf
			)
		).trace
	).play;
	10.wait;

	"end function fork".postln;
	Pdef(\test_ptrn_pl).stop;
}.fork;
)