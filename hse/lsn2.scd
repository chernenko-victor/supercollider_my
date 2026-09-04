~cklk1 = TempoClock.new(1); // beats per seconds
~cklk1.beats;

~cklk1.tempo = 1;

(
Pdef(
	\seq1,
	Pbind(
		\freq, 220,
	)
).play(argClock: ~cklk1, quant: 1);
)


(
Pdef(
	\seq2,
	Pbind(
		\freq, 440,
	)
).play(argClock: ~cklk1, quant: 4);
)

Quant

// baseBarBeat

t = TempoClock.new;

t.beatsPerBar = 3;  // error! wrong thread

t.schedAbs(t.nextBar, { t.beatsPerBar_(3) });  // OK

/*
vscode-supercollider (originally developed by scztt and maintained via community contributors). It uses the Language Server Protocol (LSP) to communicate directly with SuperCollider (sclang).


FluCoMa Gerard Roma
*/