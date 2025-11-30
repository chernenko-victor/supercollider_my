MIDIClient.init;

m = MIDIOut(1);  // Linux users: MIDIOut(0, MIDIClient.destinations[0].uid)
m.noteOn(16, 60, 60);
m.noteOff(16, 60, 60);

(
~midi_pitch = rrand(60, 80);
~midi_pitch.postln;
m.noteOn(16, ~midi_pitch, rrand(50, 80));
)

m.noteOff(16, ~midi_pitch, 0);

// MIDIOut.control(chan, ctlNum: 7, val: 64)

m.allNotesOff(16);


/////
//

(
~midi_out_ptrn = Pdef(\midi_out_pl,
	Pbind()
);
)

~midi_out_ptrn_pl = (~midi_out_ptrn <> (type: \midi, midiout: m)).play;

// <> another form of Pchain

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

////////////////////////////////////
// The \midi event type supports the following commands, chosen in the event by the \midicmd key: \allNotesOff, \bend, \control, \noteOff, \noteOn, \polyTouch, \program, \smpte, \songPtr, \sysex, \touch. The default is \noteOn. When playing a note (noteOn), by default the corresponding noteOff message will be sent after the note's sustain time.
///////////////////////////////////

(
Pdef(\midi_out_pl,
	Pbind(
		// type: \composite,
		// types: [\note, \midi],

		\type, \midi,
		\midiout, m,
        \degree, Pseq([32, 64, 98], inf), //

		\midicmd, \control, // Specify the MIDI command type
    \ctlNum, 11, // Control number (e.g., volume)
		\control, Pseq([32, 64, 98], inf), // Control value
    \chan, 0, // MIDI channel

    \dur, 1 // Duration
	)
).stop;
)

(
Pdef(
	\midinote_seq,
	Pbind(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, m,
		\chan, 0,
		\degree, Pwhite(-7, 12, inf),
		\dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
		\legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
		\amp, Pexprand(0.5, 1.0, inf)
	)
).stop;
)


// \midicmd block notes

///////////////////////////////////
(
    // substitute your own device here
var    mOut = MIDIOut.newByName("FastLane USB", "Port A").latency_(Server.default.latency);

p = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,

	// because of \midicmd, \noteOn
	// we can use \midinote, \amp etc.
        // degree is converted to midinote, not just frequency
    \degree, Pwhite(-7, 12, inf),
    \dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.5, 1.0, inf)
).play(quant: 1);
)

p.stop;

//////////////////////////////
// https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.html#MIDI%20output

/*
one of the \midicmd value is \control
\control - Continuous controller message. Next keys:
    \chan - MIDI channel (0-15).
    \ctlNum -Controller number to receive the new value.
    \control - New value (0-127).
*/

//////////////////////////////
// composite
// perform any number of event types, given as ~types

MIDIClient.init;
m = MIDIOut(0);
​
// should play a synth *and* an external MIDI note simultaneously
(type: \composite, types: [\note, \midi], midiout: m, degree: 0, dur: 3).play;