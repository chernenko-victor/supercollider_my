///////////////////////
// start init
(
s.waitForBoot({
	var path2lib = "C:/home/Admin/src/supercollider/supercollider_my/lib/";

	"--- Server started. Preparing patch... ---".postln;
	s.freeAll; // Clear all

	// 2. downloading synths
	(path2lib+/+"fx.scd").load;

	s.sync;    // make shure synth created and samples downloaded to buffers

	~master = Synth(\master_proto); // see in fx.scd
	"--- Master synth started. Use ~master_send bus to send sound to master ---".postln;
	"--- Ready for work ---".postln;
});
)

s.plotTree;

//https://supercollider.github.io/sc-140.html Nathaniel Virgo
(
SynthDef(\feedback_nvirgo__proto, {
	arg
	    out_bus = 0
	  //, rec_bus = 1000
	  //, send_fx1_bus = 1001

	  , master_send_lvl_db = 0
	  //, rec_send_lvl_db = 0
	  //, fx1_send_lvl_db = 0

	  // , master_pos = 0
	  // , rec_pos = 0
	  // , fx1_pos = 0
	;
	var out_sig;
	LocalOut.ar(
		out_sig=CombN.ar(
			BPF.ar(
				LocalIn.ar(2) * 7.5 + Saw.ar([32,33], 0.2) //in
				, 2 ** LFNoise0.kr(4/3, 4) * 300 //frq
				,0.1 //rq = bandwidth / freq
			).distort //in
			, 2 //max delay time
			, 2 //delay time
			, 40 //decaytime
		)
	);
	Out.ar(out_bus, out_sig * dbamp(master_send_lvl_db));
}).add;


SynthDef(\noise_pingpong__proto, {
	arg
	    out_bus = 0
	  //, rec_bus = 1000
	  //, send_fx1_bus = 1001

	  , master_send_lvl_db = 0
	  //, rec_send_lvl_db = 0
	  //, fx1_send_lvl_db = 0

	  // , master_pos = 0
	  // , rec_pos = 0
	  // , fx1_pos = 0
	;
	var source_sig, out_sig;

    source_sig = Decay.ar(Impulse.ar(0.3), 0.1) * WhiteNoise.ar(0.2);
    out_sig = LocalIn.ar(2) + [source_sig, 0]; // read feedback, add to source
    out_sig = DelayN.ar(out_sig, 0.2, 0.2); // delay sound

    // reverse channels to give ping pong effect, apply decay factor
    LocalOut.ar(out_sig.reverse * 0.8);

	Out.ar(out_bus, out_sig * dbamp(master_send_lvl_db));
}).add;


)

(
~feedback_nvirgo = Synth(\feedback_nvirgo__proto, args: [\bus_out, ~master_send,]);
)

~feedback_nvirgo.free;

(
~noise_pingpong = Synth(\noise_pingpong__proto, args: [\bus_out, ~master_send,]);
)

~noise_pingpong.free;



FreqScope.new;


/*


(
play(
	{
		Decay.ar(
			Impulse.ar(
				0.5
			) //in
			, 0.2 //decayTime
			, 1//PinkNoise.ar //mul
			, 0
		) * WhiteNoise.ar;
	}
);
)
*/

(
SynthDef(\feedback_synth__proto, {
	arg
	    out_bus = 0
	  //, rec_bus = 1000
	  //, send_fx1_bus = 1001

	  , master_send_lvl_db = 0
	  //, rec_send_lvl_db = 0
	  //, fx1_send_lvl_db = 0

	  // , master_pos = 0
	  // , rec_pos = 0
	  // , fx1_pos = 0
	;

	var src, dest;
	src = Decay.ar(
		Impulse.ar(
			0.5
		)
	) * WhiteNoise.ar(0.2);

	dest = src.dup + LocalIn.ar(2);
	dest[0] = CombN.ar(
			dest[0]
			, 0.1
			, 0.1
			, 0.2
		);
	dest[1] = CombN.ar(
			dest[1]
			, 0.1 //maxdelaytime
			, 0.1 //delaytime
			, 0.2 //decay
		);

	LocalOut.ar(dest * 0.8);
	// Out.ar(0, dest);
	Out.ar(out_bus, dest * dbamp(master_send_lvl_db));
}).add;


)

(
SynthDef("tank__proto", {
	arg
	    out_bus = 0
	  //, rec_bus = 1000
	  //, send_fx1_bus = 1001

	  , master_send_lvl_db = 0
	  //, rec_send_lvl_db = 0
	  //, fx1_send_lvl_db = 0

	  // , master_pos = 0
	  // , rec_pos = 0
	  // , fx1_pos = 0
	;

    var local, in;

	in = Pan2.ar(
		Decay2.ar(
              Dust.ar(0.5),
              0.1,
              0.5,
              1
            )
		*
		SinOsc.ar(),
		Rand(-1 , 1)
	)
	;

	/*
    in = Mix.fill(12, {
        Pan2.ar(
            Decay2.ar(
              Dust.ar(0.05),
              0.1,
              0.5,
              0.1
            )
                * FSinOsc.ar(IRand(36, 84).midicps).cubed.max(0),
            Rand(-1, 1)
		)
    });

    in = in + Pan2.ar(Decay2.ar(Dust.ar(0.03), 0.04, 0.3) * BrownNoise.ar, 0);

    4.do { in = AllpassN.ar(in, 0.03, { Rand(0.005, 0.02) }.dup, 1) };

    local = LocalIn.ar(2) * 0.98;
    local = OnePole.ar(local, 0.5);

    local = Rotate2.ar(local[0], local[1], 0.23);
    local = AllpassN.ar(local, 0.05, { Rand(0.01, 0.05) }.dup, 2);

    local = DelayN.ar(local, 0.3, [0.19, 0.26]);
    local = AllpassN.ar(local, 0.05, { Rand(0.03, 0.15) }.dup, 2);

    local = LeakDC.ar(local);
    local = local + in;

    LocalOut.ar(local);
	*/
	// Out.ar(out, local);
	Out.ar(out_bus, in * dbamp(master_send_lvl_db));
}).add;
)

~feedback_synth1 = Synth(\feedback_synth__proto, args: [\bus_out, ~master_send,]);
~feedback_synth1.free;


~tank = Synth(\tank__proto, args: [\bus_out, ~master_send,]);
~tank.free;


({
	Decay2.ar(
              Dust.ar(0.5),
              0.1,
              0.5,
              1
	) * WhiteNoise.ar();
}.plot(10))