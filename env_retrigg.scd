(
~test = {
	arg frq_b = 440.0, frq_e = 220.0;
	var env1, env_gen1;
	env1 = Env.new(levels: [frq_b, frq_b, frq_e], times: [0.01, 3]); // огибающая из отрезков, levels - массив значений, times - время между ними.
	// отрезок в начале - фикс, поскольку повторение возможно только с первой точки
	env_gen1 = EnvGen.kr(env1, \trig_frq.tr);
	// \trig_frq.tr это переменная trig_frq, с помощью метода .tr превращенная из числа в триггерный синал
	SinOsc.ar(env_gen1);
};
)

~test_new = ~test.play;
~test_new.set(\trig_frq, 1);
~test_new.set(\frq_b, 330.0, \frq_e, 550.0, \trig_frq, 1);
~test_new.free;