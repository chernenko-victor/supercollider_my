// ================================
//       part A
// ================================


// 2DO: find better sample
~buf_sample1 = Buffer.read(s, "D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic/R-8bend tom.wav");

....


(
{
	arg buf = 0;
	var sig_out;

	sig_out = PlayBuf.ar(
		1,
		buf,
		rate: 1, // rete control ... later
		doneAction: 2
	);
	sig_out = Limiter.ar(sig_out, dbamp(-0.97));
}.play(args: [\buf, ~buf_sample3]);
)

// something to do
// ....
// something to do
// ....


(
~tom_pl = Pbind(
	\dur, // ups ... fails
	\instrument, \sampler_mono_speed_var_proto,
	\buf, ~buf_sample1,
	// ...
	// ...
).play(~clk1, quant: 0);
)

// ================================
//       part B
// ================================


// no ideas (((


......
......
......




// ================================
//       part A
// ================================

// in repeat we trust ))