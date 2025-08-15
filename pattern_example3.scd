(
[1, 4, 6, 8, 12].collect({
	arg item;
	item + sin(item)
});
)


(
p = Pbind(
	\freq, Pseq([100, 200, 400, 600], inf).trace,
	\dur, Pseq([100, 200, 400, 600]/120, inf).trace
).play;
)

p.stop;

2.reciprocal;

Pkey //copy from prev key

2.7.round(4)



{SinOsc.kr(5).range(3, 6)}.plot(2);
{SinOsc.kr(5).exprange(0.01, 6)}.plot(2);


//////////////////////////////////////
// change patterns


// direct change make new copy
(
Pbind(
	\freq, Pwhite(300, 700, inf).trace,
	\dur, Pseq([100, 200, 400, 600]/500, inf)
).play;
)


/// to change use Pdef
(
~part1_ptrn = Pbind(
	\freq, Pseq([100, 200, 400, 600], inf).trace,
	\dur, Pseq([100, 200, 400, 600]/120, inf)
);

~part1_ptrn_pl = Pdef(\simple_p, ~part1_ptrn);
)
~part1_ptrn_pl.play;

(
~part1_ptrn = Pbind(
	\freq, Pseq([100, 200, 400, 600]*2, inf).trace,
	\dur, Pseq([100, 200, 400, 600]/300, inf)
);
~part1_ptrn_pl = Pdef(\simple_p, ~part1_ptrn);
)


(
~part1_ptrn = Pbind(
	\freq, Pwhite(300, 700, inf).trace,
	\dur, Pseq([100, 200, 400, 600]/300, inf)
);
~part1_ptrn_pl = Pdef(\simple_p, ~part1_ptrn);
)

~part1_ptrn_pl.stop;



(
Pbind(
	\freq, Pwhite(300, 700, inf).trace,
	\dur, Pseq([100, 200, 400, 600]/500, inf)
).play;
)

////////////////////////
// Dictionary


(
~samples_dict = Dictionary.new;

~samples_dict.add(
	\pf -> PathName("D:/tmp/samples").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);

~samples_dict.add(
	\cl -> PathName("D:/tmp/sample2").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
)

~samples_dict[\pf].choose.play;
~samples_dict[\cl].choose.play;

// ~samples2_dict = Dictionary.new;

(
SynthDef(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

~samples_dict[\pf].choose

Synth(\bufplay, [\buf, ~samples_dict[\pf].choose.bufnum]);

s.plotTree;


(
~drum_ptrn_player = Pdef(\drum_ptrn,
	Pbind(
		\instrument, \bufplay,
		\dur, Pwhite(1, 8, inf) * 0.1,
		\buf, Prand(~samples_dict[\pf], inf),
		\rate, 1,
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).quant_(0.5);
)
//.quant_(0.5)

(
~part1_ptrn_pl = Pdef(\simple_p,
	Pbind(
		\freq, Pwhite(300, 700, inf).trace,
		\dur, Pwhite(1, 8, inf) * 0.1
	);
).quant_(0.5);
)
~drum_ptrn_player.stop;
Pdef(\drum_ptrn).stop;
Pdef(\simple_p).stop;


//////////////////////////////////////
// pattern by pattern


// p = Pxrand([
// 	Pbind( ... ,
// 		Pbind( ... ,
// 			...
// 	], inf).play;


/////////////////////////////////////
// Ppar and Pspawner

////////////////////////////////////
// Index(buf, i) - get value from buffer 