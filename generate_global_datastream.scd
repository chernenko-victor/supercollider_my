{XLine.kr(1, 10, 1, doneAction: 2).poll}.play(s);
{XLine.kr(1, 10, 1, doneAction: 2)}.plot(1);


// (
// {
// 	var env_pairs
// 	Env.pairs().poll;
// }.play(s);
// )

// regenerate piece "general form" (later simple "form")
(
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~piece_form.plot;
~form_cur_val = 0;
)


(
{
	~form_cur_val = EnvGen.kr(~piece_form, 1, levelScale: 10, timeScale: 10, doneAction: 2)
	//.poll;
}.plot(5);
)

// fault (( maybe global env works only on clienr side
(
{
	~form_cur_val = EnvGen.kr(~piece_form, 1, levelScale: 10, timeScale: 10, doneAction: 2)
	//.poll;
}.play(s);
{
	Poll.kr(Impulse.kr(0.1), ~form_cur_val, \form_cur_val);
}.play(s);
)


// ================   control bus   ==================


// ==== init once
(
~piece_len = 2 * 15; // second
~part_len = 15;
~part_started = 0;
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

// ==== test

// regenerate piece "general form" (later simple "form")
(
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~piece_form.plot;
)

// (
// ~piece_form = Env.perc(1, 1, 1, 1);
// ~piece_form.plot;
// )

 (

 ~listen_bus1_pl = ~listen_bus1.play(s);
	~form_gen_pl = ~form_gen.play(s, args: [\part_len, ~part_len]);
 )
~listen_bus1_pl.free;


// follow form
// why this shit fails??????
//

(

~part_timer = TempoClock.new(1);
~current_time = thisThread.seconds;
~stop_time = ~current_time + ~piece_len;

[~current_time, ~stop_time].postln;
~part_timer.sched(0, {
	//arg ...args;
	//args.postln;
	//thisThread.seconds.postln;

	~current_time = thisThread.seconds;

	if(
		~part_started == 0,
		{
		    ~part_started = 1;
			"part_started".postln;
		},
		{
			~part_started = 0;
			~listen_bus1.free;
			~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
			"part_ended".postln;
		}
	);

	[~current_time, ~stop_time].postln;

	if(
		~current_time < ~stop_time,
		{
			"Start form gen".postln;
			~listen_bus1_pl = ~listen_bus1.play(s);
			~form_gen_pl = ~form_gen.play(s);
			~part_len;
		},
		{
			~part_started = 0;
			~listen_bus1_pl.free;
			"END OF PIECE".postln;
			nil;
		}
	)
});



)

~listen_bus1.release;

s.plotTree;