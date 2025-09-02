
Event.partialEvents.pitchEvent[\freq].postcs;
	#{

					(~midinote.value + ~ctranspose).midicps * ~harmonic;

				}
Event.partialEvents.ampEvent[\amp].postcs;
	#{ ~db.dbamp }


Event.partialEvents.pitchEvent[\freq].postcs;


Event.partialEvents.pitchEvent[\midinote].postcs;


#{

					(((~note.value + ~gtranspose + ~root) /

						~scale.respondsTo(\stepsPerOctave).if(

							{ ~scale.stepsPerOctave },

							~stepsPerOctave) + ~octave - 5.0) *

						(12.0 * ~scale.respondsTo(\octaveRatio).if

							({ ~scale.octaveRatio }, ~octaveRatio).log2) + 60.0);

				}