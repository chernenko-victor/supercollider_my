FreqScope.new;

/*
Markov
*/
(
~markov_func = {
	arg last_index, markov_arr, index_arr;
	index_arr.wchoose(markov_arr[last_index]);
};

)

(
~midi_markov_arr = [60, 62, 65, 67, 70, 72];
~markov_index_arr = [0, 1, 2, 3, 4, 5];

~markov_chain_row1_arr = [80, 60, 100, 50, 40, 30].normalizeSum;
~markov_chain_row2_arr = [80, 40, 100, 30, 20, 30].normalizeSum;
~markov_chain_row3_arr = [60, 30, 80, 40, 30, 20].normalizeSum;
~markov_chain_row4_arr = [50, 20, 60, 40, 20, 20].normalizeSum;
~markov_chain_row5_arr = [30, 40, 40, 50, 10, 30].normalizeSum;
~markov_chain_row6_arr = [80, 30, 60, 20, 10, 20].normalizeSum;

~markov_chain_arr = [
	~markov_chain_row1_arr,
	~markov_chain_row2_arr,
	~markov_chain_row3_arr,
	~markov_chain_row4_arr,
	~markov_chain_row5_arr,
	~markov_chain_row6_arr,
];

~midi_last_index = 3;
)

/*
Substr
*/

(
~substr_noise = {
	arg frq_new = 440.0;
	Mix.fill(10, {
		arg index;
		var in, frq, bwr;
		in = WhiteNoise.ar(0.2);
		frq = frq_new * (2 * index + 1);
		// bwr = 0.01;
		bwr = LFNoise2.kr(0.3).exprange(0.008, 0.3);
		(Resonz.ar(in, frq, bwr)/(index + 1)).scope(1);
	}) / 10;

};
)

/*
Additive
*/

(
~additive_synth = {
	arg frq = 110;
	(Mix.fill(5, {
		arg index;
		SinOsc.ar(
			frq * (index + 1),
			0,
			1/(index + 1));
	}))/6;
};
)

//========================

/*
(
~midi_last_index = ~markov_func.value(~midi_last_index, ~markov_chain_arr, ~markov_index_arr);
// ~substr_noise1.set(\frq_new, 220.0.rand + 220.0);
~substr_noise1.set(\frq_new, ~midi_markov_arr[~midi_last_index].midicps);
)
*/

/*
Sequencer
*/

(
~substr_noise1 = ~substr_noise.play;
TempoClock.default.sched(1, {
	~midi_last_index = ~markov_func.value(~midi_last_index, ~markov_chain_arr, ~markov_index_arr);
	~substr_noise1.set(\frq_new, ~midi_markov_arr[~midi_last_index].midicps);
	rrand(1, 4).postln;
});
)




~substr_noise1.run(false);
~substr_noise1.run(true);


//========================================
(
~additive_synth1 = ~additive_synth.play;
~seq2 = TempoClock.new(1, 0, 0);

~seq2.sched(1, {
	~additive_synth1.set("frq", 220.rand + 110);
	rrand(1, 4).postln;
});
)

~seq2.tempo = 2;
~seq2.tempo = 1;


~seq2.stop;


~additive_synth1.run(false);
~additive_synth1.run();

