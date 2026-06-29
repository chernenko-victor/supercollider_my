(
SynthDef(\FMRhodes2, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1,
	//controls
	lfoSpeed = 2.4, inputLevel = 0.2, modIndex = 2, fmHarmonic = 30,
    // all of these range from 0 to 1
    mix = 0.2, lfoDepth = 0.75, lfoBottom = 0.15, lfoRange = 0.3;

    var env1, env2, env3, env4, range, bottom;
    var osc1, osc2, osc3, osc4, snd;

	bottom = lfoBottom.linlin(0, 1, 100, 12000);
	range = lfoRange.linlin(0, 1, bottom, 16000);

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * fmHarmonic) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;

    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = LPF.ar(snd, SinOsc.kr(lfoSpeed).range(bottom, range), lfoDepth) + (snd * (1 - lfoDepth));
    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;
)

// array of parts
(
~pbinds_arr = [0, 0, 0];

// Pbind, Prand, Pser can work one inside other
// Pattern inside must not have 'inf' time of repeat, or
// it will be repeat again and again
//
// \degree used with musical scales, for example
// in C maj (used by default) \degree, 0 plays C4
// \degree, 3 plays E4
// \degree, 1.1 plays C#4
// to transpose we can use + operator
// [4, 3.9, 4.1] + 3 tranposes by minor 3 up

~pbinds_arr[0] = Pbind(
		\instrument, \FMRhodes2,
		\degree, Pseq([
		    2,
		    Prand([4, 3.9, 4.1], 1),
		    6
	    ], 10),
		\amp, 0.4,
	    \dur, Pseq([1, 1, Rest(1), 2, 2, Rest(1),] * 0.5, inf)
	);
// Rest(n) for n-second silence

~pbinds_arr[1] = Pbind(
		\degree, Prand([
		    2,
		    Pseq([4, 3.9, 4.1], 5),
		    6
	    ], 10),
	    \ctranspose, 13,
		\amp, 0.4,
	);

~pbinds_arr[2] = Pbind(
	    \instrument, \FMRhodes2,
		\degree, Prand([
		    Pser([7, 8, 5.5, 1], 5),
		    2,
		    Pseq([4, 3.9, 4.1], 1),
		    6,
		    Pseq([4.1, 3.9, 4], 2),
	    ], 10),
	    \mtranspose, -5,
		\amp, 0.4,
	    \dur, Prand([1, 1, 4, Rest(2), 2, 2, 3] * 0.25, inf)
	);
)


// Try new combinations of Pbind, Prand, Pser


// test parts
~pbinds_arr[0].play;
~pbinds_arr[1].play;
~pbinds_arr[2].play;

(
~form_clck = TempoClock.new(1); // metro
~index = 0; // index of current part

// method "sched" of "TempoClock" object starts function after N seconds
// TempoClock -> sched(N, { function })
// If last string of function returns number M, function will be retarted after M seconds
~form_clck.sched(0, {
	// round robin parts start
	("play | ~index = "+~index).postln;
	~pbinds_arr[~index].play; // start part
	~index = ~index + 1;

	// test ~index goes out of array length
	if(
		~index > 2,
		{
			~index = 0;
		}
	);

	// or use
	// ~pbinds_arr.wrapAt(~index).play;

	// execute once at 15 second
	15;
});
)

~form_clck.stop;


///////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

// linear disributions
Plprand(0, 7, inf).asStream.nextN(1000).histo.plot;

Phprand(0, 7, inf).asStream.nextN(1000).histo.plot;

// gaussian (normal) distribution
Pgauss(4, 1, inf).asStream.nextN(1000).histo.plot;


Pexprand(0.01, 7.0, inf).asStream.nextN(1000).histo.plot;

Pgbrown(0.01, 7.0, 0.05, inf).asStream.nextN(1000).histo.plot(discrete: true); // make some plots to see different forms of the distribution

{1.0.linrand }.dup(10000).histo(1000).plot(discrete: true); // function repeats 10000 times, linear distribution

{1.0.bilinrand }.dup(10000).histo(1000).plot(discrete: true); // gaussian-like distribution

/////////////////////////
//
// random sequence without repeats
// Pshuf: Shuffles an array once and repeats that specific shuffled order.


// Try new combinations of Pbind, Pser, Prand, Pshuf and different random distributions
// Apply it to