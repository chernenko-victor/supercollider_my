// ==========================================
//             waveforms, visualization
// ==========================================

// lo-freq generators
// usefull for all frequencies
(
{
	LFTri.ar(440) * 0.2;
}.scope();
)

(
{
	LFTri.ar(4) * 0.2;
}.plot(5);
)

// LFTri
// LFSaw
// Impulse
// LFPulse
// VarSaw


// Band Limited Oscillators - for audible frequencies:
// SinOsc, FSinOsc, Blip, Saw, Pulse

(
{
	Saw.ar(440) * 0.2;
}.scope();
)

(
{
	Saw.ar(4) * 0.2;
}.plot(5);
)

// Aperiodic Sources
// LFNoise0, LFNoise1, LFNoise2 - for random envelopes
(
{
	LFNoise2.kr(4) * 0.2;
}.plot(5);
)

// WhiteNoise, PinkNoise, BrownNoise - noise generators with different spectra


// synths definition
(
{
	arg freq, amp;
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(0.7).range(0.99, 1.01)) +
	(SinOsc.ar(freq * 2 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 2) +
	(SinOsc.ar(freq * 3 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 3) +
	(SinOsc.ar(freq * 4 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 4);
	sig = amp * sig / 4;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_proto).add;

{
	arg freq, amp;
	var sig;
	sig = VarSaw.ar(
		freq,
		width: LFNoise2.kr(3.1).range(0.3, 0.68),
    );
	sig = amp * sig;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \var_saw_proto).add;
)

// Synth(\sin_sum_proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
// Synth(\var_saw_proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);

// ==========================================
//             types of musical texture
// ==========================================

// melody
(
Pbind(
	\instrument, \var_saw_proto,
	\degree, Prand((0..8), inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(((1..6) ++ [Rest(2), Rest(4)]) * 0.25, inf),
).play;
)

// accords
(
Pbind(
	\instrument, \sin_sum_proto,
	// \degree, Prand((0..8), inf).clump(3),
	\degree, Ptuple([
		Prand((-3..4), inf),
		Pseq([5, 7, 8], inf),
		Prand((8..12), inf),
	], inf),
	\amp, Pwhite(0.05, 0.5, inf),
	\dur, Prand(([2, 4, 6] ++ [Rest(2)]), inf),
).play;
)

// line movement
(
Pbind(
	\instrument, \var_saw_proto,
	\note, Pwalk((1..12), 1, 1, 7).trace, // chromatic movement, up direction
	// \note, Pwalk((1..12), 1, Pseq([-1, 1], inf), 7), // up-down direction
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Pseq([-1, 1], inf), 7).trace, // step variation
	// \note, Pwalk((1..12), Pseq([1, 2, 2], inf), Prand([-1, 1], inf), 7).trace, // random direction
	\amp, Pwalk((1..8) * 0.1, 1, Prand([-1, 1]), 3),
	\dur, 0.25,
).play;
)