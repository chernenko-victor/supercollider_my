s.plotTree;

(
~form_ctlr = Bus.control(s, 1);

// listen bus
~listen_bus1 = {
	var in;
	in = In.kr(~form_ctlr, 1);
	Poll.kr(Impulse.kr(2), in, \form_cur_val);
};

// write to bus
~form_gen = {
	arg part_len = 30;
	var out;
	out = EnvGen.kr(~piece_form, 1, levelScale: 10, timeScale: part_len, doneAction: 2);
	//.poll;
	Out.kr(~form_ctlr, out);
};
)

(
~piece_len = 30;
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~listen_bus1_pl = ~listen_bus1.play;
~form_gen_pl = ~form_gen.play(args: [\part_len, ~piece_len]);
~piece_form_clock = TempoClock.new(1);
~piece_form_clock.sched(~piece_len, {
	~listen_bus1_pl.free;
	nil;
});
)


