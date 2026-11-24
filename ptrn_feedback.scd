(
Pbindef(
	\feedback_seq,
	\dur, Pseq((1..4) * 0.5, inf),
);
)

(
Pbindef(\feedback_seq, \freq, 220);
)

(
Pbindef(
	\feedback_seq,
	Pkey
	\feedback_func, Pfunc({
		var freq = ((4.rand) + 1 *110);
		Pbindef(\feedback_seq, \freq, freq);
		freq.postln;
	}),
);
)

(
Pbindef(
	\feedback_seq).stop;
)

Pbindef(\my_synth,
    \instrument, \default,
    \freq, Pseq([220, 440, 660, 880], inf),

    // Аргумент ev содержит все данные текущего шага
    \amp, Pfunc({ |ev|
        var currentFreq = ev[\freq]; // Получаем значение \freq

        if(currentFreq > 500) {
            0.05 // Для высоких частот делаем тише
        } {
            0.2  // Для низких — громче
        };
    })
).play;
