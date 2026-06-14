// 1. Включаем звуковой сервер (если еще не включен)
s.boot;

(
// 2. Создаем СВОЮ стерео-аудиошину на сервере
// (сразу освобождаем старый Ndef на всякий случай)
Ndef(\echo).clear;
~myBus = Bus.audio(s, 2);

// 3. Настраиваем Ndef-эффект.
// Теперь он жестко привязан к чтению из нашей созданной шины ~myBus.
Ndef(\echo, {
    // Читаем звук из нашей шины по её индексу
    var input = In.ar(~myBus.index, 2);

    // Эффект эха
    var delay = CombN.ar(
        input,
        maxdelaytime: 0.5,
        delaytime: 0.45,
        decaytime: 3.0
    );

    // Миксуем чистый звук и эхо
    (input * 0.6) + (delay * 0.4);
}).play; // Выводим обработанный звук на колонки

// 4. Создаем Pdef с мелодией
Pdef(\melody, Pbind(
    \dur, 0.5,
    \note, Pseq([60, 63, 65, 67, 65, 63], inf),
    \legato, 0.2,
    \amp, 0.2,

    // Направляем звук из Pbind строго в нашу шину
    \out, ~myBus.index
)).play;
)


Pdef(\melody).stop;
Ndef(\echo).stop;
~myBus.free;
