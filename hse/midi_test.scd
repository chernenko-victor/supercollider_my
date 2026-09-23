Pbind().play;


MIDIClient.init;
~mudi_out_dev = MIDIOut(1);
~mudi_out_dev.noteOn(0, 60, 80);
~mudi_out_dev.noteOn(0, 60, 0);


m = MIDIOut(1);
m.noteOn(0, 60, 80);
m.noteOn(0, 60, 0);


Pbindef(\midi_seq).clear;

(
Pbindef(\midi_seq,
\type, \midi,
\midiout, m,
\chan, 0,
\midinote, 60,.
\dur, 1,
\amp, 0.5,
).play;
)

(
Pbindef(\tr_ba_midi,
    \type, \midi,         // Говорим паттерну отправлять MIDI, а не генерировать аудио
    \midiout, m,          // Передаем наш MIDI-выход
    \chan, 0,             // MIDI-канал (0 = 1-й канал)
    \midinote, Pseq([60, 62, 64, 67], inf), // Ноты в формате MIDI (60 = До первой октавы)
    \dur, 0.25,
    \amp, 0.6             // Громкость, которая автоматически пересчитается в Velocity (0-127)
).play;
)

Pbindef(\midi_seq).stop;

Pbind().play;
