(
// 1. ПОДГОТОВКА АУДИО-ШИНЫ
// Создаем стерео-шину, через которую пустим синтезаторы в эффект-процессор
~glitchBus = Bus.audio(s, 2);

// 2. СИНТЕЗАТОРЫ (ИНСТРУМЕНТЫ)

SynthDef(\idmPerc, { |out = 0, amp = 0.1, pan = 0, freq = 800, sustain = 0.05, noiseMix = 0.5|
    var env, sig, noise;
    env = EnvGen.ar(Env.perc(0.001, sustain, curve: -8), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, freq * 1.5, 0.3);
    sig = SinOsc.ar(freq) * (1 - noiseMix) + (noise * noiseMix);
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\idmBass, { |out = 0, amp = 0.2, freq = 50, sustain = 0.3, pan = 0|
    var env, sig;
    env = EnvGen.ar(Env.perc(0.01, sustain, curve: -4), doneAction: 2);
    sig = SinOsc.ar(freq) + SinOsc.ar(freq * 2, 0, 0.2);
    sig = sig.tanh;
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;


// 3. ЭФФЕКТ-ПРОЦЕССОР (GLITCH / STUTTER / DELAY)
SynthDef(\glitchStutter, { |inBus = 0, outBus = 0, mix = 0.5|
    var input, dry, wet, delayTime, feedback, glitchTrigger, loopLength;

    input = In.ar(inBus, 2); // Читаем стереосигнал из шины
    dry = input;

    // Глитч-триггер: генерирует случайные импульсы (как часто будет срабатывать заикание)
    glitchTrigger = Dust.kr(3);

    // В момент триггера случайным образом выбирается длина петли заикания (от 20мс до 200мс)
    loopLength = TRand.kr(0.02, 0.2, glitchTrigger);

    // Случайное время задержки, которое прыгает по команде триггера
    delayTime = Latch.kr(TRand.kr(0.01, 0.25, glitchTrigger), glitchTrigger);

    // Плавное хаотичное блуждание задержки между триггерами для эффекта "пленки"
    delayTime = delayTime + LFNoise1.kr(2).range(-0.005, 0.005);

    // Фидбек (обратная связь) — затухание хвостов
    feedback = LFNoise1.kr(0.5).range(0.4, 0.85);

    // Сам модуль задержки с обратной связью
    wet = CombC.ar(
        input,
        maxdelaytime: 0.5,
        delaytime: delayTime,
        decaytime: feedback * 2
    );

    // Дополнительное экстремальное "заикание" через модуляцию амплитуды хвостов
    wet = wet * LFPulse.ar(TRand.kr(4, 20, glitchTrigger)).range(0.2, 1.0);

    // Смешиваем чистый (dry) и обработанный (wet) сигналы
    Out.ar(outBus, XFade2.ar(dry, wet, mix * 2 - 1));
}).add;
)


(
// 4. ЗАПУСК И УПРАВЛЕНИЕ

TempoClock.default.tempo = 145 / 60;

// ВАЖНО: Эффект должен быть запущен ПОСЛЕ инструментов в цепочке сервера,
// поэтому используем target: s и addAction: \addToTail
~effectNode = Synth(\glitchStutter, [\inBus, ~glitchBus, \outBus, 0, \mix, 0.6], target: s, addAction: \addToTail);

// Перкуссия (отправляем в ~glitchBus вместо 0)
~percPattern = Pbind(
    \instrument, \idmPerc,
    \out, ~glitchBus,
    \dur, Pseq([
        Prand([0.125, 0.25], 4),
        Pseq([0.125, 0.125], 1),
        Prand([0.5, 0.25], 2)
    ], inf),
    \freq, Pwhite(1200, 9000),
    \noiseMix, Pwhite(0.4, 0.95),
    \sustain, Pwhite(0.005, 0.05),
    \pan, Pwhite(-0.7, 0.7),
    \amp, Pexprand(0.05, 0.18)
).play;

// Бас (отправляем напрямую в 0, чтобы он оставался четким и не ломался делеем, либо в ~glitchBus для полного хаоса)
~bassPattern = Pbind(
    \instrument, \idmBass,
    \out, 0, // Бас идет напрямую в динамики
    \dur, Pseq([0.75, 0.25, 0.5, 0.5, 1.0, 1.0], inf),
    \freq, Pseq([50, 50, 60, 50, 45, 55], inf),
    \sustain, Pwhite(0.15, 0.35),
    \amp, 0.22
).play;
)

// Изменить количество эффекта "на лету" (0.0 — только чистый звук, 1.0 — сплошной глитч)
~effectNode.set(\mix, 0.7);
~effectNode.set(\mix, 0.3);

// ОСТАНОВИТЬ ВСЁ
(
~percPattern.stop;
~bassPattern.stop;
~effectNode.free;
)
