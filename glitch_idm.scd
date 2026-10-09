(
// 1. СИНТЕЗАТОРЫ (ИНСТРУМЕНТЫ)

// Глитч-перкуссия (Клик / Капля / Хай-хэт)
SynthDef(\idmPerc, { |out = 0, amp = 0.1, pan = 0, freq = 800, sustain = 0.05, noiseMix = 0.5|
    var env, sig, noise;
    env = EnvGen.ar(Env.perc(0.001, sustain, curve: -8), doneAction: 2);

    // Смешиваем чистый тон и отфильтрованный белый шум
    noise = BPF.ar(WhiteNoise.ar, freq * 1.5, 0.3);
    sig = SinOsc.ar(freq) * (1 - noiseMix) + (noise * noiseMix);

    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// Глубокий синусоидальный бас (Суб-бас)
SynthDef(\idmBass, { |out = 0, amp = 0.2, freq = 50, sustain = 0.3, pan = 0|
    var env, sig;
    env = EnvGen.ar(Env.perc(0.01, sustain, curve: -4), doneAction: 2);
    sig = SinOsc.ar(freq) + SinOsc.ar(freq * 2, 0, 0.2); // Немного гармоник
    sig = sig.tanh; // Мягкое насыщение (сатурация)
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
// 2. ГЕНЕРАТИВНАЯ ЛОГИКА (ПАТТЕРНЫ)

// Задаем темп (например, 140 BPM)
TempoClock.default.tempo = 140 / 60;

// Паттерн для глитч-перкуссии
Pbind(
    \instrument, \idmPerc,
    // Микротайминг: случайные длительности шагов создают ломаный IDM-ритм
    \dur, Pseq([
        Prand([0.125, 0.25], 4), // Быстрые глитчи
        Pseq([0.125, 0.125], 1),
        Prand([0.5, 0.25], 2)    // Сбивки
    ], inf),
    // Прыгающие частоты в верхнем регистре
    \freq, Pwhite(1000, 8000),
    // Случайное соотношение синуса и шума для каждого клика
    \noiseMix, Pwhite(0.2, 0.9),
    \sustain, Pwhite(0.01, 0.08),
    // Панорама: звуки прыгают из левого уха в правое
    \pan, Pwhite(-0.8, 0.8),
    \amp, Pexprand(0.03, 0.15)
).play;

// Паттерн для баса (держит структуру)
Pbind(
    \instrument, \idmBass,
    \dur, Pseq([0.75, 0.25, 0.5, 0.5, 1.0, 1.0], inf), // Синкопированный ритм
    \freq, Pseq([50, 50, 60, 45, 55, 40], inf),
    \sustain, Pwhite(0.1, 0.4),
    \amp, 0.25,
    \pan, 0
).play;
)
