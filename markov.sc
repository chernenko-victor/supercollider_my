[14, 3.7, 5.6, 8, 11].normalizeSum;

[1, 2, 3, 4].wchoose([0.1, 0.2, 0.3, 0.4]);


(
~markov_func = {
	arg last_index, markov_arr;
	[0, 1, 2, 3].wchoose(markov_arr[last_index]);
};
)


(
~markov_arr = [
	[0.1, 0.2, 0.3, 0.4],
	[0.3, 0.2, 0.1, 0.4],
	[0.1, 0.4, 0.3, 0.2],
	[0.3, 0.4, 0.1, 0.2]
];

~last_index = 4.rand;

~midi_arr = [60, 62, 65, 67];
)

(
~markov_arr2 = [
	[0.3, 0.2, 0.1, 0.4],
	[0.1, 0.2, 0.3, 0.4],
	[0.3, 0.4, 0.1, 0.2],
	[0.1, 0.4, 0.3, 0.2]
];

~last_index2 = 4.rand;

~midi_arr2 = [60, 64, 67, 70];
)

(
SynthDef(\sin_osc, {
	arg out = 0, midi = 60;
	Out.ar(0,
		SinOsc.ar(midi.midicps, 0, 0.5, 0.0)!2;
	);
}).add;

)

~last_index.postln;

~last_index = ~markov_func.value(~last_index, ~markov_arr);


~last_index2.postln;

~last_index2 = ~markov_func.value(~last_index2, ~markov_arr2);

~sin_osc1 = Synth(\sin_osc, [\midi, ~midi_arr[~last_index]]);

(
~sin_osc1.set(\midi, ~midi_arr[~last_index]);
~last_index = ~markov_func.value(~last_index, ~markov_arr);
)


(
~sin_osc1.set(\midi, ~midi_arr2[~last_index2]);
~last_index2 = ~markov_func.value(~last_index2, ~markov_arr2);
)

~sin_osc1.free;
