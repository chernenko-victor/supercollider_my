// https://drive.google.com/file/d/1pDN_A6RRTUMaGWHdsSrlzgxl278MaxZ3/view?usp=drive_link
// Справка по SuperCollider.pdf
// как запустить код. что делать, если нет звука и т.д.
// FAQ: start, stop, troubleshooting ...


// =========================================================
// ==========    Подготовка к работе (bootstrap)    ========
// =========================================================

// См. файл справки

// check sound
// выполните строку кода (см. в файле Help and Hotkeys)
Pbind().play;

// нет звука? См. trobleshooting (в конце файла)

// stop all sounds. Остановите процесс.



// ===========================================================
// ==========    Паттерн Pbind - генератор событий    ========
// ===========================================================


// управление частотой и ритмом
(
Pbind(
	\freq, 440,
	\dur, 0.25,
).play;
)

// меняем значения и запускаем: с каждым запуском добавляется
// новая партия
// и остановить их можно только вместе

// чтобы управлять партиями отдельно, надо каждый генератор партий сохранять под определенным именем, т.е. сохранить его в переменную

// имя переменной = значение
~num_parts = 3;

// имя переменной начинается с ~, далее можно использовать
// буквы, цифры и знак подчеркивания
// название лучше давать осмысленное, это будет
// автокомментированный код

// = обозначает объект, который значение справа от себя
// сохраняет в переменную слева от себя

// значение может быть почти чем угодно, в т.ч. генератором
// партии

(
~seq1 = Pbind(
	\freq, 440,
	\dur, 0.25,
).play;
)

(
~seq2 = Pbind(
	\freq, 880,
	\dur, 0.33,
	\amp, 0.2,
).play;
)

(
~seq3 = Pbind(
	\freq, 110,
	\dur, 1,
	\amp, 0.5,
).play;
)

// можно останавливать независимо
~seq1.stop;
~seq2.stop;
~seq3.stop;


// код
(
Pbind(
	\freq, 110,
	\dur, 1,
	\amp, 0.5,
)
// это "проект" звукового устройства
)

// результатом выполнения кода
(
~seq3 = Pbind(
	\freq, 110,
	\dur, 1,
	\amp, 0.5,
).play;
)
// становится экземпляр, построенный по "проекту"
// и сохраненный в переменную ~seq3

// код <экземпляр>.<действие> или <класс>.<действие>
// это как бы изменение элементов управления на железном
// синте.
~seq3.stop; // как нажатие кнопки выключения на секвенсере

// подробнее см. Объектно-ориентированное программирование в
// файле "Справка по SuperCollider"


// без ошибок не бывает программирования
// запустите код

(
Pdef(
	\seq1
	Pbind(
		\freq, 220,=
	)
).play(argClock: ~cklk1, quant: 4);
)

// Отладка кода (debugging)
// см. Настройка, отладка патча (debugging) и возможные ошибки
// в "Справка по SuperCollider"

// 1. попробуйте самомтоятельно найти ошибку
// 2. попробуйте ИИ: Gemini, giga.chat, etc



/////////////////////////////////////////
//
//       Массивы
//

~midi_pitch1_arr = [60, 61, 63, 65, 68];

~midi_pitch1_arr.postln; // выводит значение переменной в консоль
~midi_pitch1_arr[1].postln; // значение 2го элемента массива
// индекс первого элемента - 0

~duration2_arr = (1..4); // записывае в массив последовательность
~midi_pitch3_arr = (1, 3..10); // последоавтельность нечетных чисел
~midi_pitch3_arr = ~midi_pitch3_arr + 64; // прибавляет 64 к каждому элементу массива

///////////////////////////////////////
//
// Массивы в паттернах

// аккорды
(
~seq1 = Pbind(
	\freq, [220, 440, 660],
	\dur, 0.25,
).play;
)


///////////////////////////////////////
//
// Паттерны для последовательности событий

// Pser играет элементы из массива N раз
(
~seq1 = Pbind(
	\freq, Pser(~midi_pitch1_arr.midicps, 10),
	\dur, 0.25,
).play;
)
// midicps - преобразует midi pitch в частоту

// Pser(~midi_pitch1_arr.midicps, inf) для "бесконечной" работы

(
~seq2 = Pbind(
	\freq, Pser(~midi_pitch3_arr.midicps, inf),
	\dur, Pser(~duration2_arr, inf),
).play;
)



/////////////////////////////////////////
//
// установка раширений
// installation extensions (quarks)
//
// Main menu - Language - Quarks, in new window check SCLOrkSynth, restart SuperCollider
//

SCLOrkSynths.gui;

// слушаем и выбираем синт
// listen to synth (select and "play demo" in new window)

// копируем в патч и отправляем "проект синта" на "фабрику"
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

// lets make new sequencer

(
~seq2 = Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser(~midi_pitch3_arr.midicps, inf),
	    \dur, Pser(~duration2_arr, inf),
	).play;
)
~seq2.stop;

// добавьте значения для \amp, \pan

// какие еще параметры синта можно контролировать?


// преобразования массивов
~midi_pitch3_arr.postln;
~midi_pitch3_arr.reverse.postln; // массив в обратном порядке

~midi_pitch3_arr.scramble.postln; // перемешивает порядок элементов в массиве

~midi_pitch3_arr.rotate(2);

// но действует преобразование только в момент старта
(

~seq3 = Pbind(
		\instrument, \FMRhodes2,
		\freq, Pser(~midi_pitch3_arr.scramble.midicps, inf),
		\dur, Pser(~duration2_arr * 0.25, inf),
		\amp, 0.5,
		\pan, 1,
).play;
)

~seq3.stop;


// Prand([1, 2/3, 3/4, 4/5] * 220, inf) - случайный выбор элементов из массива


(

~seq3 = Pbind(
		\instrument, \FMRhodes2,
		\freq, Prand([1, 2/3, 3/4, 4/5] * 220, inf),
		\dur, Pser(~duration2_arr * 0.25, inf),
		\amp, 0.5,
		\pan, 1,
).play;
)

~seq3.stop;

// Livecodind I
// выбирайте еще один синт
// делайте для него сексенсер
// управляйте 2-мя секвенциями вживую
// запись аудио: нижняя панель, там где Interpreter, правая кнопка -> Start Recording

// replace \freq pattern to Prand([1, 2/3, 3/4, 4/5] * 220, inf)


// ========================================
// ==========    trobleshooting    ========
// ========================================

// ================
// wrong samplerate?
// Часто при подключении к звуковому устройству возникает
// ошибка с частотой дискретизации

// 1. see actual. Прооверьте, какая частота в Collider
s.sampleRate

// 2.1. Можно изменить на звуковом устройстве

// 2. Или в Collider.
// change SR
s.options.sampleRate = 44100;

// 3. reboot server. После изменений настройки надо перезагружать звуковой движок коллайдера
s.reboot;


// Может помочь смена звукового устройства

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


// подробнее в патче change_device.csd


// Иногда проблема вовсе не в Collider. Может быть вообще нет звука? Запустите любой звуковой файл, пройдите по всему тракту воспроизведения.