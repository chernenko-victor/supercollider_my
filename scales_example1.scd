~symmetric_arr = [0, 2, 4];

(
~all_symmetric_in_scale_arr = Array.fill(8, {
	arg index;
	~symmetric_arr + index;
});
)

~all_symmetric_in_scale_ptrn = Pseq(~all_symmetric_in_scale_arr, inf);

(
~all_symmetric_in_scale_pbind = Pbind(
	\degree, ~all_symmetric_in_scale_ptrn,
	\dur, 2,
	\legato, 0.7,
	// \scale, Scale.major(\just)
	// \scale, Scale.major(\pythagorean)
	// \scale, Scale.minor
);
)

(
~all_symmetric_in_scale_pbind_player = ~all_symmetric_in_scale_pbind.play;
)

~all_symmetric_in_scale_pbind_player.stop;


60.midicps;

///////////////////////////////////
// 12 octave equal

(
~eq12_semitone = pow(2, 1/12); // pow(scale_repeat_ratio, num_of_steps)


~eq12_ratios_arr = (0..12).collect({
	arg item;
	//item.postln;
	pow(~eq12_semitone, item);
});
)

///////////////////////////////////
// 12 duodecimal equal

(
~eq12_duodec_semitone = pow(2 + (2/3), 1/12); // pow(scale_repeat_ratio, num_of_steps)


~eq12_duodec_ratios_arr = (0..12).collect({
	arg item;
	//item.postln;
	pow(~eq12_duodec_semitone, item);
});
)

(64.rand + 32).round(4)
[1, 2, 3, 4, 5].choose.round(3)
(12.rand).round(2)


(
Pdef(\test_pitch,
	Pbind(
		// \degree, Pser([[0,1,2], [0,1,2] + 2, [0,1,2] + 4], inf),
		\degree, Pser([0,1,2], inf),

		\scale, Scale.major,
		// \scale, Scale.minor,
		// scale, Scale.phrygian,

		//\freq, 261.62 * Pser(~eq12_duodec_ratios_arr, inf)// Prand(~eq12_duodec_ratios_arr, inf),
		// \midinote, Pser([60,61,63], inf),
		// \note, Pser([60,61,63]-60, inf),
		// all three above independent of Scale

		// all three affectrd by
		// \ctranspose,12,//transposeanoctaveabove(=12semitones)

		\strum, 0.25,
		\legato, 0.5
	)
).play
)

Pdef(\test_pitch).stop;

Scale.directory;

~phryg_scale = Scale.phrygian;

// Scale(
// 	[ 0, 1, 3, 5, 7, 8, 10 ], // degrees - array consists amount of semitones from key note for degree = index
//   // e.g. degree=2 => 3 semitones (minor tertia)
// 	12,
// 	Tuning(
// 		[ 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0 ],
// 		2.0,
// 		"ET12"
// 	), "Phrygian"
// )

~phryg_scale.degrees
~phryg_scale_buf = Buffer.loadCollection(s, ~phryg_scale.degrees);

~phryg_scale_buf.plot;

// ===============
~phryg_scale.performDegreeToKey(2, 24, 0); // вводим номер ступени, получаем кол-во полутонов amount of semitones by number of degree


~phryg_scale.performDegreeToKey(9, 12, 0);

~phryg_scale.performDegreeToKey(-2, 12, 0);

///////////////////////////////
// see SimpleNumber for DegreeToKey

~hijaz_scale = Scale.hijaz;

/*
\ zhi: Zhi
-> Scale([ 0, 2, 8, 10, 14, 17, 20 ], 24, Tuning([ 0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5 ], 2.0, "ET24"), "Hijaz")
*/

~hijaz_scale.degrees;

(
// l = [0, 1, 5, 9, 11]; // pentatonic scale
(1, 2..15).collect{|i|
    i.degreeToKey(~hijaz_scale.degrees, 24)
};
)

(
(0, -1..-15).collect{|i|
    i.degreeToKey(~hijaz_scale.degrees, 24)
};
)

(
Pdef(\hijaz_scale_pl,
	Pbind(
		\degree, Pfunc({
			((1, 2..15)-5).choose.degreeToKey(~hijaz_scale.degrees, 24);
		}),
		\scale, ~hijaz_scale,
		// \scale, Scale.minor,
	)
).play;
)
Pdef(\hijaz_scale_pl).stop;
////////////////////////////////


// no effect!!!
// (
// Pdef(\seven_tone_pl,
// 	Pbind(
// 		\note, PdegreeToKey(Pseq([1, 2, 3, 4, 5], inf), Scale.major, stepsPerOctave: 24),
// 		\instrument, \default,
// 		\dur, 0.5
// 	);
// ).stop;
// )


// nothing happends when stepsPerOctave changed
// ~deg2key_ptrn = PdegreeToKey(Pseq([1, 2, 3, 4, 5], 5), Scale.major, stepsPerOctave: 24);
~deg2key_ptrn = PdegreeToKey(Pseq([1, 2, 3, 4, 5], 5), #[0, 2, 3, 6, 7, 9], stepsPerOctave: 7);
~deg2key_ptrn_stream = ~deg2key_ptrn.asStream;
~deg2key_ptrn_stream.nextN(5);

~new_scale = Scale.new((0..7), 24);

(
Pdef(\new_scale_pl,
	Pbind(
		\degree, Pseq([1, 2, 3, 4, 5], inf),
		// \note, Pseq([1, 2, 3, 4, 5], inf),
		// \scale, Scale.major,
		\scale, ~new_scale,
	)
).stop;
)

//////////////////////////////////////////
Scale.directory;

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


Scale.ionian;
/*
-> Scale(
    [0, 2, 4, 5, 7, 9, 11],
    12,
    Tuning(
        [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0],
         2.0,
         "ET12"),
         "Ionian"
    )
*/

Scale.dorian;
/*
-> Scale(
    [0, 2, 3, 5, 7, 9, 10],
    12,
    Tuning(
        [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0],
        2.0,
        "ET12"
    ),
    "Dorian"
)
*/

ScaleAD
ScaleLP
ScaleStream

~ionian_just_modus = Scale.ionian(\just);
~ionian_just_modus.degrees; // same as ionian et12
~ionian_just_modus.semitones