(
~get_line = {
	arg begin_tempo, end_tempo, begin_time, end_time, curr_time;
	var a, b;
	a = (end_tempo - begin_tempo) / (end_time - begin_time);
	b = begin_tempo - (a * begin_time);
	(a * curr_time) + b;
};


~change_tempo = {
	arg clock, begin_tempo, end_tempo, dur;
	var begin_time, end_time, curr_tempo;
	begin_time = clock.seconds;
	end_time = dur + begin_time;
	clock.tempo_(begin_tempo);
	curr_tempo = begin_tempo;
	clock.sched(0, {
		curr_tempo = ~get_line.value(begin_tempo, end_tempo, begin_time, end_time, clock.seconds);
		// linlin
		curr_tempo.postln;
		clock.tempo_(curr_tempo);
		if(clock.seconds < end_time) {0.25} {\done.postln};
	});

};

~change_val_lin = {
	arg begin_val, end_val, dur;
	var clock, begin_time, end_time, curr_val;
	clock = TempoClock.new();
	begin_time = clock.seconds;
	end_time = dur + begin_time;
	curr_val = begin_val;
	clock.sched(0, {
		curr_val = ~get_line.value(begin_val, end_val, begin_time, end_time, clock.seconds);
		// linlin
		curr_val.postln;
		// 2DO: control bus there to translate this value
		if(clock.seconds < end_time) {0.25} {clock.stop; \done.postln};
	});
};

// linexp
)