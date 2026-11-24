// TGrains


/*
(
~test1 = (4..8).collect({
	arg val, i;
	[val, i].postln;
	val + (i + 1 ** 1.02);
})
)
*/

s.boot;

(
// 1. МАТЕМАТИЧЕСКАЯ ГЕНЕРАЦИЯ (Фрактал Морса-Туэ)
// Эта функция генерирует самоподобную бинарную последовательность (0 и 1).
// Каждый шаг берет предыдущую строку и инвертирует её: [0] -> [0, 1] -> [0, 1, 1, 0] -> ...
~generateThueMorse = { |iterations = 5|
    var seq = [0];
    iterations.do {
        seq = seq ++ (1 - seq);
    };
    seq;
};

// Генерируем массив из 256 шагов (математически точный фрактал, никакого рандома!)
~fFractal = ~generateThueMorse.(8);

// Превращаем 0 и 1 в музыкальные длительности (0 = 1/8 ноты, 1 = 1/4 ноты)
~idmDurations = ~fFractal.collect({ |val| if(val == 0, { 0.125 }, { 0.25 }) });

// Превращаем 0 и 1 в глитч-команды для микса эффекта (0 = сухо, 1 = сильный глитч)
~glitchMixes = ~fFractal.collect({ |val| if(val == 0, { 0.1 }, { 0.85 }) });


// 2. СИНТЕЗАТОРЫ (оставляем шину и инструменты)
~glitchBus = Bus.audio(s, 2);

SynthDef(\idmPerc, { |out = 0, amp = 0.1, pan = 0, freq = 800, sustain = 0.05, noiseMix = 0.5|
    var env, sig, noise;
    env = EnvGen.ar(Env.perc(0.001, sustain, curve: -8), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, freq * 1.5, 0.3);
    sig = SinOsc.ar(freq) * (1 - noiseMix) + (noise * noiseMix);
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\glitchStutter, { |inBus = 0, outBus = 0, mix = 0.5, delayTime = 0.1|
    var input, dry, wet, feedback;
    input = In.ar(inBus, 2);
    dry = input;

    feedback = 0.75;

    // Делей теперь реагирует на строго заданное время задержки
    wet = CombC.ar(input, 0.5, delayTime.lag(0.05), feedback * 2);
    wet = wet * LFPulse.ar(12).range(0.3, 1.0);

    Out.ar(outBus, XFade2.ar(dry, wet, mix * 2 - 1));
}).add;
)


(
// 3. ЗАПУСК СТРУКТУРИРОВАННОГО ПАТТЕРНА
TempoClock.default.tempo = 150 / 60;

// Запускаем эффект
~effectNode = Synth(\glitchStutter, [\inBus, ~glitchBus, \outBus, 0, \mix, 0.2, \delayTime, 0.08], target: s, addAction: \addToTail);

// Перкуссионный паттерн
~percPattern = Pbind(
    \instrument, \idmPerc,
    \out, ~glitchBus,

    // РИТМ: Вместо случайности читаем наш фрактальный массив по кругу!
    \dur, Pseq(~idmDurations, inf),

    // ПИТЧ: Тоже привязываем к фракталу. Когда ритм ускоряется, частота идет вверх.
    \freq, Pseq(~fFractal, inf).collect({ |val| if(val == 0, { 2500 }, { 6000 }) }),

    \noiseMix, 0.6,
    \sustain, 0.03,
    \pan, Pseq([-0.5, 0.5, -0.2, 0.2], inf), // Геометрическое панорамирование
    \amp, 0.12
).play;

// УПРАВЛЕНИЕ ЭФФЕКТОМ ПО ФРАКТАЛУ
// Отдельный паттерн, который меняет параметры деления звука синхронно с ритмом
~macroPattern = Pbind(
    \type, \set, // Режим управления существующим синтезатором
    \id, ~effectNode,
    \dur, 0.25, // Каждую четверть ноты проверяем фрактал

    // Меняем глубину глитча строго по математической сетке
    \mix, Pseq(~glitchMixes, inf),

    // Меняем время задержки: 0 дает очень короткое заикание, 1 — длинный делей
    \delayTime, Pseq(~fFractal, inf).collect({ |val| if(val == 0, { 0.02 }, { 0.18 }) })
).play;
)

// ОСТАНОВИТЬ ВСЁ
(
~percPattern.stop;
~macroPattern.stop;
~effectNode.free;
)
