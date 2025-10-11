(
if(
	[false, true].choose,
	{"false".postln},
	{"true".postln}
);
)

(
{
	SinOsc.kr(0.5) > SinOsc.kr(0.5, phase: 0.33);
}.plot(5);
)

(
{
	// SinOsc.kr(0.5) > SinOsc.kr(0.5, phase: 0.33);
	Select.ar(SinOsc.kr(0.5) > SinOsc.kr(0.5, phase: 0.33), [
		SinOsc.ar() * 0.4,
		LFSaw.ar() * 0.2
	]);

}.play;
)

(
SynthDef("help-Select", { |out = 0|

    var a, cycle;
    a = [
            SinOsc.ar,
            Saw.ar,
            Pulse.ar
        ];
    cycle = a.size  * 0.5;
    Out.ar(out,
        Select.ar(LFSaw.kr(1.0, 0.0, cycle, cycle), a) * 0.2
    )
}).play;

)

(
{
    var a, cycle;
    a = [
            SinOsc.ar,
            Saw.ar,
            Pulse.ar
        ];
    cycle = a.size  * 0.5;

    Select.ar(LFSaw.kr(1.0, 0.0, cycle, cycle), a) * 0.2

}.plot(5);
)

(
{
	var rnd1, rnd2;
	rnd1 = LFNoise0.kr(1);
	rnd2 = LFNoise0.kr(1);
	[
		Select.kr(rnd1 > rnd2, [rnd1, rnd2]),
		Select.kr(rnd1 > rnd2, [rnd2, rnd1]),
		(rnd1 + rnd2) / 2,
	];
}.plot(30);
)

(
{
	var rnd1, rnd2;
	rnd1 = LFNoise2.kr(1);
	rnd2 = LFNoise2.kr(1);
	[
		Select.kr(rnd1 > rnd2, [rnd1, rnd2]),
		Select.kr(rnd1 > rnd2, [rnd2, rnd1]),
		(rnd1 + rnd2) / 2,
	];
}.plot(30);
)

SendTrig