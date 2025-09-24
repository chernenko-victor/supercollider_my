// Pbind - секвенсер
// Для запуска кода внутри "()" поместите курсор в любое место внутри "()" и нажмите CMD + Enter (MAC) или Ctrl + Enter (WIN)
(
Pbind().play;
)

// Два разных секвенсера
(
~pl1 = Pbind().play;
)

(
~pl2 = Pbind(
	\degree, 3,
	\dur, 0.25
).play;
)

// Ctrl (Cmd) + . = остановить все звуки и процессы

~pl1.stop; // остановить только один секвенсер
~pl1.play; // стартовать только один секвенсер

~pl1.mute;
~pl1.unmute;

~pl1.resume; // перезапустить с момента остановки

~pl1.reset; // перезапустить с самого начала


// Секвенция звуковысотностей и длительностей
(
~pl3 = Pbind(
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play;
)

// Pseq([a, b, c, d, ...], number) - паттерн, который повторяет a, b, c, d, ... "number" раз, Pseq([a, b, c, d, ...], inf) - бесконечный цикл повторений

/*
Внутри "()" после Pbind должны быть пары
Pbind(key1, value1, key2, value2, ..., keyN, valueN)
"key" - название параметра, напр "\degree" - ступени музыкального звукоряда:
0 - C middle (до первой октавы), 1 - D, 2 - E, ...
*/

// Длительности задаются в битах. BPS (beats per second) по умочанию = 1
// Чтобы изменить BPS используется TempoClock

(
~clk4 = TempoClock.new(2); // ставим BPS => 2 beats per sec
~pl4 = Pbind(
	\amp, Pseq([0.05, 0.1, 0.2], inf),
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play(~clk4);
)

~clk4.tempo = 4; // можно менять BPS во время работы Pbind

// Другие тембры
// https://github.com/supercollider-quarks/SynthDefPool/tree/master/pool

// напр, копируем код из https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/acid_oto309.scd и добавляем ".add" после последней скобки "("

(
SynthDef(\cheappiano, { arg out=0, freq=440, amp=0.1, dur=1, pan=0;Ê
	var sig, in, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
	freq = freq.cpsmidi;
	hammer = Decay2.ar(Impulse.ar(0.001), 0.008, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
	sig = Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.04, 0, 0.03].at(i);
			delay = (1/(freq + detune).midicps);
			CombL.ar(hammer, delay, delay, 50 * amp)
		}) );

	sig = HPF.ar(sig,50) * EnvGen.ar(Env.perc(0.0001,dur, amp * 4, -1), doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
},
metadata: (
	credit: "based on something posted 2008-06-17 by jeff, based on an old example by james mcc",
	tags: [\casio, \piano, \pitched]
	)
).add;
)

// теперь можно использовать этот синт в Pbind

(
~clk5 = TempoClock.new(2);
~pl5 = Pbind(
	\instrument, \cheappiano,
	\amp, Pseq([0.05, 0.1, 0.2], inf),
	\degree, Pseq([0, 2, 3, 4], inf),
	\dur, Pseq([1, 2, 0.25, Rest(1), 0.5, Rest(2)], inf)
).play(~clk5);
)

~pl5.stop; // выключим секвенсер