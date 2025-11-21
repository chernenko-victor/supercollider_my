(
~buf1 = Buffer.new( // setup buffer

// define object
SynthDef(\rec_buffer_and_process, {

		var out_sig, direct_lvl = 0.1, freeze_lvl = 0.25;
		~in_sig = In.ar // take signal from mic
		~in_sig = 	Compander.ar(~in_sig // compress input signal
		RecordBuf.ar(~in_sig, ~buf1, run: run

		~start_stop_rec = Amplitude.kr(~in_sig // detect onset

		// to stop record set RecordBuf 'run' argument to 0
		// to resume record set RecordBuf 'run' argument to 1

		// ...

		// modify ~start_stop_rec to trigger form with 2 values: 0 or 1

		~freezed = PV_MagFreeze * ~start_stop_rec // mute/ unmute freezer

		// ...
		
		out_sig = (~in_sig * direct_lvl) + (~freezed * freeze_lvl) + ... // mix all signals

		Out.ar(0, Limiter.ar(out_sig)); // out all signal to sound device
}.add;
)

~proces_audio = Synth(\rec_buffer_and_process);		// run process
~proces_audio.free; // stop process