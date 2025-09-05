(
~curr_freq = 220;

~change1_ptrn = Pbind(
	\freq, Pfunc({
		~curr_freq
	})
).play;
)

~curr_freq = 440;

// start something from next bar

~clock1.schedAbs(~clock1.nextBar - 0.01, {
	~curr_freq = 330;
	nil;

});

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
		// linlin, see SimpleNumber
		curr_val.postln;
		~curr_freq = curr_val;
		if(clock.seconds < end_time) {0.25} {clock.stop; \done.postln};
	});
};
)

~change_val_lin_spec.(220, 440, 10);

// function in Pfunc receives event, but only keys above itself

(
~change2_ptrn = Pbind(
	\amp, 0.1,
	\freq, Pfunc({
		| ev |
		ev.postln;
		220;
	}),
	\dur, 0.9,
).play;
)

// generate parameter from others

(
~change2_ptrn = Pbind(
	\amp, Pexprand(0.03, 0.6, inf),
	\freq, Pfunc({
		| ev |
		ev.postln;
		ev[\amp].explin(0.03, 0.6, 800, 200);
	}),
	\dur, 0.9,
).play;
)

~change2_ptrn.stop;

// Pkey gives access to onle one key


// correlated values
(
~change_correlation_ptrn = Pbind(
	[\freq, \dur], Pfunc({
		[
			[220, 0.5], [330, 1], [440, 2], [550, 0.25]
		].choose;
	})
).play;
)

~change_correlation_ptrn.stop;