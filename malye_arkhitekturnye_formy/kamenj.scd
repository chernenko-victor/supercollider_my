// include lib/fx.scd

(
~rev_send = Bus.audio(s, 1);

~shumm_proto = {
	arg
	  pos = 0,
	  master_send_lvl_db = 0,
	  reverb_send_lvl_db = -3
	;

	var
	  src = WhiteNoise.ar(0.1),
      amp_env,
	  lag_time,
	  freq_arr,
	  amp_arr,
	  ring_times_arr
    ;

	freq_arr = Array.fill(6, {
		arg index;
		LFNoise2.kr(Rand(0.05, 0.1)).range(0.9, 1.1) * (index + 1);
	});
	amp_arr = Array.fill(6, {
		arg index;
		LFNoise2.kr(Rand(0.05, 0.1)).range(0.1, 0.95);
	});
	ring_times_arr = Array.fill(6, {
		arg index;
		LFNoise2.kr(Rand(0.05, 0.1)).range(0.1, 0.95);
	});

	lag_time = LFNoise1.kr(0.1).exprange(0.75, 10).reciprocal;
	amp_env = Lag2.kr(
		Dust.kr(
			(SinOsc.kr(0.05)).exprange(0.2, 10);
		),
		lagTime: lag_time;
	);

	src = src * amp_env * 300;
	src = DynKlank.ar(
		`[
		  freq_arr,
		  amp_arr,
		  ring_times_arr
	    ],
		src,
		freqscale: 1.03 * (amp_env + 0.0005) * 200,
		freqoffset: 200 * (2 - linlin(amp_env, 0, 0.01, 0.9, 1.1)),
		decayscale: 1.1 * (2 - linlin(amp_env, 0, 0.01, 0.9, 1.1))
	);
	Out.ar(~rev_send, src * dbamp(reverb_send_lvl_db));
	Out.ar(~master_send, Pan2.ar(src, pos) * dbamp(master_send_lvl_db));
};

SynthDef(\reverb_proto, {
	arg pos = 0, in_bus = 1000, roomsize = 1, revtime = 0.1, damping = 0.3;
	var sig_in, sig_out;
	sig_in = In.ar(in_bus, 1);
	sig_out = GVerb.ar(sig_in, roomsize: roomsize, revtime: revtime, damping: damping);
	sig_out = Pan2.ar(sig_out, pos);
	Out.ar(~master_send, sig_out);
}).add;
)

~master = Synth(\master_proto);

~reverb = Synth(\reverb_proto, args: [\pos, 0.3, \in_bus, ~rev_send, \roomsize, 1.01, \damping, 0.74, \revtime, 0.6]);

~shumm = ~shumm_proto.play(args: [\pos, -0.7, \master_send_lvl_db, -4, \reverb_send_lvl_db, -10]);


// ~reverb.set(\damping, 0.74);
// ~reverb.set(\roomsize, 1.01);
// ~reverb.set(\revtime, 0.2);

~shumm.free;
~reverb.free;

////////////////
(
{
	Decay.kr(
		Dust.kr(
			2
		),
		lagTime: 0.7
	).range(0, 1).poll;
}.plot(3);
)


(
{Line.kr(0.01, 0.5, 3, doneAction: 2).range(0.01, 2);}.plot(3);
)

(
{
	LFNoise1.kr(2).exprange(0.75, 10).reciprocal;
}.plot(5);
)