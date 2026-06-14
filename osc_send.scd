(
// Создаем цепочку из двух действий с помощью оператора <>
p = (
    // Этот паттерн отвечает ТОЛЬКО за отправку OSC в TouchDesigner
    Pbind(
        \type, \osc,            // Говорим, что тип события — отправка OSC
        \dest, ~tdAddress,      // Указываем наш сетевой адрес назначения
        \path, '/sc/note',       // Путь, который появится в TouchDesigner

        // Передаем текущую ноту. Метод Pkey(\note) берет значение из соседнего Pbind
        \msg, [Pkey(\note)]
    )
    <>
    // Наша обычная музыкальная мелодия
    Pbind(
        \dur, 0.25,
        \note, Pseq(, inf),
        \amp, 0.2
    )
).play;
)

// Остановить отправку и музыку
p.stop;


//////////////////////

Аудиосервер SuperCollider не умеет сам формировать произвольные OSC-пакеты для стороннего софта.Решение этой задачи выглядит как конвейер из трех шагов:Внутри SynthDef модуль SendReply.kr отправляет данные с сервера на клиент (в язык) [см. выше].На клиенте эти данные перехватывает OSCdef [см. выше].Внутри функции OSCdef мы пересылаем эти данные дальше в TouchDesigner с помощью NetAddr.sendMsg [см. выше].


// 1. Настраиваем адрес TouchDesigner (порт 7000)
~tdAddress = NetAddr("127.0.0.1", 7000);

(
// 2. Создаем SynthDef, который генерирует и анализирует звук
SynthDef(\multiSignalSender, {
    // Для примера создадим синт с меняющейся частотой
    var freqSignal = LFNoise1.kr(2).exprange(200, 800);
    var ampSignal = LFNoise0.kr(4).range(0.05, 0.4);
    var sound = SinOsc.ar(freqSignal) * ampSignal;

    // Таймер отправки данных (30 раз в секунду — стандарт для плавной графики)
    var sendTrigger = Impulse.kr(30);

    // ВАЖНО: Передаем ОБА сигнала в виде массива внутри квадратных скобок [ ]
    SendReply.kr(sendTrigger, '/to_client_multi', [ampSignal, freqSignal]);

    // Выводим звук в колонки
    Out.ar(0, sound ! 2);
}).add;

// 3. Создаем OSCdef-мост для пересылки нескольких параметров
OSCdef(\oscMultiBridge, { |msg|
    // msg[0] - адрес '/to_client_multi'
    // msg[1] - ID синта
    // msg[2] - ID команды
    // msg[3] - Первый элемент нашего массива (Громкость)
    // msg[4] - Второй элемент нашего массива (Частота)
    var currentAmp = msg[3];
    var currentFreq = msg[4];

    // Отправляем все данные в TouchDesigner одним пакетом.
    // Первым аргументом идет общий путь, затем через запятую все переменные.
    ~tdAddress.sendMsg('/sc/signals', currentAmp, currentFreq);

}, '/to_client_multi');
)

// 4. ЗАПУСК: Звук играет, а данные летят в TouchDesigner
~multiSender = Synth(\multiSignalSender);


// 5. ОСТАНОВКА
~multiSender.free;
OSCdef(\oscMultiBridge).free;




Отправка только при изменениях (Changed.kr)Если ваш параметр (например, частота или громкость) замер на месте, нет никакого смысла отправлять одни и те же цифры 30 раз в секунду. Можно настроить триггер так, чтобы он срабатывал только в момент реального изменения данных.Для этого в SuperCollider используется модуль Changed.kr:


(
SynthDef(\optimizedSender, {
    // Сигнал, который меняется редко или ступенчато
    var dataSignal = LFNoise0.kr(2).range(0.0, 1.0);

    // Changed.kr выдаст триггер (единицу) ТОЛЬКО в ту миллисекунду,
    // когда значение dataSignal изменилось по сравнению с прошлым кадром
    var changeTrigger = Changed.kr(dataSignal);

    // SendReply сработает только тогда, когда число реально поменялось
    SendReply.kr(changeTrigger, '/optimized_data', [dataSignal]);
}).add;
)


Модуль Trig1.kr отлично подходит для отслеживания резких пиков звука (например, ударов бочки или малого барабана). Его главная задача — поймать момент, когда звук резко стал громким, и выдать ровный одиночный импульс (триггер) фиксированной длины.



Если не использовать Trig1, то в момент удара барабана уровень звука будет хаотично прыгать выше порога несколько миллисекунд подряд. Из-за этого сервер отправит в сеть целую очередь ложных OSC-сообщений на один удар. Trig1 «замораживает» триггер и спасает от этого бага.Вот рабочий пример детектора ударов (Onset Detector), который отправляет сигнал в TouchDesigner строго один раз на каждый удар барабана:

// 1. Указываем адрес TouchDesigner
~tdAddress = NetAddr("127.0.0.1", 7000);

(
// 2. Создаем SynthDef для отслеживания пиков
SynthDef(\beatDetector, { |threshold = 0.5|
    // Для теста имитируем удары бочки (короткие громкие вспышки синуса 4 раза в секунду)
    var kickImitation = SinOsc.ar(60) * EnvGen.kr(Env.perc(0.01, 0.1), Impulse.kr(4)) * 0.8;

    // Шаг 1: Быстро измеряем амплитуду (атака 0.01 сек, спад 0.05 сек)
    var amp = Amplitude.kr(kickImitation, attackTime: 0.01, releaseTime: 0.05);

    // Шаг 2: Проверяем, превысил ли звук наш порог (threshold)
    var peakDetected = amp > threshold;

    // Шаг 3: ЗАЩИТА ОТ ДРЕБЕЗГА (Модуль Trig1).
    // Как только peakDetected станет равен 1, Trig1 выдаст ровную единицу
    // и будет УДЕРЖИВАТЬ её ровно 0.15 секунды, игнорируя любые другие колебания.
    var cleanTrigger = Trig1.kr(peakDetected, duration: 0.15);

    // Шаг 4: Отслеживаем только момент САМОГО НАЧАЛА этого импульса
    var finalSendTrigger = Changed.kr(cleanTrigger) * cleanTrigger;

    // Отправляем чистый сигнал на клиент
    SendReply.kr(finalSendTrigger, '/sc/kick');

    // Выводим тестовый звук бочки, чтобы слышать, что мы ловим
    Out.ar(0, kickImitation ! 2);
}).add;

// 3. Создаем OSCdef-мост для TouchDesigner
OSCdef(\kickBridge, {
    // Нам не нужно само значение амплитуды, важен сам факт удара.
    // Шлем в TouchDesigner просто единицу (сигнал "БАХ!")
    ~tdAddress.sendMsg('/td/kick', 1);
    "--- БОЧКА! ---".postln;
}, '/sc/kick');
)

// 4. ЗАПУСК: Слушаем ритм и отправляем сигналы
~detector = Synth(\beatDetector, [\threshold, 0.4]);


// 5. ОСТАНОВКА
~detector.free;
OSCdef(\kickBridge).free;
