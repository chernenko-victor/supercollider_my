// global form generator
// form is abstraction for control of gerative parameters of piece

// ==== init once

~form_ctlr_bus = Bus.control(s, 1);

// ==== test

// regenerate piece "general form" (later simple "form")
(
~piece_form = Env.pairs({ { 1.0.rand } ! 2 } ! 6, \exp);
~piece_form.plot;
)


// follow form for mentally healthy musicians
//
(

// bus listener example
// ~listen_bus1 = {
// 	var in;
// 	in = In.kr(~form_ctlr, 1);
// 	Poll.kr(Impulse.kr(2), in, \form_cur_val);
// }.play(s);


// write to bus
//
// NB: this env player must be started after all listeners
// because synth exemplar added to top of stack
// see server.scd
~form_env_player = {
	arg timeScale = 30;
	var out;
	out = EnvGen.kr(~piece_form, 1, levelScale: 1, timeScale: timeScale, doneAction: 2);
	//.poll;
	Out.kr(~form_ctlr_bus, out);
}
//.play(s);
)

//~listen_bus1.release;


// get current value from client
(
~form_ctlr_bus.get({
	arg val;
	val.postln;
});
)

// what was in mind of SC creators? Why not to create normal programming language???? FOR MUSICIANS NOT BRAINFUCKERS
/*
(
SynthDef(\form_env_player_proto, {
	arg
	    form_ctlr_bus = 0
	, form_env = []
	    , levelScale = 10
	    , timeScale = 30
	;

	var out;

	out = EnvGen.kr(form_env, 1, levelScale: levelScale, timeScale: timeScale, doneAction: 2); // error thrown
	Out.kr(form_ctlr_bus, out);
}).add;


// whats tha fuck??? If youre nerds make strong typed lang
(
SynthDef(\help_Env_newClear, { |out = 0|
    var env, envctl;
    // make an empty 4 segment envelope
    env = Env.newClear(4);
    // create a control argument array
    envctl = \env.kr(env.asArray);
    Out.ar(out,
        SinOsc.ar(EnvGen.kr(envctl, \gate.tr), 0, 0.3) // the gate control is a trigger
    );
}).add;
)

)
*/