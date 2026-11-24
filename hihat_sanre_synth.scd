Pbind().play;

(
{ClipNoise.kr()}.plot(1);
)

(
{ClipNoise.ar() * 0.2}.play;
)


(
{WhiteNoise.kr()}.plot(1);
)

(
{WhiteNoise.ar() * 0.2}.play(1);
)

FreqScope.new;


s.boot;

// ==========================================
// 1. СИНТЕЗ ХЭТА (Hi-Hat)
// ==========================================

// Вариант А: Классический, мягкий хэт
(
x = {

    |amp = 0.2|
    var noise, env;
    env = EnvGen.ar(Env.perc(0.001, 0.05), doneAction: 2);
    noise = WhiteNoise.ar(amp);
    // Фильтруем низ, оставляем только металлический верх
    HPF.ar(noise, 7000) * env;
}.play(args: [\amp, 1]);
)

(
// Вариант Б: Грязный, резкий, "электронный" хэт
y = {

    |amp = 0.2|
    var noise, env;
    env = EnvGen.ar(Env.perc(0.001, 0.05), doneAction: 2);
    noise = ClipNoise.ar(amp); // Меняем на ClipNoise
    HPF.ar(noise, 7000) * env;
}.play(args: [\amp, 1]);
)

// ==========================================
// 2. СИНТЕЗ МАЛОГО БАРАБАНА (Snare)
// ==========================================

// Вариант А: Обычный электронный малый барабан
(
x = {

    |amp = 0.2|
    var osc, noise, envOsc, envNoise, mix;
    // Тональный удар (пластик)
    envOsc = EnvGen.ar(Env.perc(0.005, 0.1));
    osc = SinOsc.ar(XLine.kr(180, 100, 0.02)) * envOsc;
    // Шумовой хвост (пружина)
    envNoise = EnvGen.ar(Env.perc(0.01, 0.2), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar(amp), 1500, 0.5) * envNoise;

    (osc + noise) ! 2;
}.play;
)

// Вариант Б: Агрессивный Snare с мощной пробивной пружиной
(
y = {

    |amp = 0.2|
    var osc, noise, envOsc, envNoise, mix;
    envOsc = EnvGen.ar(Env.perc(0.005, 0.1));
    osc = SinOsc.ar(XLine.kr(180, 100, 0.02)) * envOsc;

    envNoise = EnvGen.ar(Env.perc(0.01, 0.2), doneAction: 2);
    // ClipNoise дает ощущение, что барабан записан "в красный сектор" пульта
    noise = BPF.ar(ClipNoise.ar(amp), 1500, 0.5) * envNoise;

    (osc + noise) ! 2;
}.play;
)