~ptrn1 = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1);

(
p = ~ptrn1.play;

)
p.stop;

(
~noise_proto = {
	WhiteNoise.ar(0.1) * Env.perc().kr(doneAction: 2);
};
)

~noise = ~noise_proto.play;


// (
// {
// 	WhiteNoise.ar(0.1) * Env.perc().kr(doneAction: 2);
// }.add;
// )
// we can't add function as synthdef ((

// /////////////////////////////////////////////////////////
// crash

(
SynthDef(\crash_dummies_proto, {
	Out.ar(0, WhiteNoise.ar(0.1) * Env.perc().kr(doneAction: 2));
}).add;
)

Synth(\crash_dummies_proto);

(
~ptrn2 = Pbind(
	\instrument, \crash_dummies_proto,
	\degree, Pwhite(0, 7, inf),
	\dur, 0.25,
	\legato, 1
);
)

(
p = ~ptrn2.play;

)
p.stop;

// /////////////////////////////////////////////////////////
// hihat close

(
SynthDef(\hh_close_dummies_proto, {
	Out.ar(0, WhiteNoise.ar(0.1) * Env.perc(releaseTime: 0.1).kr(doneAction: 2));
}).add;
)

Synth(\hh_close_dummies_proto);

(
~ptrn_hh_c = Pbind(
	\instrument, \hh_close_dummies_proto,
	\degree, Pwhite(0, 7, inf),
	\dur, 0.25,
	\legato, 1
);
)

(
p = ~ptrn_hh_c.play;

)
p.stop;


// ///////////////////////////////
// how can we make  | h h h c | ?
//

// ///////////////////////////////
// dump and visualisation

// ~stream_wn = Pwhite(0.0, 1.0, inf).asStream;
~stream_wn = Pwhite(0, 7, inf).asStream;
~stream_wn.nextN(10);
~stream_wn.nextN(1000).plot;
~stream_wn.nextN(1000).histo.plot;

~stream_listrand = Prand(#[1, 2, 4, 8], inf).asStream;
~stream_listrand.nextN(10);
~stream_listrand.nextN(1000).plot;
~stream_listrand.nextN(1000).histo.plot;


// /////////////////////////////////////////////////////////
// params
//

(
~ptrn_hh_c = Pbind(
	\instrument, \hh_close_dummies_proto,
	//\degree, Pwhite(0, 7, inf),
	\dur, 0.25,
	\legato, 1
);
)

(
p = ~ptrn_hh_c.play;

)
p.stop;

// \degree there doesnt matter
// compare to

(
~ptrn1 = Pbind(
	// \degree, Pwhite(0, 7, inf),
	\dur, 0.25,
	\legato, 1);
)

(
p = ~ptrn1.play;

)
p.stop;


// /////////////////////////////////////////////////////////
// hh break rythm
//

(
~ptrn_hh_c = Pbind(
	\instrument, \hh_close_dummies_proto,
	\dur, Prand(#[1, 2, 4, 8] * 0.25, inf),
	\legato, 1
);
)

(
p = ~ptrn_hh_c.play;

)
p.stop;


// ///////////////////////////////
// dump and visualisation 2

Env.perc(releaseTime: 0.1).plot;
// WhiteNoise.ar(0.1).plot; // no handle "plot" for "WhiteNoise" synth ((
{WhiteNoise.ar(0.1)}.plot(3);
{WhiteNoise.ar(0.1) * Env.perc(releaseTime: 1).kr(doneAction: 2)}.plot(1);
{WhiteNoise.ar(0.1) * Env.perc(releaseTime: 1).kr(doneAction: 2)}.play;

s.plotTree; // show instances (exemplars) of synths


///////////////////////////
// weighted rand

~weight1_ptrn = Pwrand(#[1, 2, 4, 8], #[0.5, 0.25, 0.1, 0.15], inf);
~stream_weight1 = ~weight1_ptrn.asStream;
~stream_weight1.nextN(20);
~stream_weight1.nextN(1000).plot;
~stream_weight1.nextN(1000).histo.plot;


// /////////////////////////////////////////////////////////
// hh break rythm, more short dur
//

(
~ptrn_hh_c_faster = Pbind(
	\instrument, \hh_close_dummies_proto,
	// \dur, Prand(#[1, 2, 4, 8] * 0.25, inf),
	\dur, ~weight1_ptrn * 0.25,
	\legato, 1
);
)

(
p = ~ptrn_hh_c_faster.play;

)
p.stop;


///////////////////////////
// sequenser

(
~seq1_ptrn = Pseq([
	1, 1, 1, Rest(1), 1, 1, Rest(1),
	1, 1, 1, Rest(1), 1, Rest(1), 1, 1, 1, 1, Rest(1), Rest(8)
], inf);
)
~seq1_stream = ~seq1_ptrn.asStream;
~seq1_stream.nextN(10);


// /////////////////////////////////////////////////////////
// hh sequense rythm
//

(
~ptrn_hh_c_seq1 = Pbind(
	\instrument, \hh_close_dummies_proto,
	\dur, ~seq1_ptrn * 0.25,
	\legato, 1
);
)

(
p = ~ptrn_hh_c_seq1.play;

)
p.stop;



(
~ptrn1_player = ~ptrn1.play;
~ptrn_hh_c_seq1_player = ~ptrn_hh_c_seq1.play;
)

(
~ptrn1_player.stop;
~ptrn_hh_c_seq1_player.stop;
)

// EventStreamPlayer.reset
// .mute
// .unmute
// .pause


//////////////////////////////////////
// compound patterns

// well
/*(
~rand_acc1_ptrn = Pbind(
	\degree, [3, 7],
	\dur, 0.25,
	\legato, 1
);
)*/

// Pwhite(0, 7, inf)


// bad idea
// (
// ~rand_acc1_ptrn = Pbind(
// 	\degree, [Pwhite(0, 7, inf), Pwhite(0, 7, inf)],
// 	\dur, 0.25,
// 	\legato, 1
// );
// )


(
~rand_acc1_ptrn = Pbind(
	\degree, Pwhite([0, 5], [3, 7], inf),
	\dur, 0.25,
	\legato, 1
);
)


// (
// var a, b;
// a = Pseq([1, 2, 3], inf);
// b = Pseq([65, 76], inf);
// c = Ptuple([a, a, b], inf);
// x = c.asStream;
// 8.do({ x.next.postln; });
// )
(
~tuple1_ptrn = Ptuple([
		Pwhite(0, 7, inf),
		Pwhite(0, 7, inf)
], inf);

~stream_tuple = ~tuple1_ptrn.asStream;
~stream_tuple.nextN(20);
)

(
~rand_acc_tuple1_ptrn = Pbind(
	\degree, ~tuple1_ptrn,
	\dur, 0.25,
	\legato, 1
);
)


(
~rand_acc_tuple1_ptrn_player = ~rand_acc_tuple1_ptrn.play;
)

~rand_acc_tuple1_ptrn_player.stop;

/// ///
//
(
~degree_seq2_ptrn = Pseq([[0, 2], 2, 4, [6, 8], 2, 1, Rest(), Rest()], inf);
// ~degree_seq2_ptrn = Pseq([[0, 2, 3].choose, 2, 4, [6, 8], 2, 1, Rest(), Rest()], inf); // fails
// ~degree_seq2_ptrn = Pseq([Pwhite([0, 7], inf), 2, 4, [6, 8], 2, 1, Rest(), Rest()], inf); // fails
// ~degree_seq2_ptrn = Pseq([Pwhite([0, 7], 1), 2, 4, [6, 8], 2, 1, Rest(), Rest()], inf); // similar to ~rand_acc1_ptrn Dont know why ))
)
~degree_seq2_stream = ~degree_seq2_ptrn.asStream;
~degree_seq2_stream.nextN(10);


(
~degree_seq2_pbind = Pbind(
	\degree, ~degree_seq2_ptrn,
	\dur, 0.25,
	\legato, 1,
	// \scale, Scale.major(\pythagorean)
	// \scale, Scale.minor
);
)

(
~degree_seq2_pbind_player = ~degree_seq2_pbind.play;
)

~degree_seq2_pbind_player.stop;


/// lace

/*(
var a, b;
a = Place(#[1, [2,5], [3, 6]], inf);
x = a.asStream;
8.do({ x.next.postln; });
)

1
2
3
1
5
6
1
2*/

// comparison: emulate a linrand
(
var a, b, x, y;
// a = Pprob([1, 0]);
a = Pprob([1, 0, 10, 1, 0.1, 5]);
x = Pfunc({ 1.0.linrand });

b = a.asStream;
y = x.asStream;

// postf("Pprob mean: % linrand mean: % \n", b.nextN(800).mean, y.nextN(800).mean);

b.nextN(800).sort.plot("this is Pprob");
// y.nextN(800).sort.plot("this is linrand");
b.nextN(800).histo.plot("Histo");
)
