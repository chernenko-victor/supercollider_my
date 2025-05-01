// Запуск аудио сервера
s.boot;
// Определение синтезатора
(
SynthDef(\randomSynth, {
    arg out = 0, freq = 440, amp = 0.5, duration = 1;
    var sound, envelope;
    // Генерация звука с синусоидальным осциллятором
    sound = SinOsc.ar(freq) * amp;
    // Применение огибающей
    envelope = EnvGen.ar(Env.perc(0.01, duration, 1, -4), 1, doneAction: 2);

    // Выход на стерео выход
    Out.ar(out, sound * envelope);
}).add;
)
// Функция для запуска синтезатора
~playRandomSynth = {
    var freq, waitTime;
    // Генерация частоты (гауссово распределение: среднее 440 Гц, стандартное отклонение 50 Гц)
    freq = GUI.Random.nextGaussian(440, 50);

    // Генерация случайного времени ожидания (от 0.5 до 2 секунд)
    waitTime = 0.5 + (0.5 * GUI.Random.nextGaussian(1, 0.5));
    // Запуск синтезатора
    Synth(\randomSynth, [
        \freq, freq,
        \amp, 0.5,
        \duration, 1
    ]);
    // Задержка перед следующим запуском
    waitTime.wait;
    // Повторение в случае необходимости
    ~playRandomSynth.value;
};
// Запуск функции
~playRandomSynth.value;