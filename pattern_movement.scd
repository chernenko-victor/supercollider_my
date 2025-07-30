~ptrn1 = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1);

(
p = ~ptrn1.play;

)
p.stop;


//~get_line_stepbased.(~euro_diatonic_step1, 0, 3, 3);


// Cl.
(
var
    movement_form = 1
  , cl_min_pitch = 53
  , cl_max_pitch = 79
  , cl_keypitch = 65
  , random_type = 0
  , step = 1
  , direction = 1
  , count = 10
  //, dispersion = 0.25
;

//direction up

//base midi pitch
cl_keypitch = ~get_rand_val.(
				distr_type: 2
				, min_val: cl_min_pitch
				, max_val: cl_max_pitch/2
		).asInteger;

// generate sequence
~line1 = Array.fill(count, {
	arg i;
	~get_line_stepbased.(~euro_diatonic_step1, cl_keypitch, i, 0); // ionian scale
});

// if out of diapason, transpone 8va down
if(
	~line1[count-1] > cl_max_pitch,
	{
		~line1 = ~line1 - 12;
	}
);
)

~line1;

(
~ptrn_midi_pitch1 = Pseq(~line1, 1);
~ptrn2 = Pbind(
	\midinote, ~ptrn_midi_pitch1,
	\dur, 0.15,
	\legato, 1
);
)

(
p = ~ptrn2.play;

)
p.stop;


// ======================

(
var
    movement_form = 1
  , cl_min_pitch = 53
  , cl_max_pitch = 79
  , cl_keypitch = 65
  , random_type = 0
  , step = 1
  , direction = -1
  , count = 10
  , dispersion = 0.25
  , curr_index = 0
  , modus_type = 0 // ionian
  , part_ctrl
;

//base midi pitch
cl_keypitch = ~get_rand_val.(
				distr_type: 2
				, min_val: cl_min_pitch
				, max_val: cl_max_pitch
		).asInteger;


~ptrn_midi_pitch2 = Pfunc({
	var curr_pitch;
	curr_pitch = ~get_line_stepbased.(~euro_diatonic_step1, cl_keypitch, curr_index, modus_type);
	("curr_pitch = " + curr_pitch + "cl_keypitch = " + cl_keypitch).postln;
	if(
		(curr_pitch > cl_max_pitch) || (curr_pitch < cl_min_pitch),
		{
			direction = -1 * direction;
		}
	);
	curr_index = curr_index + direction;
	curr_pitch;
}, {});

~ptrn3 = Pbind(
	\midinote, ~ptrn_midi_pitch2,
	\dur, 0.5,
	\legato, 1
);

~cl_part_ctrl = TempoClock.new(1);
~cl_part_ctrl.sched(0, {
	switch(movement_form)
	  {1} {
		nil;
	  }
	  {2} {
		nil;
	  }
	  {3} {
		nil;
	  }
	;
	0.25;
});
)

(
p = ~ptrn3.play;

)

(
p.stop;
~cl_part_ctrl.stop;
)
