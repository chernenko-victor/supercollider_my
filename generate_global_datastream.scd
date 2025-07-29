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

~form_ctlr = Bus.control(s, 1);

// ==== test

// regenerate piece "general form" (later simple "form")
(
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~piece_form.plot;
)

// follow form
(

// listen bus
~listen_bus1 = {
	var in;
	in = In.kr(~form_ctlr, 1);
	Poll.kr(Impulse.kr(2), in, \form_cur_val);
}.play(s);

// write to bus
{
	var out;
	out = EnvGen.kr(~piece_form, 1, levelScale: 10, timeScale: 30, doneAction: 2);
	//.poll;
	Out.kr(~form_ctlr, out);
}.play(s);

)

~listen_bus1.release;

