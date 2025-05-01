(
~one_harm = {
	SinOsc.ar();
};
)

~one_harm1 = ~one_harm.play;

~one_harm1.run(false);
~one_harm1.run();

~one_harm1.free;


~discrete_arr  = [0.5, 0.1, 0.1, 0.1, 0.2];
~discrete_arr2  = [100, 20, 10, 10, 30].normalizeSum;
(
[1, 2, 3, 4, 5].wchoose(~discrete_arr2);
)