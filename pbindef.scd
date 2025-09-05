(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.01, sustain), 1, doneAction: Done.freeSelf);
    5.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1,1.2) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));
}).add;
)

Pbindef(\a, \instrument, \Pdefhelp).play;
Pbindef(\a, \degree, Pseq([0, 2, 5b, 1b], inf));
Pbindef(\a, \dur, 0.1);
Pbindef(\a, \degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
Pbindef(\a, \legato, Prand([1.0, 2.4, 0.2], inf), \mtranspose, -3);
Pbindef(\a, \mtranspose, nil); // remove key