~my_scale_ptrn = Prand([0, 2, 3, 5], inf);
~my_scale_ptrn_stream = ~my_scale_ptrn.asStream;
~my_scale_ptrn_stream.next;
~my_scale_ptrn_stream.reset;

(
Pbind(
	\degree, ~my_scale_ptrn,
).play;
)

s.plotTree;

// ~clock1 = TempoClock.new(117/60); // tempro in bps, so I divides it by 60
~clock1 = TempoClock.new(117/60).permanent_(true); // it will survive after ctrl + period

~clock1 = TempoClock.new(117/60).permanent_(true).schedAbs(0, {~clock1.beatsPerBar_(3)}); // it will survive after ctrl + period


~clock1.beats;
~clock1.bar; // default 4  beats in bar

~clock1.stop; // it will kill clock

// dur in Pbind is beat, not second

(
~my_scale_play = Pbind(
	\degree, ~my_scale_ptrn,
).play(~clock1);
)

~my_scale_play.stop;

~clock1.tempo_(80/60);
~clock1.tempo_(112/60);

Quant

//The routine will begin on the next integer multiple of this number after the baseBarBeat.

(
~my_scale1_play = Pbind(
	\degree, ~my_scale_ptrn,
).play(~clock1, quant: Quant(4));
)


(
~my_scale2_play = Pbind(
	\degree, ~my_scale_ptrn,
).play(~clock1, quant: Quant(4));
)

(
~get_line = {
	arg begin_tempo, end_tempo, begin_time, end_time, curr_time;
	var a, b;
	a = (end_tempo - begin_tempo) / (end_time - begin_time);
	b = begin_tempo - (a * begin_time);
	(a * curr_time) + b;
};
)
~get_line.value(110/60, 80/60, 1, 10, 10);

110/60
80/60

(
~change_tempo = {
	arg clock, begin_tempo, end_tempo, dur;
	var begin_time, end_time, curr_tempo;
	begin_time = clock.seconds;
	end_time = dur + begin_time;
	clock.tempo_(begin_tempo);
	curr_tempo = begin_tempo;
	clock.sched(0, {
		curr_tempo = ~get_line.value(begin_tempo, end_tempo, begin_time, end_time, clock.seconds);
		curr_tempo.postln;
		clock.tempo_(curr_tempo);
		if(clock.seconds < end_time) {0.25} {\done.postln};
	});

};
)

~change_tempo.(~clock1, 110/60, 80/60, 20);

~change_tempo.(~clock1, 110/60, 80/60, 10);


begin_tempo = a * begin_time + b
end_tempo = a * end_time + b

end_tempo - begin_tempo = a * (end_time - begin_time)


a = (end_tempo - begin_tempo) / (end_time - begin_time)
b = begin_tempo - a * begin_time


~clock1.seconds;

~my_scale1_play.stop;
~my_scale2_play.stop;

Event.partialEvents.durEvent[\sustain].postcs;
~change_tempo.postcs;


Event.partialEvents.pitchEvent[\freq].postcs;
	#{

					(~midinote.value + ~ctranspose).midicps * ~harmonic;

				}
Event.partialEvents.ampEvent[\amp].postcs;
	#{ ~db.dbamp }


Event.partialEvents.pitchEvent[\freq].postcs;


// start something from next bar

~clock1.schedAbs(~clock1.nextBar - 0.01, {nil;});
