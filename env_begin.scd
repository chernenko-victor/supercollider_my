Env.perc(releaseTime: 0.1).plot;

(
{
	SinOsc.ar() * Env.perc(releaseTime: 1).kr();
}.plot(5);
)

(
{
	SinOsc.ar() * Env.perc(releaseTime: 1).kr(doneAction: 2); //freeSelf
}.asSynthDef(name: \sin_env).add;
)
// Synth(\sin_env);

(
Pbind(
	\instrument, \sin_env,
).play;
)
s.plotTree;



(
SynthDef(\env_help, { |out, gate = 1, amp = 0.1, release = 0.1|
    var env = Env.adsr(0.02, release, amp);
    var gen = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    Out.ar(out, PinkNoise.ar(1 ! 2) * gen)
}).add
);

// Env.new(levels: [0, 1, 0], times: [1, 1], curve: 'lin', releaseNode, loopNode, offset: 0)