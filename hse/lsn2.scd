///////////////////////////////////////
// livecoding style
//
// change freq and duration, evaluate region
// to stop change "play" to "stop" and evaluate region

(
Pdef(
	\seq1_lc,
	Pbind(
		\freq, 220,
		\dur, 0.25,
	)
).stop;
)


Как сделать аккорды?

(
Pdef(
	\seq2,
	Pbind(
		\freq, Ptuple([
			Pseq([60, 62, 64].midicps, inf),
			Pwhite(67, 72, inf).midicps,
			Pseries(40, 2, inf).midicps
		]),
		\dur, 1,
	)
).play;
)

s.plotTree

~midi_pitch1_arr = Array.newClear(10);
~midi_pitch1_arr;
~midi_pitch1_arr[0];
~midi_pitch1_arr[0] = 64;

// ~midi_pitch1_arr

1.class;
~midi_pitch2_arr = [];
~midi_pitch2_arr.class;
// ~x.isKindOf(Float);
/*
У многих базовых типов в SuperCollider есть встроенные быстрые методы для проверки:~x.isNumber — является ли числом.
*/


// List
~midi_pitch3_arr = List[1, 4, 6];
~midi_pitch3_arr.class;



///////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution





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