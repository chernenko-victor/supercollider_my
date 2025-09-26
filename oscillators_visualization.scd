
(
{
	[LFPar.ar(440), SinOsc.ar(440)];
}.scope(2);
)

(
{
	[LFPar.ar(10), SinOsc.ar(10)]
}.plot(2);
)

(
{
	SinOsc.ar(440);
	// LFPar.ar(440);
}.freqscope();
)

//

(
{
	// [LFTri.ar(440), LFSaw.ar(440)] * 0.2;
	// Impulse.ar() * 0.2;
	// LFPulse.ar() * 0.2;
	/*[VarSaw.ar(440, width: 0.3), VarSaw.ar(440, width: 0.75),] * 0.2;*/
	[SyncSaw.ar(syncFreq: 33.3, sawFreq: 440), SyncSaw.ar(syncFreq: 330, sawFreq: 440),] * 0.2
}.scope(2);
)

(
{
	// [LFPulse.ar(10, width: 0.1), LFPulse.ar(440)]
	/*[
		LFPulse.ar(
			10,
			width: LFTri.kr(0.5).range(0.1, 0.9),
		),
		LFPulse.ar(440)
	]*/
	/*[
		VarSaw.ar(10, width: 0.3),
		VarSaw.ar(10, width: 0.75),
	] * 0.2;*/
	[SyncSaw.ar(syncFreq: 33.3, sawFreq: 44), SyncSaw.ar(syncFreq: 3, sawFreq: 10),] * 0.2
}.plot(2, bounds: Window.screenBounds);
)

(
{
	// Impulse.ar * 0.2;
	// LFTri.ar(440) * 0.2;
	// LFSaw.ar(440) * 0.2;

	/*LFPulse.ar(
			440,
			width: LFTri.kr(0.5).range(0.1, 0.9),
		) * 0.2;*/

	/*VarSaw.ar(
		440,
		width: SinOsc.kr(0.5).range(0.1, 0.9),
	) * 0.2;*/

	LPF.ar(
		SyncSaw.ar(
			// syncFreq: 33.3,
			syncFreq: LFNoise0.kr(0.33).exprange(11, 110),
			sawFreq: 440
		) * 0.1,
		2000
	)
}.freqscope();
)