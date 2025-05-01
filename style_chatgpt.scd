// Запуск аудио сервера
s.boot;
// Определение романтической части
(
SynthDef(\romanticPart, {
    arg out = 0, freq = 440, amp = 0.3, duration = 3, pan = 0;

    var sound, env;
    // Генерация звука с синусоидальным осциллятором
    sound = SinOsc.ar(freq) * amp;
    // Применение огибающей
    env = EnvGen.ar(Env.perc(0.1, duration, 1, -4), 1);

    // Стерео пановка
    sound = Pan2.ar(sound, pan);
    // Выход на стерео выход
    Out.ar(out, sound * env);
}).add;
)
// Определение дисгармоничной части
(
SynthDef(\dissonantPart, {
    arg out = 0, freq = 300, amp = 0.2, duration = 2;

    var sound, env, noise;
    // Использование белого шума для создания дисгармонии
    noise = WhiteNoise.ar(amp);

    // Генерация случайных частот с нестандартной синусоидой
    sound = SinOsc.ar(freq + Rand(-200, 200)) * 0.5;
    // Комбинирование шума и синусоидального звука
    sound = sound + noise;
    // Применение огибающей
    env = EnvGen.ar(Env.perc(0.01, duration, 1, -4), 1);

    // Выход на стерео выход
    Out.ar(out, sound * env);
}).add;
)
// Функция для воспроизведения романтической части
~playRomantic = {
    var freq;
    freq = 440; // Основная частота (ля)

    // Создаем 4 ноты с различными панорамами и длительностями
    4.do { |i|
        var pan = (i * 0.5 - 0.75); // Панорама для каждой ноты
        Synth(\romanticPart, [
            \freq, freq + (i * 50), // Степенная частота (ля, до#, ре, ми)
            \amp, 0.3,
            \duration, 3,
            \pan, pan
        ]);
        3.wait; // Задержка между нотами
    };
};
// Функция для воспроизведения дисгармоничной части
~playDissonant = {
    var freq;
    freq = 300; // Основная частота (до)
    // Создаем 8 дисгармоничных звуков
    8.do {
        Synth(\dissonantPart, [
            \freq, freq + Rand(-300, 300), // Случайные частоты
            \amp, 0.2,
            \duration, 2
        ]);
        1.wait; // Задержка между звуками
    };
};
// Запуск произведения
~playRomantic.value; // Воспроизводим романтическую часть
10.wait; // Ждем, пока первая часть закончится
~playDissonant.value; // Воспроизводим дисгармоничную часть