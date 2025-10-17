SinOsc
Pulse
LFPulse
Saw
LFSaw

/////////////////
// Additive

{Mix.fill(10, {SinOsc.ar(rrand(200,2000), 0, 0.1)})}.freqscope;

{SinOsc.ar()}.play;

s.plotTree;

FreqScope.new;

/////////////////
setn
x.setn(\freq1, [440, 880, 441], \amp1, [0.3, 0.1, 0.3]);

/////////////////
[333, 444, 555, 666].rand;

(
SynthDef(\dynklanks, {arg freqs = #[200, 671, 1153, 1723];
    Out.ar(0,
        DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007]))
    )
}).add
)

a = Synth(\dynklanks)
a.set(\freqs, [333, 444, 555, 666])
a.set(\freqs, [333, 444, 555, 666].rand)
a.free;

/////////////////
//
// Controls Bring signals and floats into the ugenGraph function of a SynthDef.
// SynthDef creates these when compiling the ugenGraph function.
//
// what a difference with exaple above?
(
SynthDef("manySines", {arg out=0;
    var sines, control, numsines;
    numsines = 20;
    control = Control.names(\array).kr(Array.rand(numsines, 400.0, 1000.0));
    sines = Mix(SinOsc.ar(control, 0, numsines.reciprocal)) ;
    Out.ar(out, sines ! 2);
}).add;
)

b = Synth(\manySines);

// our control name is "array"
b.setn(\array, Array.rand(20, 200, 1600));
b.setn(\array, {rrand(200, 1600)}!20);
b.setn(\array, {rrand(200, 1600)}.dup(20));
// NOTE: All three lines above do exactly the same, just different syntax

b.free;

Klang
// Klang can not recieve updates to its frequencies nor can it be modulated. For that we use DynKlang


// WhiteNoise
{WhiteNoise.ar(0.4)}.plot(1)
{WhiteNoise.ar(0.4)}.play
{WhiteNoise.ar(0.4)}.scope
{WhiteNoise.ar(0.4)}.freqscope

// PinkNoise
{PinkNoise.ar(1)}.plot(1)
{PinkNoise.ar(1)}.play
{PinkNoise.ar(1)}.freqscope

// BrownNoise
{BrownNoise.ar(1)}.plot(1)
{BrownNoise.ar(1)}.play
{BrownNoise.ar(1)}.freqscope

///
{ Crackle.ar(XLine.kr(0.99, 2, 10), 0.4) }.freqscope.scope;

{ LFDNoise0.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;

{ LFClipNoise.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;

// Impulse
{ Impulse.ar(80, 0.7) }.play
{ Impulse.ar(4, 0.7) }.play

// Dust (random impulses)
{ Dust.ar(80) }.play
{ Dust.ar(4) }.play

/////////////////////////////
// filters
HPF
LPF
BPF
MidEQ
{MidEQ.ar(WhiteNoise.ar(0.024), MouseX.kr(40,20000,1), MouseY.kr(0.01,1), 24)!2 }.play;
{MidEQ.ar(WhiteNoise.ar(0.024), MouseX.kr(40,20000,1), MouseY.kr(0.01,1), 24)!2 }.freqscope.scope;
RLPF
Resonz
MoogFF

/////////////////
// substractive synthesis

// resonant filter
{ Resonz.ar(WhiteNoise.ar(0.5), MouseX.kr(40,20000,1), 0.1)!2 }.play

// a short impulse won't resonate
{ Resonz.ar(Dust.ar(0.5), 2000, 0.1) }.play

// for that we use Ringz
{ Ringz.ar(Dust.ar(2, 0.6), MouseX.kr(200,6000,1), 2) }.play

// toooo loud in high
// compression doesnt fix it
// filtering?
(
{
	var sig_out;
	sig_out = Mix.fill(10,  {
		Ringz.ar(
			Impulse.ar(
				LFNoise2.ar(rrand(0.1, 1)).range(0.5, 1),
				0,
				0.1
			),
			LFNoise2.ar(0.1).range(200,3000),
			LFNoise2.ar(2).range(0.04,6,1)
		)
	});
	sig_out = Compander.ar(sig_out, sig_out, 0.85, slopeBelow: 0.7, slopeAbove: 0.1) * 0.2;
	sig_out = Limiter.ar(sig_out, dbamp(-1));
}.play;
)


/////////////////

// Klank is a bank of resonators like Ringz, but the frequency is fixed. (there is DynKlank)

{ Klank.ar(`[[800, 1071, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

// whitenoise input
{ Klank.ar(`[[440, 980, 1220, 1560], nil, [2, 2, 2, 2]], WhiteNoise.ar(0.005)) }.play;

// AudioIn input
{ Klank.ar(`[[220, 440, 980, 1220], nil, [1, 1, 1, 1]], AudioIn.ar([1])*0.001) }.play;



{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;

{ DynKlank.ar(`[[200, 671, 1153, 1723]*XLine.ar(1, [1.2, 1.1, 1.3, 1.43], 5), nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;

