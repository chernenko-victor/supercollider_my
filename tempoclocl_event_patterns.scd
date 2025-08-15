( 'degree': 0, 'dur': 0.5 ).play;

(
var
    part1_indx = 0
  , dur1_ptrn = Prand(#[1, 2, 4, 8] * 0.25, inf)
  , dur1_ptrn_stream
;

dur1_ptrn_stream = dur1_ptrn.asStream;

~part1_to_stop = 0;

~part1 = TempoClock.new(1);

~part1.sched(0, {
	arg ...args;
	var next_start = dur1_ptrn_stream.next;
	if(
		~part1_to_stop == 1,
		{
			next_start = nil;
		},
		{
			( 'degree': (part1_indx%12), 'dur': (next_start * 0.8) ).play;
		}
	);

	// args.postln;
	(part1_indx%12).postln;
	part1_indx = part1_indx + 1;
	next_start;
});
)

// ~part1.stop; // hangs up sounding synth
~part1_to_stop = 1; // kostyl'