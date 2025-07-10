(
~master_send = Bus.audio(s, 2);

SynthDef(\master_proto, {
	arg
	    limit_lvl_db = -0.7
	  , thresh = 0.5
	  , slopeBelow = 1
	  , slopeAbove = 1
	  , compressor_out_lvl_db = 0
	;
	var in, out, master_send_lvl_db = 0, out_bus = 0, in_bus = 100;
	in = In.ar(~master_send, 2);
	// in = In.ar(in_bus, 2);
	in = Compander.ar(
		  in: in
		, control: in
		, thresh: thresh
		, slopeBelow: slopeBelow
		, slopeAbove: 1.0
		, clampTime: 0.01
		, relaxTime: 0.1
		, mul: dbamp(compressor_out_lvl_db)
	);
	out = Limiter.ar(in, dbamp(limit_lvl_db));
	out = LeakDC.ar(out);
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;


/*
0, 1, ... n выходные каналы
n+1, .... m входные каналы

0, 1
2, 3
*/

SynthDef(\space_proto, {
	var in, out, master_send_lvl_db = 0, out_bus = 0, in_bus = 100;
	in = In.ar(in_bus, 1);
	out = in;

	/*out	= Mix.fill(8, {
		arg indx;
		DelayC.ar(
			in,
			0.5,
			0.48 / (indx + 1),
			dbamp(-3) / (indx + 1)
		);
	});*/

	4.do({
		arg indx;
		out = DelayC.ar(
			out,
			0.5,
			0.48 / (indx + 1),
			dbamp(-3) / (indx + 1)
		);
	});

	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;


~rev_send = Bus.audio(s, 1);

SynthDef(\revv_proto, {
	arg master_send_lvl_db = 0, in_bus = 100, out_bus = 0;
	var out, in;
	in = In.ar(in_bus, 1);
	out = in!2;
	4.do({
		arg indx;
		out = CombC.ar(out, 0.5, 0.5 / (indx + 1), 0.1 * (indx + 1));
	});
	out = Mix.fill(6, {
		AllpassC.ar(out, 1, [0.8*rand(0.01, 1), 0.8*rand(0.01, 1)], 1*rand(0.5, 2));
	});
	// out = out / 6;
	Out.ar(out_bus, out * dbamp(master_send_lvl_db));
}).add;


/*
	TODO separate fx
	4.do({
		arg indx;
		out = CombC.ar(out, 0.5, 0.5 / (indx + 1), 0.1 * (indx + 1));
	});
	out = Mix.fill(6, {
		AllpassC.ar(out, 1, [0.8*rand(0.01, 1), 0.8*rand(0.01, 1)], 1*rand(0.5, 2));
	});
	out = out / 6;
	out = Compander.ar(out, out, dbamp(-3), 0.2, 1);
	out = Limiter.ar(out, 0.92);*/

)