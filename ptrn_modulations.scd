===================================================
      модификация последовательности (секвенции)
===================================================

Сделаем плавное изменение dur
(
Pbindef(
	\seq3,

		\freq, Pser([1, {rrand(2, 5)}, 4] * 220, inf),
		\dur, (
			Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)
		).trace,
).play;
)


Такой прием называется "модуляция"

Pser([1, 2, Rest(3), 4, Rest(2)], inf).asStream.nextN(10).plot("Rythm pattern", discrete: true);

Pser((0.1, 0.105..0.65)**4, inf).asStream.nextN(50).plot("Rythm pattern", discrete: true);

(
(Pser([1, 2, Rest(3), 4, Rest(2)], inf) *
			Pser((0.1, 0.105..0.65)**4, inf)).asStream.nextN(70).plot("Rythm pattern", discrete: true);
)


Последовательности с разным периодом

(Pser((1..5), inf)).asStream.nextN(25).plot;

(
Pser(
	[
		Pn(1, 5),
		2,
		3
	],
	inf
).asStream.nextN(25);
)

(
(
Pser((1..5), inf) *
Pser(
	[
		Pn(1, 5),
		2,
		3
	],
	inf
)
).linlin(1, 15, 1, 5).asStream.nextN(100).plot;
)

==========================================
Последовательности разной длины
==========================================
(
Pseries(0, 1, {rrand(3, 7)}).asStream.nextN(10)
)

(
Pn(
	Pseries(1, 1, {rrand(3, 7)}),
	inf
).asStream.nextN(50)
)

Используем для модуляции
(
(
Pser((1..5), inf) *
Pn(
	Pseries(1, 1, {rrand(3, 7)}),
	inf
)
).linlin(1, 15, 1, 5).asStream.nextN(50).plot;
)


=======================================
повторение значений
=======================================
(
Pdup(10, Pser([1, 3, 5], inf)).asStream.nextN(50).plot;
)


(
Pdup(
	Prand([1, 2, 5], inf),
	Pser([1, 3, 5], inf)
).asStream.nextN(50).plot;
)

(
Pclutch(
	Prand([1, 2], inf),
	Pseq([0, 1, 0, 0, 1, 1, 0, 1, 1, 1], inf)
).asStream.nextN(50).plot;
)

(
Pclutch(
	Prand([1, 2], inf),
	Pseq([
		Pn(0, {rrand(1, 5)}),
		Pn(1, {rrand(1, 5)}),
	], inf)
).asStream.nextN(50).plot;
)


=======================================
аккорды
=======================================

(
Pclump(
	3,
	Pser((1..5), inf)
).asStream.nextN(20)
)

(
((Pclump(
	Prand([1, 3, 7], inf),
	Pser((1..9), inf)
) * 2) + 48).asStream.nextN(20)
)

(
Pbindef(
	\deq123,
	\midinote,
	((Pclump(
		Prand([1, 3, 7], inf),
		Pser((1..9), inf)
	) * 2) + 48),
	\dur,
	(
		Pdup(
			Prand([1, 2, 5], inf),
			Pser([1, 3, 5, Rest(1)], inf)
		)
	) * 0.25
).play;
)


(
Pbindef(
	\seq5_acc,
		\freq, Ptuple([
			Pseq([60, 62, 64].midicps, inf),
			Pwhite(67, 72, inf).midicps,
			Pseq([Pseries(40, 2, 15)], inf).midicps,
		]).trace,
		\dur, 1,
).play;
)

=======================================
деление длительностей
=======================================
(
SynthDef(\help_sinegrain,
    { |out = 0, freq = 440, sustain = 0.05|
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)

(
a = Psubdivide(
    Pseq(#[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4], inf),
    Pseq(#[0.5, 1, 2, 0.25, 0.25], inf)
);
x = a.asStream;

Routine({
    loop({
        Synth.grain(\help_sinegrain, [\freq, 440]);
        x.next.wait;
    })
}).play(TempoClock.default);
)