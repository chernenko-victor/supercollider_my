// Запуск аудио сервера
s.boot;
// Определение аддитивного синтезатора
(
SynthDef(\additiveSynthesis, {
    arg out = 0, freq = 440, amp = 0.5, numHarmonics = 5, duration = 2;

    var signals, freqs, amps, envelope, sound;

    // Создаем массив частот и амплитуд для гармоник
    freqs = (1..numHarmonics).collect { |i| freq * i }; // Частоты гармоник
    amps = (1..numHarmonics).collect { |i| amp / i }; // Амплитуды (уменьшаем для верхних гармоник)

    // Генерация гармоник
    signals = freqs.collect { |f| SinOsc.ar(f) * amps; };

    // Суммируем сигналы
    sound = signals.sum;
    // Применение огибающей
    envelope = EnvGen.ar(Env.perc(0.01, duration, 1, -4), 1, doneAction: 2);

    // Выход на стерео выход
    Out.ar(out, sound * envelope);
}).add;
)
// Создание синтезатора
~synth = Synth(\additiveSynthesis, [
    \freq, 440,       // Основная частота
    \amp, 0.5,        // Громкость
    \numHarmonics, 10, // Количество гармоник
    \duration, 2      // Длительность звука
]);
// Остановка синтеза через 2 секунды
2.wait;
~synth.free;


(
var signals, freqs, amps, envelope, sound, out = 0, freq = 440, amp = 0.5, numHarmonics = 5, duration = 2;
freqs = (1..numHarmonics).collect { |i| freq * i }; // Частоты гармоник
    amps = (1..numHarmonics).collect { |i| amp / i }; // Амплитуды (уменьшаем для верхних гармоник)

    // Генерация гармоник
    signals = freqs.collect { |f| SinOsc.ar(f) * amps; };
    sound = signals.sum;
    envelope = EnvGen.ar(Env.perc(0.01, duration, 1, -4), 1, doneAction: 2);
Out.ar(out, sound * envelope);
)
