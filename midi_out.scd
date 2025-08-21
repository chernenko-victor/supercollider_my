MIDIClient.init;

m = MIDIOut(1);  // Linux users: MIDIOut(0, MIDIClient.destinations[0].uid)
m.noteOn(16, 60, 60);
m.noteOff(16, 60, 60);

(
~midi_pitch = rrand(60, 80);
m.noteOn(16, ~midi_pitch, rrand(50, 80));
)

m.noteOff(16, ~midi_pitch, 0);

m.allNotesOff(16);


/////
//

(
~midi_out_ptrn = Pdef(\midi_out_pl,
	Pbind()
);
)

~midi_out_ptrn_pl = (~midi_out_ptrn <> (type: \midi, midiout: m)).play;

// Pdef(\midi_out_pl).stop;
~midi_out_ptrn_pl.stop;

/////////////////////////////////////////////

~midi_out_ob_clk = TempoClock.new(1);
~midi_out_ob_clk.beats;

(
~midi_out_ob_ptrn = Pdef(\midi_out_ob_ptrn,
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
);
)

// ~midi_out_ob_ptrn_pl = ~midi_out_ob_ptrn.play(~midi_out_ob);
~midi_out_ob_ptrn_pl = (~midi_out_ob_ptrn <> (type: \midi, midiout: m)).play(~midi_out_ob_clk);

~midi_out_ob_clk.tempo = 0.3

~midi_out_ob_ptrn_pl.stop;