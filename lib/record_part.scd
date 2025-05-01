(
~recorder1 = Recorder.new(s);
~recorder1.prepareForRecord("C:/home/chernenko/audio/music/chernenko/sabia_n11/Media/fl_sc_synth.v3.wav", 2);
~recorder1.recHeaderFormat = "wav";
~recorder1.recSampleFormat = "int24";

~record_bus1 = Bus.audio(s, 2);
)