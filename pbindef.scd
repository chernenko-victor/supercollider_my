Pdefn хранит и меняет только одно конкретное свойство (например, только список нот). Чтобы собрать из них музыку, вам нужно вручную вставить несколько Pdefn внутрь обычного Pbind.

Pbindef — это целый музыкальный паттерн (как Pdef), в котором вы можете на ходу менять любую отдельную строчку напрямую, не перезаписывая весь остальной код.

Сравним


Способ через Pdefn (сборка из кирпичиков)Вам нужно сначала объявить кирпичики Pdefn, а потом соединить их внутри Pdef.

// 1. Создаем кирпичики
Pdefn(\myNotes, Pseq([0, 2, 4, 7], inf));
Pdefn(\myDur, 0.25);

// 2. Собираем их вместе
Pdef(\player, Pbind(\note, Pdefn(\myNotes), \dur, Pdefn(\myDur))).play;

// 3. Чтобы изменить ноты, меняем конкретный кирпичик
Pdefn(\myNotes, Pseq([7, 9, 11, 12], inf));



Способ через Pbindef (все ручки в одном месте)
Вы создаете одну структуру. После этого вы можете обращаться к её имени (\myTrack) и менять любой ключ (\note, \dur, \amp) точечно.


// 1. Создаем и сразу запускаем полноценный трек
Pbindef(\myTrack,
    \note, Pseq([0, 2, 4, 7], inf),
    \dur, 0.25,
    \amp, 0.2
).play;

// 2. ИЗМЕНЯЕМ ТОЛЬКО НОТЫ (ритм и громкость продолжают играть как раньше!):
Pbindef(\myTrack, \note, Pseq([7, 9, 11, 12], inf));

// 3. ИЗМЕНЯЕМ ТОЛЬКО РИТМ НА ЛЕТУ (ноты остаются новыми!):
Pbindef(\myTrack, \dur, Pseq([0.5, 0.25, 0.25], inf));


Еще пример
(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.01, sustain), 1, doneAction: Done.freeSelf);
    5.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1,1.2) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));
}).add;
)

Pbindef(\a, \instrument, \Pdefhelp).play;
Pbindef(\a, \degree, Pseq([0, 2, 5b, 1b], inf));
Pbindef(\a, \dur, 0.1);
Pbindef(\a, \degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
Pbindef(\a, \legato, Prand([1.0, 2.4, 0.2], inf), \mtranspose, -3);
Pbindef(\a, \mtranspose, nil); // remove key


Pbindef считается одним из самых удобных инструментов для живых выступлений (Live Coding). Вам больше не нужно копировать весь блок Pbind ради изменения одной цифры — вы просто пишете короткую строчку с нужным параметром, и музыка мгновенно меняется.