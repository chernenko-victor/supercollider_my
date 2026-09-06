// include "Конспекты Теория электронной музыки.v10.docx" as ТЭМТП.doc

// include "Справка по SuperCollider.pdf" as faq.pdf
// Справка: как запустить код. что делать, если нет звука и т.д.
// FAQ: start, stop, troubleshooting ...
// https://drive.google.com/file/d/1pDN_A6RRTUMaGWHdsSrlzgxl278MaxZ3/view?usp=drive_link


// ===================================
// ==========    bootstrap    ========
// ===================================

// faq.pdf :: bootstrap (server, devices), start code, stop code.
// bootstrap error? faq.pdf :: Подготовка к работе

// ================
// wrong samplerate?

// 1. see actual
s.sampleRate

// 2. change SR
s.options.sampleRate = 44100;

// 3. reboot server
s.reboot;


// ================
// change audio device

// 1. see list of available devices

~devArr = ServerOptions.outDevices; // выходные

(
~devArr.do({
	arg i;
	i.postln;
});
)

~devInArr = ServerOptions.inDevices; // выходные

(
~devInArr.do({
	arg i;
	i.postln;
});
)


// 2. change device
s.options.outDevice_("Windows WASAPI : CABLE Input (VB-Audio Virtual Cable)");


// 3. reboot server
s.reboot;


//
s.options.outDevice = nil;


// =====================================
// ==========    check sound    ========
// =====================================

Pbind().play;

(
~seq_for_fm2 = Pbind(
	\instrument, \FMRhodes1,
	\freq, Pser(([1, 2, 4, 8] * 110).scramble, inf),
	\dur, Pser([1, 2, 4] * 0.25, inf),
	\amp, 0.5,
	\lfoSpeed, Pser([1, 2, 4, 8], inf),
).play;
)


(1, 3..10)


[1, 2, 4, 8].reverse

[1, 2, 4, 8].scramble


~seq_for_fm2.stop;

~seq2.stop;

// ===================
// no sound?


// see "change audio device" above

// ТЭМТП.doc :: Если нет звука

// see "change_device.csd"



///////////////////////////////////////
// play, stop, change, play, stop .....

(
~seq1 = Pbind(
	\freq, 440,
	\dur, 0.25,
).play;
)

~seq1.stop;

// to help press place pointer to word and press Ctrl+D



///////////////////////////////////////
// livecoding style
//
// change freq and duration, evaluate region
// to stop change "play" to "stop" and evaluate region

(
Pdef(
	\seq1_lc,
	Pbind(
		\freq, 220,
		\dur, 0.25,
	)
).stop;
)


///////////////////////////////////////
// Patterns
//
// Pser plays element of array [] N times
// change N to inf
//
// Insert Pser pattern to \dur
//
// replace \freq pattern to Prand([1, 2/3, 3/4, 4/5] * 220, inf)
//
// add random to \dur

(
Pdef(
	\seq1_lc,
	Pbind(
		\freq, Pser([220, 330, 440, 880]),
		\dur, 0.03,
	)
).stop;
)

/////////////////////////////////////////
// installation extensions (quarks)
//
// Main menu - Language - Quarks, in new window check SCLOrkSynth, restart SuperCollider
//

SCLOrkSynths.gui;

// listen to synth (select and "play demo" in new window)

// copy code to current patch:
// press "show me code", switch to new tab, copy all from "SynthDef" to ".add;"
// make a region in current patch
// paste code inside region and execute it
// look in post window, must be "-> a SynthDef" there

(
SynthDef(\FMRhodes2, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1,
	//controls
	lfoSpeed = 2.4, inputLevel = 0.2, modIndex = 2, fmHarmonic = 30,
    // all of these range from 0 to 1
    mix = 0.2, lfoDepth = 0.75, lfoBottom = 0.15, lfoRange = 0.3;

    var env1, env2, env3, env4, range, bottom;
    var osc1, osc2, osc3, osc4, snd;

	bottom = lfoBottom.linlin(0, 1, 100, 12000);
	range = lfoRange.linlin(0, 1, bottom, 16000);

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * fmHarmonic) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;

    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = LPF.ar(snd, SinOsc.kr(lfoSpeed).range(bottom, range), lfoDepth) + (snd * (1 - lfoDepth));
    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;
)


(
SynthDef(\FMRhodes1, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1, lfoSpeed = 4.8, inputLevel = 0.2,
    // all of these range from 0 to 1
    modIndex = 0.2, mix = 0.2, lfoDepth = 0.1;

    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * 30) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
  	snd = snd * (SinOsc.ar(lfoSpeed).range((1 - lfoDepth), 1));

    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
},
metadata: (
	credit: "Nathan Ho",
	category: \keyboards,
	tags: [\pitched, \piano, \fm]
)
).add;
)

// lets make new sequencer

(
Pdef(
	\rodes_seq_lc,
	Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser([220, 330, 440, 880], 20),
		\dur, Pser([220, 330, 440, 880] / 880, 10),
	)
).play;
)


// modify \seq_rodes and play with two parts
//
// add \amp, \pan to rodes part

(
Pdef(
	\rodes_seq2_lc,
	Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser([220, 330, 440, 880], 20),
		\dur, Pser([220, 330, 440, 880] / 880, 10),
		\amp, 0.5,
		\pan, 1,
	)
).play;
)

//
// What others parameters we can control?


// Livecodind I
// выбирайте еще один синт
// делайте для него сексенсер
// управляйте 2-мя секвенциями вживую
// запись аудио: нижняя панель, там где Interpreter, правая кнопка -> Start Recording


// как работать
// ТЭМТП.doc :: Основные принципы работы

// как устроен язык программирования
// ТЭМТП.doc :: Программирование 1. Основные понятия :: Принципы работы компьютера (Computer principle)
// :: Алгоритм
// :: Из чего состоит язык программирования

// Отладка
// ТЭМТП.doc :: ошибки и как с ними подружиться
// faq.pdf :: Настройка, отладка патча (debugging) и возможные ошибки
// Poll


// linter
// try debug:
/*
(
Pdef(
	\seq1
	Pbind(
		\freq, 220,)
	)
).play(argClock: ~cklk1, quant: 4);
)
*/

// try lint it in Gemini, giga.chat


/////////////////////////////////////////
//
//       Массивы, списки
//

~midi_pitch1_arr = Array.newClear(10);
~midi_pitch1_arr;
~midi_pitch1_arr[0];
~midi_pitch1_arr[0] = 64;

// ~midi_pitch1_arr

1.class;
~midi_pitch2_arr = [];
~midi_pitch2_arr.class;
// ~x.isKindOf(Float);
/*
У многих базовых типов в SuperCollider есть встроенные быстрые методы для проверки:~x.isNumber — является ли числом.
*/


// List
~midi_pitch3_arr = List[1, 4, 6];
~midi_pitch3_arr.class;

~midi_pitch4_arr = (1..4); // (1, 3..10)
~midi_pitch4_arr = ~midi_pitch4_arr + 64;


~midi_pitch4_arr.reverse
~midi_pitch4_arr


~midi_pitch4_arr.scramble
~midi_pitch4_arr.scramble.midicps


// array + patterns

(
Pdef(
	\rodes_seq2_lc,
	Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser(~midi_pitch4_arr.scramble.midicps, inf),
		\dur, Pser([220, 330, 440, 880] / 880, inf),
		\amp, 0.5,
		\pan, 1,
	)
).play;
)

// set only at startup


//.rotate(n: 1)

~midi_pitch4_arr
~midi_pitch4_arr.rotate(2)


// Livecodind II
// для сетапа и предыдущего задания сделайте сет с использованием массивов и их изменений


// функция


// define
(
~change_midi_arr = {
	arg in_arr; // inputs
	var out_arr;
	out_arr = in_arr.scramble.rotate(2);
	out_arr; // output
};
)

// call
~changed_midi_arr = ~change_midi_arr.([1, 3, 4, 7, 8, 11] + 48);
~changed_midi_arr.postln;


// функция как синт

(
{
	SinOsc.ar();
}.play;
)

// to use in pattern
(
{
	SinOsc.ar();
}.asSynthDef(fadeTime: 0.1, name: \my_synth1).add;
)

(
Pbind(
	\instrument, \my_synth1
).play;
)

s.plotTree;

// ДЗ
// записать скрин livecoding сессии и выложить его


///////////////////////
//
// Different disributions patterns
//
// The histogram shows how often the values ​​appear

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // random equal continuous distribution

Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // random equal discrete distribution



/////////////////////////////////////////


// functions

// arrays (continue)

(
10.do({
	arg item;
	item.postln;
});
)

(
~midi_pitch4_arr.do({
	arg ...args_arr; // get all auto args
	args_arr.postln;
});
)


~midi_pitch4_arr.clipAt(0);
~midi_pitch4_arr.clipAt(-10);

~midi_pitch4_arr.wrapAt(9);
~midi_pitch4_arr.wrapAt(10);
~midi_pitch4_arr.wrapAt(11);

.foldAt(i)


.add(item)
Adds an item to the end of the List.

.addFirst(item)
Inserts the item at the beginning of the List.

.insert(index, item)

.pop
Remove and return the last element of the List.

.removeAt(index)
Remove and return the item at index, shrinking the size of the List.

.lace(length)