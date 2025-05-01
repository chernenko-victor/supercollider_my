//pattern_music_event_start_point.sc
(
SynthDef(\smooth, {
	|out, freq = 440, sustain = 1, amp = 0.5|
	var sig, env, res;
	env = EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	sig = SinOsc.ar(freq, 0, amp);
	res = sig * env;
	Out.ar(out, sig ! 2)
}).add;
)

(
p = Pbind(
	// the name of the SynthDef to use for each note
	\instrument,
	\smooth,
	// MIDI note numbers -- converted automatically to Hz
	//\midinote, Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67],1),
	\midinote, Pxrand([
		Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67],1),
		Pseq([40, 52, 51, 47, 49, 51, 52, 40, 49, 47],1),
		Pseq([70, 82, 81, 77, 79, 81, 82, 70, 79, 77],1)
	], 4),
	// rhythmic values
	\dur, Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], inf)
).play;
)

~ptrnRnd  = Prand([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 10);
~streamPtrnRnd = ~ptrnRnd.asStream;
~streamPtrnRnd.all.plot;


Pfuncn
Pfunc

(
b = Buffer.alloc(s,2048,1);
c = Buffer.alloc(s,2048,1);
//d = Buffer.read(s,"sounds/oceanMONO.aif");
//d = Buffer.read(s,"G:\\src\\music\\sc\\lsn5\\ClassGuit.wav");
~buf1 = Buffer.read(s, "E:\\src\\sc\\hse\\2022_23\\lsn7\\K01Bass125A-04.wav"); //моно файл
d = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\beats.wav");
e = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\cl_solo_a1_mono.wav");
f = Buffer.read(s, "E:\\src\\music\\sc\\lsn5\\fox.wav");
)

// magfreeze - Freezes magnitudes at current levels when freeze > 0
(
~pvmagfreeze1 = SynthDef(\pvmagfreeze, {
	arg out, bufnum=0, soundBufnum1, amp = 0;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum1, BufRateScale.kr(soundBufnum1), loop: 0);
	//in = WhiteNoise.ar(0.2);
	chain = FFT(bufnum, in);
	chain = PV_MagFreeze(chain, MouseX.kr(-1, 1) ); // on the right side it freezes
	Out.ar(out, (0.5 * IFFT(chain))!2);
}).add;

~pvmagfreeze3 = SynthDef(\pvmagfreeze, {
	arg out, bufnum=0, soundBufnum1, amp = 0;
	var in, chain;
	in = PlayBuf.ar(1, soundBufnum1, BufRateScale.kr(soundBufnum1), loop: 1);
	//in = WhiteNoise.ar(0.2);
	chain = FFT(bufnum, in);
	//chain = PV_MagFreeze(chain, SinOsc.kr(0.5, 0, 2.0, -1.0) );
	chain = PV_MagFreeze(chain, LFNoise1.kr(freq: 2.0, mul: 2.0, add: -1.0));
	Out.ar(out, (0.5 * IFFT(chain))!2);
}).add;

)

{(2*Dust.kr(density: 0.0001)-1)}.scope();


~pvmagfreeze1 = Synth(\pvmagfreeze, [\bufnum,b.bufnum, \soundBufnum1, ~buf1.bufnum, \amp, 0.5]);

~pvmagfreeze1.set(\bufnum,b.bufnum, \soundBufnum1, ~buf1.bufnum);
~pvmagfreeze1.set(\bufnum,b.bufnum, \soundBufnum1, d.bufnum);
~pvmagfreeze1.run(false);
~pvmagfreeze1.run();


~pvmagfreeze3 = Synth(\pvmagfreeze, [\bufnum,b.bufnum, \soundBufnum1, ~buf1.bufnum, \amp, 0.5]);

~pvmagfreeze3.set(\bufnum,b.bufnum, \soundBufnum1, ~buf1.bufnum);
~pvmagfreeze3.set(\bufnum,b.bufnum, \soundBufnum1, d.bufnum);
~pvmagfreeze3.run(false);
~pvmagfreeze3.run();
~pvmagfreeze3.free;

(
~ptrnPvmagfreeze1 = Pbind(
	\instrument, \pvmagfreeze,
	\bufnum, Pn(b.bufnum, inf),
	\soundBufnum1, Pn(Prand([~buf1.bufnum, d.bufnum], 1), inf),
	\dur, Pseq([5, 5, 2, 0.5], 2)
);

~ptrnPvmagfreeze1.play;
)

(
SynthDef(\pvcopy, { arg out, bufnumA=0, bufnumB=1, soundBufnum=2;
	var inA, chainA, inB, chainB, chain;
	inA = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	inB =  SinOsc.ar(SinOsc.kr(SinOsc.kr(0.08, 0, 6, 6.2).squared, 0, 100, 800));
	chainA = FFT(bufnumA, inA);
	chainB = FFT(bufnumB, inB);
	chain = PV_CopyPhase(chainA, chainB);
	Out.ar(out,  0.5 * IFFT(chain).dup);
}).play(s,[\bufnumA, b.bufnum, \bufnumB, c.bufnum, \soundBufnum, d.bufnum]);
)

(
~bellFrqArr = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];
~bellAmpArr = [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];

SynthDef(\additive, {
	|out, freq = 400, amp = 0.5, gate=1, attc_time = 0.1, dec_time = 0.1, rel_time = 0.5|
    var n = 12;
    var frq_base = freq;
    var amp_base = amp;
	var sig, env, env_harm;
	env = EnvGen.kr(
		Env.adsr(attc_time, dec_time, 1.0, rel_time)
		, gate
		, doneAction:2
	);
	env_harm = EnvGen.kr(
		Env.new(
			levels: [0, 4, 1, 0]
			, times: [attc_time, dec_time, rel_time]
			, releaseNode: 2
		)
		, gate
		, doneAction:2
	);
    sig = {
        Mix.fill(n, { arg index;
            var freq_curr, frq_mod_frq, amp_mod_frq;
            index.postln;
            freq_curr = frq_base*(index+1);
            freq_curr.postln;
			frq_mod_frq = Rand(5.0, 15.5);
			amp_mod_frq = Rand(0.0, 0.5);
			SinOsc.ar(
				(freq_curr + SinOsc.kr(
					frq_mod_frq*env_harm,
					0,
					freq_curr*0.002*env_harm
				)),
				0,
				(amp_base + SinOsc.kr(
					amp_mod_frq*env_harm,
					0,
					0.2*env_harm
			    )) / ((index+1)**3))
        })
    };
	Out.ar(out, (sig*env/n) ! 2)
}).add;

SynthDef(\additive_sawtooth, {
	|out, freq = 400, amp = 0.5, gate=1, attc_time = 0.1, dec_time = 0.1, rel_time = 0.5|
    var n = 12;
    var frq_base = freq;
    var amp_base = amp;
	var sig, env, env_harm;
	env = EnvGen.kr(
		Env.adsr(attc_time, dec_time, 1.0, rel_time)
		, gate
		, doneAction:2
	);
	env_harm = EnvGen.kr(
		Env.new(
			levels: [0, 4, 1, 0]
			, times: [attc_time, dec_time, rel_time]
			, releaseNode: 2
		)
		, gate
		, doneAction:2
	);
    sig = {
        Mix.fill(n, { arg index;
            var freq_curr, frq_mod_frq, amp_mod_frq;
			//var amp_mult;
            index.postln;
            freq_curr = frq_base*(index+1);
            freq_curr.postln;
			frq_mod_frq = Rand(5.0, 15.5);
			amp_mod_frq = Rand(0.0, 0.5);
			SinOsc.ar(
				(freq_curr + SinOsc.kr(
					frq_mod_frq*env_harm,
					0,
					freq_curr*0.002*env_harm
				)),
				0,
				((-1)**index) * (amp_base + SinOsc.kr(
					amp_mod_frq*env_harm,
					0,
					0.2*env_harm
			    )) / ((index+1)**1))
        })
    };
	Out.ar(out, (sig*env/n) ! 2)
}).add;

//Cl. ))
SynthDef(\additive_square, {
	|out, freq = 400, amp = 0.5, gate=1, attc_time = 0.1, dec_time = 0.1, rel_time = 0.5|
    var n = 12;
    var frq_base = freq;
    var amp_base = amp;
	var sig, env, env_harm;
	env = EnvGen.kr(
		Env.adsr(attc_time, dec_time, 1.0, rel_time)
		, gate
		, doneAction:2
	);
	env_harm = EnvGen.kr(
		Env.new(
			levels: [0, 4, 1, 0]
			, times: [attc_time, dec_time, rel_time]
			, releaseNode: 2
		)
		, gate
		, doneAction:2
	);
    sig = {
        Mix.fill(n, { arg index;
            var freq_curr, frq_mod_frq, amp_mod_frq;
			//var amp_mult;
            index.postln;
            freq_curr = frq_base*(2*index+1);
            freq_curr.postln;
			frq_mod_frq = Rand(5.0, 15.5);
			amp_mod_frq = Rand(0.0, 0.5);
			SinOsc.ar(
				(freq_curr + SinOsc.kr(
					frq_mod_frq*env_harm,
					0,
					freq_curr*0.002*env_harm
				)),
				0,
				((-1)**index) * (amp_base + SinOsc.kr(
					amp_mod_frq*env_harm,
					0,
					0.2*env_harm
			    )) / ((index+1)**1))
        })
    };
	Out.ar(out, (sig*env/n) ! 2)
}).add;

//~bellFrqArr = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];
//~bellAmpArr = [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];
SynthDef(\additive_bell, {
	|out, freq = 400, amp = 0.5, gate=1, attc_time = 0.1, dec_time = 0.1, rel_time = 0.5|
    var n = 8;
    var frq_base = freq;
    var amp_base = amp;
	var sig, env, env_harm;
	env = EnvGen.kr(
		Env.adsr(attc_time, dec_time, 1.0, rel_time)
		, gate
		, doneAction:2
	);
	env_harm = EnvGen.kr(
		Env.new(
			levels: [0, 4, 1, 0]
			, times: [attc_time, dec_time, rel_time]
			, releaseNode: 2
		)
		, gate
		, doneAction:2
	);
    sig = {
        Mix.fill(n, { arg index;
            var freq_curr, frq_mod_frq, amp_mod_frq;
            index.postln;
			freq_curr = ~bellFrqArr[index] * frq_base;
            freq_curr.postln;
			frq_mod_frq = Rand(5.0, 15.5);
			amp_mod_frq = Rand(0.0, 0.5);
			SinOsc.ar(
				(freq_curr + SinOsc.kr(
					frq_mod_frq*env_harm,
					0,
					freq_curr*0.002*env_harm
				)),
				0,
				~bellAmpArr[index] * (amp_base + SinOsc.kr(
					amp_mod_frq*env_harm,
					0,
					0.2*env_harm
			    ))
			)
        })
    };
	Out.ar(out, (sig*env/n) ! 2)
}).add;
)


~additiveOne = Synth(\additive, [\freq, 220 + 330.rand, \amp, 0.6, \attc_time, 0.1 + 0.6.rand, \dec_time, 0.1 + 0.6.rand, \rel_time, 0.1 + 0.6.rand]);
~additiveTwo = Synth(\additive_bell, [\freq, 440, \amp, 0.5]);
//\additive_sawtooth
//\additive_square
//\additive_bell
~additiveThree = Synth(\additive, [\freq, 1400, \amp, 0.4]);


~additiveOne.set(\gate, 0);
~additiveTwo.set(\gate, 0);
~additiveThree.set(\gate, 0);

(
~additivePtrn = Pbind(
	\instrument, \additive,
	\freq, Pwhite(100, 1500, inf),
	\amp, Pwhite(0.2, 0.9, inf),
	\dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4], 10),
	\legato, Prand([0.25, 0.5, 0.9], inf),
	\attc_time, Pwhite(0.01, 0.8, inf),
	\dec_time, Pwhite(0.05, 0.8, inf),
	\rel_time, Pwhite(0.05, 2.0, inf)
);

~additivePtrn.play;
)


(
~additivePtrn2 = Pbind(
	\instrument, \additive_sawtooth,
	\freq, Env([100, 120, 600, 130, 100], [1, 5, 2, 10]),
	\amp, Pwhite(0.2, 0.9, inf),
	\dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4], 20),
	\legato, Prand([0.25, 0.5, 0.9], inf),
	\attc_time, Pwhite(0.01, 0.8, inf),
	\dec_time, Pwhite(0.05, 0.8, inf),
	\rel_time, Pwhite(0.05, 2.0, inf)
);

~additivePtrn2.play;
)

(
~additivePtrn3 = Pbind(
	\instrument, \additive_square,
	\freq, Pgbrown(220, 1400),
	\amp, Pwhite(0.2, 0.9, inf),
	\dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4], 20),
	\legato, Prand([0.25, 0.5, 0.9], inf),
	\attc_time, Pwhite(0.01, 0.8, inf),
	\dec_time, Pwhite(0.05, 0.8, inf),
	\rel_time, Pwhite(0.05, 2.0, inf)
);

~additivePtrn3.play;
)

(
~additivePtrn4 = Pbind(
	\instrument, \additive_bell,
	\freq, Pbeta(220, 1400, 0.5, 0.5, 20),
	\amp, Pwhite(0.2, 0.9, inf),
	\dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4], 20),
	\legato, Prand([0.25, 0.5, 0.9], inf),
	\attc_time, Pwhite(0.01, 0.8, inf),
	\dec_time, Pwhite(0.05, 0.8, inf),
	\rel_time, Pwhite(0.05, 2.0, inf)
);

~additivePtrn4.play;
)

(
~additivePtrn5 = Pbind(
	\instrument, \additive_sawtooth,
	\freq, Ptuple([
        Pseries(990, -150, 9),
        Pseq([1400, 900, 700, 700, 700, 400, Rest(0), 200, 200], 1),
        Pseq([1880, 400, 400, 200, 200, 100, Rest(0), 100], 1)
	], 1),
	\amp, Pwhite(0.2, 0.9, inf),
	\dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4, Rest(1.5)], inf),
	\legato, Prand([0.25, 0.5, 0.9], inf),
	\attc_time, Pwhite(0.01, 0.8, inf),
	\dec_time, Pwhite(0.05, 0.8, inf),
	\rel_time, Pwhite(0.05, 2.0, inf)
);

~additivePtrn5.play;
//play(TempoClock(120/60)); // 120 beats over 60 seconds: 120 BPM
)

(
{
 "one thing".postln;
 2.wait;
 "another thing".postln;
 1.5.wait;
 "one last thing".postln;
}.fork;
)

(
    ~durArr = [0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4, Rest(0.25), Rest(1.5), Rest(2)];
    ~clock1 = TempoClock.new();
    {
	    ~additivePtrn = Pbind(
		    \instrument, \additive,
		    \freq, Pwhite(100, 1500, inf),
		    \amp, Pwhite(0.2, 0.9, inf),
		\dur, Prand(~durArr, 20),
		    \legato, Prand([0.25, 0.5, 0.9], inf),
		    \attc_time, Pwhite(0.01, 0.8, inf),
		    \dec_time, Pwhite(0.05, 0.8, inf),
  		    \rel_time, Pwhite(0.05, 2.0, inf)
	    );

	    ~additivePtrn.play(~clock1);

	    10.wait;

	    ~additivePtrn2 = Pbind(
		    \instrument, \additive_sawtooth,
		    \freq, Env([100, 120, 600, 130, 100], [1, 5, 2, 10]),
		    \amp, Pwhite(0.2, 0.9, inf),
		    \dur, Prand(~durArr, 20),
		    \legato, Prand([0.25, 0.5, 0.9], inf),
		    \attc_time, Pwhite(0.01, 0.8, inf),
		    \dec_time, Pwhite(0.05, 0.8, inf),
		    \rel_time, Pwhite(0.05, 2.0, inf)
	    );

	    ~additivePtrn2.play(~clock1);

	    15.wait;

	    ~additivePtrn3 = Pbind(
		    \instrument, \additive_square,
		    \freq, Pgbrown(220, 1400),
		    \amp, Pwhite(0.2, 0.9, inf),
		    \dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4], 20),
		    \legato, Prand([0.25, 0.5, 0.9], inf),
		    \attc_time, Pwhite(0.01, 0.8, inf),
		    \dec_time, Pwhite(0.05, 0.8, inf),
		    \rel_time, Pwhite(0.05, 2.0, inf)
	    );

	    ~additivePtrn3.play;

	    20.wait;

	    ~additivePtrn4 = Pbind(
		    \instrument, \additive_bell,
		    \freq, Pbeta(220, 1400, 0.5, 0.5, 20),
		    \amp, Pwhite(0.2, 0.9, inf),
		    \dur, Prand(~durArr, 20),
		    \legato, Prand([0.25, 0.5, 0.9], inf),
		    \attc_time, Pwhite(0.01, 0.8, inf),
		    \dec_time, Pwhite(0.05, 0.8, inf),
		    \rel_time, Pwhite(0.05, 2.0, inf)
	    );

	    ~additivePtrn4.play;

	    25.wait;

	    ~additivePtrn5 = Pbind(
		    \instrument, \additive_sawtooth,
		    \freq, Ptuple([
			    Pseries(990, -150, 9),
			    Pseq([1400, 900, 700, 700, 700, 400, Rest(0), 200, 200], 1),
			    Pseq([1880, 400, 400, 200, 200, 100, Rest(0), 100], 1)
		    ], 1),
		    \amp, Pwhite(0.2, 0.9, inf),
		    \dur, Prand([0.25, 0.5, 1.0, 1.5, 2, 2.5, 3, 4, Rest(1.5)], inf),
		    \legato, Prand([0.25, 0.5, 0.9], inf),
		    \attc_time, Pwhite(0.01, 0.8, inf),
		    \dec_time, Pwhite(0.05, 0.8, inf),
		    \rel_time, Pwhite(0.05, 2.0, inf)
	    );

	    ~additivePtrn5.play;
    }.fork(~clock1);
)

Ppar([~additivePtrn, ~additivePtrn5, ~additivePtrn3], 2).play;

//Pspawner

/*
// Try these lines one by one:
2 ~myPlayer = p.play;
3 ~myPlayer.stop;
4 ~myPlayer.resume;
5 ~myPlayer.stop.reset;
6 ~myPlayer.start;
7 ~myPlayer.stop;
*/

LFNoise1