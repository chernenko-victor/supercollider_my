(
~dr_buf_arr = PathName("D:/audio/samples/90s-sample-cds/SN-R8-04-Electronic").entries.collect({
	arg sample_path;
	// sample_path.fullPath.postln;
	Buffer.read(s, sample_path.fullPath);
});
)

~dr_buf_arr.choose.play;

(
{
	arg buf;
	PlayBuf.ar(buf.numChannels, buf, BufRateScale.ir(buf), trigger: 1, doneAction: 2);
}.asSynthDef(name: \simple_buf_pl).add;
// .play(args: [\buf, ~dr_buf_arr.choose])
)

(
Pdef(
	\sample_pl,
	Pbind(
		\instrument, \simple_buf_pl,
		\buf, Prand(~dr_buf_arr, inf),
		\dur, Pdefn(\sample_pl_dur, Pseq([1, 2, 4, 8] * 0.25, inf))
	)
).stop;
)

Pdefn(\sample_pl_dur, Prand([1, 2, 4, 8] * 0.1, inf));