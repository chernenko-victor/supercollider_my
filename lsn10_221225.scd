(
{
	var in_sig, amp;
	in_sig = 1;
	// in_sig = In.ar(0, 1);
	in_sig = LFPulse.ar(0.3);
	amp = Amplitude.ar(
		in_sig,
		attackTime: 0.1,
		releaseTime: 0.1
	).poll;

}.play;
)

(
{
	var in_sig, amp;
	in_sig = 1;
	// in_sig = In.ar(0, 1);
	in_sig = LFPulse.ar(0.3, 0.3);
	amp = Amplitude.ar(
		in_sig,
		attackTime: 0.1,
		releaseTime: 0.1
	).lag3(0.5);

}.plot(5);
)

(
{
	LFPulse.ar(0.3)
}.plot(5)
)

ToggleFF // Toggles between 0 and 1 upon receiving a trigger.
// A trigger happens when the signal changes from non-positive to positive.

// constatnt level signal
Use DC.ar for simplicity and clarity when you only need a constant DC signal.
Use SinOsc.ar(0, 0, 0, level) if you are already using SinOsc and want to add a DC offset to another signal, or if you are already generating a varying signal with SinOsc and want to modify its DC offset.



/////////
Fluid Corpus Manipulation Toolkit
https://s4ntp.org/NTMI/SCHelp/Classes/FluidAmpGate.html

FluidAmpGate

https://www.flucoma.org/download/

///////

standard if/else statements in the SynthDef function will be evaluated only once when the SynthDef is compiled, not during the playback of a Synth instance.

Signal-rate conditionals: This involves using UGens that act as switches or mixers based on control signals. Common examples include:
Select: Selects one UGen from an array based on an index.
Switch: Switches between two UGens based on a boolean-like control signal (0 or 1).
Mix: Mixes multiple signals, where the mixing amount can be controlled.
Mathematical operations: Using multiplication with 0 or 1 to effectively "turn off" or "turn on" a signal path.