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

~parts_list = List.new(6);
~parts_list = List[-1, -1, -1, -1, -1, -1];



~switch_parts = {
	arg level = 4, parts_list;
	var index = level;
	while {index <= parts_list.size} {
		if(
			parts_list[index] != -1,
			{
				parts_list[index] == -1
			}
		);
		index = index + 1;
	};
	index = 0;
	while {index < level} {
		if(
			parts_list[index] != 1,
			{
				parts_list[index] == 1
			}
		);
		index = index + 1;
	};
};

~find_in_list = {
	arg list, item;
	var res = -1;
	["list = ", list, "item = ", item].postln;
	list.do({
		arg curr_item, i;
		["i = ", i].postln;
		if(
			list[i] == item,
			{
				res = i;
			}
		);
	});
	res;
};

~change_dencity = {
	arg direction = 1, parts_status_list, parts_start_list, parts_stop_list;
	var part_index;
	// ["direction = ", direction, "parts_status_list = ", parts_status_list, "parts_start_list = ", parts_start_list, "parts_stop_list = ", parts_stop_list].postln;
	part_index = ~find_in_list.(parts_status_list, -1 * direction);
	if(
		part_index != -1,
		{
			parts_status_list[part_index] = direction;

			if(
				direction == 1,
				{
					(parts_start_list[part_index]).()
				},
				{
					(parts_stop_list[part_index]).()
				}
			);
		},
	);
};

)

(
~piece_len = 30;
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~listen_bus1_pl = ~listen_bus1.play;
~form_gen_pl = ~form_gen.play(args: [\part_len, ~piece_len]);
~piece_form_clock = TempoClock.new(1);
~piece_form_clock.sched(~piece_len-4, {
	~listen_bus1_pl.free;
	nil;
});
)


