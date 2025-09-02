(
~curr_freq = 220;

~change1_ptrn = Pbind(
	\freq, Pfunc({
		~curr_freq
	})
).play;
)

~curr_freq = 440;

~change1_ptrn.stop;

(
~change_val_lin_spec = {
	arg begin_val, end_val, dur;
	var clock, begin_time, end_time, curr_val;
	clock = TempoClock.new();
	begin_time = clock.seconds;
	end_time = dur + begin_time;
	curr_val = begin_val;
	clock.sched(0, {
		curr_val = ~get_line.value(begin_val, end_val, begin_time, end_time, clock.seconds);
		curr_val.postln;
		~curr_freq = curr_val;
		if(clock.seconds < end_time) {0.25} {clock.stop; \done.postln};
	});
};
)

~change_val_lin_spec.(220, 440, 10);