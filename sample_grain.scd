{WhiteNoise.ar(0.1)}.play;

(
~arturia1_buf = Buffer.read(s, "C:/home/chernenko/audio/samples/arturia2.wav");
~master_send = Bus.audio(s, 2);
~arturia1_mono_buf = Buffer.readChannel(s, "C:/home/chernenko/audio/samples/arturia2.wav", channels: 0);
)

(
SynthDef(\player_proto, {
	arg buf = 0;
	var out;
	out = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1);
	Out.ar(0, out);
}).add;
)

~player1 = Synth(\player_proto, [\buf, ~arturia1_buf]);

~player1.free;

(
/*
~add_synth_proto = {
	arg frq = 440, amp = 0.3;
	var amp_base = 1, amp_env_form, amp_env_gen, final;
	amp_env_form = Env.perc(0.3, 0.8, curve: 3.0);
	amp_env_gen = EnvGen.kr(amp_env_form, doneAction: 2);
	final = amp *
	        amp_env_gen *
	        Mix.fill(8, {
                 arg i;
		         SinOsc.ar(frq*(i+1), 0, amp_base/(i+1))
	        });
	final!2;
};
*/

SynthDef(\add_synth_var_proto, {
	arg freq = 440, amp = 0.3;
	var amp_base = 1, amp_env_form, amp_env_gen, final;
	amp_env_form = Env.perc(0.3, 0.8, curve: 3.0);
	amp_env_gen = EnvGen.kr(amp_env_form, doneAction: 2);
	final = amp *
	        amp_env_gen *
	        Mix.fill(8, {
                 arg i;
		         SinOsc.ar(freq*(i+1), 0, amp_base/(i+1))
	        });
	Out.ar(0, final!2;);
}).add;


SynthDef(\granulator2_proto, {
	arg buf = 0;
	var out, center_pos, dur = 1, env, env_form;
	env_form = Env.new(
		levels: [0.5, 0.5, 0.05],
		times: [0.01, 1]
	);
	env = EnvGen.kr(env_form, \trig_dur.tr);
	dur = dur * env;
	center_pos = (SinOsc.kr(0.3).range(dur/2, BufDur.kr(buf)/2))*LFNoise2.kr(0.7).range(0.3, 1);
	// out = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1);
	out = TGrains.ar(
		numChannels: 2,
		trigger: Impulse.kr(LFNoise2.kr(0.7).range(0.3, 100)),
		bufnum: buf,
		rate: 1,
		// centerPos: BufDur.kr(buf)/2,
		centerPos: center_pos,
		dur: dur,
		amp: 0.5
	);
	4.do({
		arg indx;
		out = CombC.ar(out, 0.5, 0.5 / (indx + 1), 0.1 * (indx + 1));
	});
	out = Mix.fill(6, {
		AllpassC.ar(out, 1, [0.8*rand(0.01, 1), 0.8*rand(0.01, 1)], 1*rand(0.5, 2));
	});
	out = out / 6;
	out = Compander.ar(out, out, dbamp(-3), 0.2, 1);
	out = Limiter.ar(out, 0.92);
	Out.ar(0, out);
}).add;
)

~granulator2 = Synth(\granulator2_proto, [\buf, ~arturia1_mono_buf]);

~granulator2.set(\trig_dur, 1);

~granulator2.free;


~add_synth_var = Synth(\add_synth_var_proto);

s.plotTree;


{Trig.kr(Impulse.kr(3), dur: 0.3)}.plot(duration: 1);


{Trig.kr(1, 0.9)}.plot(duration: 1);

//////////////////////////////////////
//          Stream              //////
//////////////////////////////////////

(
~stream_rnd = FuncStream.new({
	10.rand;
});
)
~stream_rnd.next;
~stream_rnd.nextN(20);

(
~routine1 = Routine.new({
	3.do({
		arg indx;
		indx.yield;
	});

	4.do({
		arg indx;
		(indx**2).yield;
	});
});
)
~routine1.next;
~routine1.reset;

(
~routine_inf = Routine.new({
	loop({
		10.rand.yield;
	})
});
)

~routine_inf.next;


(
~routine_player = Routine.new({
	var step = 0;
	loop({
		step.postln;
		step = step + 1;
		(0.5 + 4.rand).wait;
	});
});
)

~routine_player.play;
~routine_player.stop;
~routine_player.reset;


// https://doc.sccode.org/Tutorials/Streams-Patterns-Events2.html
// https://doc.sccode.org/Classes/Pattern.html

//////////////////////

(
~streamGen = Array.fill(20, {
	arg indx;
	if(
		0.85.coin,
		{
			rand((indx+1) * 3) + ((indx+1) * 2) + 32;
		},
		{
			Rest(0)
		}
	);
});
// ~streamGen = ~streamGen + 32;
~midi_seq1 = Pseq(~streamGen, inf);
~stream1 = ~midi_seq1.asStream;
)



~stream1.next;
~stream1.nextN(20);
~stream1.reset;
~stream1.nextN(20).plot;

//~clock1 = TempoClock.new(1);

//~stream1.play(~clock1);
//~stream1.stop;

////////////////////////////////////
(
~part1 = Pbind(
	\freq, ~midi_seq1,
	\dur, 0.1
);
)

~part1_player = ~part1.play;
~part1_player.stop;
~part1_player = ~part1.play;



(
~part2 = Pbind(
	\instrument, \add_synth_var_proto,
	\freq, ~midi_seq1,
	\dur, 0.1
);
~part2_player = ~part2.play;
)

~part2_player.stop;
~part2_player = ~part2.play;


//////////////////////
Place([0, [1, 2], [3, 4, 5]], 3).clump(3);

x = Pclump(2, Pseq([1,2,3], 1)).asStream;
x.next;
x.next;
x.next;
x.reset;

y = Pser(x.next, inf).asStream;
y.next;

//////////////////////////////////////
(
Pbind(
    \note,  Env([0, 12, 6, 13, 0], [1, 5, 2, 10]),
    \dur, 0.1
).play
)

//////////////////////////////////////


~rnd_ptrn = Prand([1, 2, 3, 4, 5], 2);
~rnd_stream = ~rnd_ptrn.asStream;
~rnd_stream.next;
~rnd_stream.reset;

//////////////////////////////////////

(
~random_ptrn = Pseq([
	Prand([1, 2, 3, 4, 5], 2),
	Prand([-1, -2, -3, -4], 3)
], inf);
)

~random_stream = ~random_ptrn.asStream;

~random_stream.nextN(20);



///////////////////////////////////
(
var a, b;
a = Prand.new([
        Pseq.new([1, 2], 2),
        Pseq.new([3, 4], 2),
        Pseq.new([5, 6], 2)
    ], 3);
b = a.asStream;
13.do({ b.next.postln; });
)

(
var a;
a = Prand([
        Pseq(#[60, 61, 63, 65, 67, 63]),
        Prand(#[72, 73, 75, 77, 79], 6),
        Pshuf(#[48, 53, 55, 58], 2)
    ], inf
).midicps.asStream;
Task({
    loop({
        Synth( \help_SPE3_SimpleSine, [\freq, a.next] );
        0.3.wait;
    });
}).play;
)

///////////////////////////////////


Pswitch.new(list, which: 0);

Pindex.new(listPat, indexPat, repeats: 1)
Arguments:
listPat
the array. Can be a Pattern.

indexPat
the value to retrieve. Can be a Pattern.

repeats
specifies the number of repeats.

(
var data = [7, 13, 12, 2, 2, 2, 5];
var indices = [0, 0, 2, 0, 4, 6, 7];
Pbind(
    \instrument, \help_pindex,
    \choice, Prand(indices, inf),
    \degree, Pindex(data, Pkey(\choice), inf),
    \dur, 0.7
).play
)

///////////////////////////////////

(
~nested_ptrn = Pseq.new(
	[
		1,
		Pseq.new([100,200], 2),
		3
	],
	3
);
~nested_stream = ~nested_ptrn.asStream;
)


~nested_stream.next;

//////////////////////////////////////////////
(
~nested2_ptrn = Pseq.new(
	[
		Prand([nil, 32, 64, 48]),
		Pseq.new([64, 72], 2),
		80
	],
	inf
);
~nested2_stream = ~nested2_ptrn.asStream;
)


~nested2_stream.next;


(
~part3 = Pbind(
	\instrument, \add_synth_var_proto,
	\freq, ~nested2_ptrn.midicps,
	\dur, 1
);
~part3_player = ~part3.play;
)

~part3_player.stop;
~part3_player = ~part3.play;

/////////////////////////////////////////////

(
~dur1_ptrn = Prand([
	Pseq([0.1, 0.1, 1, 0.1, 3]),
	Pseq([1, 1, 0.3, 1, 0.5])
], inf);
)

(
~part4 = Pbind(
	\instrument, \add_synth_var_proto,
	\freq, ~nested2_ptrn.midicps,
	\dur, ~dur1_ptrn
);
~part4_player = ~part4.play;
)

~part4_player.stop;
~part4_player = ~part4.play;


/////////////////////////////////////////////

(
Pbind(
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \dur, Pseq([1], 3),
).play;
)

(
Pbind(
  \degree, 1,
  \octave, 5,
  \dur, Pseq([1], 2),
).play;
)

(
Pbind(
  \note, 1,
  \octave, 5,
  \dur, Pseq([1], 2),
).play;
)

(
Pbind(
  \degree, 3,
  \octave, 5,
  \dur, Pseq([1], 2),
).play;
)

///////////////////////////////

Scale.major.degrees;

Scale.directory;

Scale.dorian.degrees;

(
Pbind(
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \dur, Pseq([1], 3),
).play;
)

(
Pbind(
  \scale, Scale.dorian.degrees,
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \dur, Pseq([1], 3),
).play;
)

(
Pbind(
  \scale, Scale.dorian.degrees,
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \root, 2,
  \dur, Pseq([1], 3),
).play;
)

(
Pbind(
  \scale, Scale.dorian.degrees,
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \root, [2, 4],
  \dur, Pseq([1], 3),
).play;
)

(
Pbind(
  \scale, Scale.dorian.degrees,
  \degree, Pseq([0, 2, 4], 2), //number of the note in the scale you are using
  \octave, 5,
  \root, Pseq([2, 2, 2, 4, 4, 4], 1),
  \dur, Pseq([1], 6),
).play;
)

(
Pbind(
  \scale, Scale.dorian.degrees,
	\degree, Pseq([[0, 3, 5], [2, 5, 7], [4, 7, 10]], 2), //number of the note in the scale you are using
  \octave, 5,
  \root, 2,
  \dur, Pseq([1], 3),
).play;
)

////////////////////////////////////////

// d[\scale] = Scale.choose.postln;
Scale.choose.postln;


////////////////////////////////////////

(
~chords = Pbind(
    \dur,Pwhite(4.5,7.0,inf),
    \scale,[Scale.minor,Scale.major].choose,
    \degree,Pwrand([[0,2,4],[3,5,7],[4,6,8]],[0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[0.6,0.3,0.1],inf),
    \amp,Pwhite(0.1, 0.3),
);
)

~chords_player = ~chords.play;
~chords_player.stop;

///////////////////////////////////

Tuning.directory;

Tuning.choose;

Scale.chromatic(Tuning.choose);

(
~sinfb = Pbind(
	\scale,d[\scale],
	\octave,4,
	\degree,Pseq((0..d[\scale].degrees.size-1),inf),
	\dur,0.25,
	\amp,0.3
);
)
~sinfb_player = ~sinfb.play;
~sinfb_player.stop;


Scale.major(Tuning.choose);

Tuning.new(#[ 0, 0.795, 2.251, 3.251, 4.036, 4.680, 5.915, 7.221, 8.013, 9.29, 9.930, 11.032 ]);


///////////////////////////////////

//Microtonal scales
(
p.clock.tempo = 1;

// d[\scale] = [
~microtonal_scale = [
	Scale.zamzam,
	Scale.chromatic24,
	Scale.partch_o1,
	Scale.husseini,
	Scale.zanjaran,
	Scale.bhairav
].choose.postln;

~sinfb = Pbind(
	\scale, ~microtonal_scale,
	\octave, 4,
	\degree, Pseq((0..d[\scale].degrees.size-1),inf),
	\dur, 0.25,
	\amp, 0.3
);
)
~sinfb_player = ~sinfb.play;
~sinfb_player.stop;

////////////////////////////////////////

d[\scale] = Scale.chromatic(Tuning.choose);


/*
(
~dur1_ptrn = Prand([
	Pseq([0.1, 0.1, 1, 0.1, 3]),
	Pseq([1, 1, 0.3, 1, 0.5])
], inf);
)
*/

// Scale.all.postln; atharKurd
// Scale.directory;
/*
Scale(
  [ 0, 2, 6, 12, 14, 16, 22 ],
  24,
  Tuning([ 0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5 ],
  2.0,
  "ET24"),
  "Athar Kurd"
)
*/
~atharKurd_scale = Scale.at(\atharKurd);
~dorian_scale = Scale.at(\dorian);

Scale.major.degreeToFreq(2, 60.midicps, 1);        // 659.25511...
Scale.major(\just).degreeToFreq(2, 60.midicps, 1);    // 654.06391...

~atharKurd_scale.degreeToFreq(4, 60.midicps, 1);
~dorian_scale.degreeToFreq(4, 60.midicps, 1);

Scale.atharKurd.degreeToFreq(2, 60.midicps, 1)
Scale.dorian.degreeToFreq(2, 60.midicps, 1)
Scale.scriabin.degreeToFreq(2, 60.midicps, 1)


~atharKurd_scale.degrees;        // [ 0, 2, 4, 5, 7, 9, 11 ]
~dorian_scale.degrees;

~atharKurd_scale.semitones;        // [ 0, 2, 4, 5, 7, 9, 11 ]
~dorian_scale.semitones;

~atharKurd_scale.cents;        // [ 0, 200, 300, 500, 700, 900, 1100 ]
~dorian_scale.cents;

~atharKurd_scale.ratios;
~dorian_scale.ratios;

(
~note_ptrn = Pseq([0, 1, 2, 3, 4, 5, 6, 7], 2);
~ctranspose_ptrn = Pseq([0, 0.25, 0, 0, -0.25, -0.25, 0, 0.25], 2);
)

(
~part5 = Pbind(
	\instrument, \add_synth_var_proto,
	// \degree, ~note_ptrn,
	\note, ~note_ptrn,
	//\octave, 4,
	// \scale, ~atharKurd_scale,
	 \scale, ~dorian_scale,
	// \stepsPerOctave, 27,
	//\dur, ~dur1_ptrn,
	//\ctranspose, ~ctranspose_ptrn,
	\dur, 1
);
~part5_player = ~part5.play;
)

~part5_player.stop;
~part5_player = ~part5.play;

/////////////////////////////////////

Ppar
The Ppar pattern allows you to merge multiple event streams to play in parallel.