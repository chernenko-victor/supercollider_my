// synths definition
(
{
	arg freq, amp; // входы
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(0.7).range(0.99, 1.01)) +
	(SinOsc.ar(freq * 2 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 2) +
	(SinOsc.ar(freq * 3 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 3) +
	(SinOsc.ar(freq * 4 * LFNoise2.kr(0.7).range(0.99, 1.01)) / 4);
	sig = amp * sig / 4;
	[sig, sig]; // выход на 2 канала с помощью массива из 2-х элементов
	// collider сам правильно оформит выход с помощью послыла на выход звуковой карты
	// нам не нужно это делать в явном виде, так же как не надо делать Env с doneAction: 2 см. ниже что это
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_proto).add;
)

(
{
	SinOsc.ar(
		5 * LFNoise2.kr(2).range(0.5, 1.5) // frequency modulation
	);
}.scope(); // динамическое отображение формы волны
)

(
{
	SinOsc.ar(
		5 * LFNoise2.kr(2).range(0.5, 1.5) // frequency modulation
	);
}.plot(5); // можно строить форму волны генератора
)

~sin_sum1 = Synth(\sin_sum_proto, args: [\freq, (220 + 220.rand), \amp, 0.4]); // запуск эземпляра синта
~sin_sum1.release(); // корректное выключение с огибающей


===================================================
                     циклы (loops)
===================================================

// десять раз выполнить функцию
// функция передается в do как аргумент
// collider на каждом шаге передает внутрь функции разные параметры
// в данном случае это просто индекс
(
10.do({
	arg ...args_arr;
	args_arr.postln;
})
)

// чтобы не копировать гармоники вручную
(
{
	arg freq, amp;
	var sig = 0, harm_num = 10;

	harm_num.do({
	    arg ...args_arr;
	    // args_arr[0] содержит индекс
		sig =  sig + (
			SinOsc.ar(
				freq *
				(args_arr[0] + 1) *
				LFNoise2.kr(0.7).range(0.99, 1.01)
			) / (args_arr[0] + 1)
		);
    });

	sig = amp * sig / harm_num;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_loop__proto).add;
)

~sin_sum_loop1 = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);

~sin_sum_loop1.release(0.2);

// к сожалению, нельзя сделать harm_num параметром и создавать экземпляры с разным кол-вом обертонов

// вернее, можно, но ... см. ниже


(
~voice_num = rrand(1, 4); // кол-во голосов
~notes_arr = Array.newClear(~voice_num); // массив

~voice_num.do({
	arg ...args_arr;
	// сохраним экземпляры синтов в массив
	~notes_arr[args_arr[0]] = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
})
)

// выключим все экземплары
(
~voice_num.do({
	arg ...args_arr;
	~notes_arr[args_arr[0]].release(0.2);
})
)


//////////////////////////////////////////////////////

// "iterable" data types
//
// итерируемый типы данных - такие, которые можно обойти элемент за элементом
//

Характерный пример - массив (и его разновидность - список)

[1, 10, 100].class;     // Вернет: Array

List[1, 10, 100].class; // Вернет: List

Элементы можно перечислить внутри квадратных скобок через запятую.

~midi_notes_arr = [60, 62, 64, 58];

Или сделать пустой массив определенной длины ~midi_arr = Array.newClear(4);

Сохранить элемент в массив ~midi_arr[0] = 48;

Индексация элементов начинается с 0

Имя переменной в данном случае указывает на начало массива в памяти компьютера.

номер                                 Доступ к элементам
ячйеки                                массива
памяти
0          |_____________________|
1          |_____________________|
2          |_____________________|
3          |_________60__________|    ~midi_notes_arr[0]
4          |_________62__________|    ~midi_notes_arr[1]
5          |_________64__________|    ~midi_notes_arr[2]
6          |_________58__________|    ~midi_notes_arr[3]
7          |_____________________|
8          |_____________________|
............................................
............................................
............................................


// не надо добавлять элементы к созданному массиву
~arr1 = [1, 10, 100]; // в консоли [1, 10, 100]
~arr1.postln; // в консоли [1, 10, 100]
~arr1.add(1000); // в консоли [1, 10, 100, 1000]
~arr1.postln; // в консоли [1, 10, 100, 1000] Array увеличивается
~arr1.add(1000); // в консоли  [1, 10, 100, 1000, 1000]
~arr1.postln; // в консоли [1, 10, 100, 1000] Array теперь не увеличился


// arg ...args_arr;
// так пишут, чтобы все входные аргументы функции собрать в один массив.


(
~var_args_func = {
	arg ...args_arr;
	args_arr.postln;
};
)
~var_args_func.(1);
~var_args_func.(1, inf, -0.085, \put_it_to_arr);
~var_args_func.(1, inf, -0.085, ["lets", "send", "an", "array"]);

Можно использовать в функции переменное число аргументов.


Collider часто автоматически пересылает аргументы в функцию.

Например, метроном:
(
~clk1 = TempoClock(1);

~clk1.sched(0, {
	arg ...args_arr;
	args_arr[0].postln; // колладйер пересылает в функцию номер бита, абсолютное время и ссылку на экземпляр метронома каждый раз, когда срабатывает метод sched. Время следующего срабатывания задает число в последней строке функции.

	// на каждой 4 доле
	if(
		(args_arr[0] % 4) == 0.0,
		{

			~sin_sum_loop1 = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
		},
		{ // на другой доле выключим
			~sin_sum_loop1.release(0.2);
		}
	);

	// через 9 долей дадим аккорд
	if(
		args_arr[0] == 9,
		{
			~voice_num = rrand(1, 4);
			~notes_arr = Array.newClear(~voice_num);

			~voice_num.do({
				arg ...args_arr;
				// args_arr.postln;
				~notes_arr[args_arr[0]] = Synth(\sin_sum_loop__proto, args: [\freq, (220 + 220.rand), \amp, 0.4]);
			});
		}
	);

	// включим паттерн
	if(
		args_arr[0] == 7,
		{
			~bind1 = Pbind(
				\amp, 0.5,
			).play;
		}
	);

	// выключим паттерн
	if(
		args_arr[0] == 19,
		{
			~bind1.stop;
		}
	);

	// выключим всё остальное
	// и сам метроном
	if(
		args_arr[0] == 25,
		{
			~clk1.stop;
			(
				~voice_num.do({
					arg ...args_arr;
					~notes_arr[args_arr[0]].release(0.2);
				})
			);
		}
	);

	1;
});
)



// посмотрим, что передается в функцию при обходе массива
(
~arr1 = [1, 10, 100];

~arr1.do({
	arg ...args_arr;
	args_arr.postln;
})
)

(
5.do({ // число тоже iterable
	~arr1.add(100.rand).postln; // в консоли  [1, 10, 100, 1000, <random>]
	~arr1.postln; // в консоли [1, 10, 100, 1000] Array теперь не увеличился
})
)

Чтобы добавить элементов, надо использовать список

~list1 = List[1, 1.5, 3, Rest(1)];

(
5.do({
	var dur = (15.rand / 10) + 0.125;
	if(
		[false, false, true].choose,
		{dur = Rest(dur)}
	);
	~list1.add(dur).postln;
})
)

(
Pbindef(\test_list,
	\dur, Pser([1, 1.5, 3, Rest(1)], inf)
).play;
)

(
Pbindef(\test_list,
	\dur, Pser(~list1, inf)
);
)

Pbindef(\test_list).stop;


~list1.asArray.class;
~arr1.asList.class;



Индекс всегда целый
(
5.1.do({
	arg i;
	i.postln;
});
)

Если надо выполнять функцию с переменным шагом
forBy (0, 2, 0.5) { |value| value.postln };


Заполнение массива с помощью функции
(
~midi_seq_arr = Array.fill(10, {
	arg i;
	i*2 + 60;
});
)

(
Pdef(
	\add_synth_percussion__play,
	Pbind(
		\instrument, \var_saw_proto,
		\midinote, Pseq(~midi_seq_arr, 1),
	)
).quant_(1).play;
)


Переменное число обертонов. Можно сделать, но код получается не слишком понятным.

(
{
	arg
	  freq = 440,
	  amp = 0.2,
	  freqs_ratio_arr = #[1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // #[1, 2, 3, 4] - фиксированный массив: сервер должен заранее знать длину массива
	;
	var sig = 0;

	freqs_ratio_arr.do({
	    // arg ...args_arr; // не работает в синте, массивы должны быть фиксированной длины
		arg ratio; // берем только значение
		/*
		// не работает в синте
		if(
			args_arr[0] > 0,
			{	nil; }
		);
		*/
		var is_positive = ratio > 0; // а это работает ))


		sig =  sig + ((
					SinOsc.ar(
						freq *
						(ratio + 1) *
						LFNoise2.kr(0.7).range(0.99, 1.01)
					) / (ratio + 1)
		) * is_positive); // Если ratio <= 0, сигнал умножится на 0 и сотрется
    });

	sig = amp * sig / freqs_ratio_arr.size;
	[sig, sig];
}.asSynthDef(fadeTime: 0.1, name: \sin_sum_loop_var__proto).add;
)

FreqScope.new;

~my_saw = Synth(\sin_sum_loop_var__proto);
~my_saw.release();


(
~my_square = Synth(\sin_sum_loop_var__proto, args: [
	\freqs_ratio_arr, [1, 3, 5, 7, 9, 11]
]);
)
~my_square.release();


(
~non_harm_arr = Array.fill(7, {
	arg i;
	i + 1 + (rrand(0, 10) / 15);
});
)

(
~my_drone = Synth(\sin_sum_loop_var__proto, args: [
	\freqs_ratio_arr, ~non_harm_arr
]);
)



~my_drone.set(\amp, 0.7);
~my_drone.set(\freq, rrand(1, 12) / rrand(2, 5) * 110);
~my_drone.release();



=====================================================

Субстрактивный синтез
(
{
	arg freq = 440, amp = 0.2;
	10* Mix.fill(5, {
		arg i;
		Resonz.ar(
			WhiteNoise.ar(0.1),
			freq * (i + 1),
			bwr: 0.01,
		)
	}) * amp;
}.asSynthDef(fadeTime: 0.3, name: \substr_example__proto).add;
)

~substr_example1 = Synth(\substr_example__proto);
~substr_example1.release();


Pbindef(\substr_example__play).clear;
(
Pbindef(
	\substr_example__play,
	\instrument, \substr_example__proto,
	\midinote, Pseq(~midi_seq_arr, inf),
	\amp, Pwhite(0.2, 0.7, inf),

).quant_(1).play;
)

(
Pbindef(
	\substr_example__play,
	\midinote,
	Pfunc({
			~midi_seq_arr.choose;
		})
)
)

Pbindef(\substr_example__play).stop;


// посмтрим, сколько раз повторяют те или другие ноты
{~midi_seq_arr.choose}.dup(1000).histo.plot;



===================================================
          Различные случайные распределения
===================================================


функция совмещения графиков:
(
~plot_2_graph = {
	arg data1_arr, data2_arr;

	var combinedData = [data1_arr, data2_arr];
	var plotter = combinedData.plot("Сравнение роста функций");
	plotter.superpose = true;
	plotter.plotColor = [Color.blue, Color.red];
	plotter.refresh;
}
)


// Гистограмма показывает частотность появления элементов

Pwhite(0, 7, inf).asStream.nextN(1000).histo.plot; // равномерное доскретное распределение

(
~plot_2_graph.(
	Pwhite(0, 7, inf).asStream.nextN(1000).histo,
	Pwhite(0, 7, inf).asStream.nextN(1000).histo
);
)

Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo.plot; // равномерное непрерыное распределение

(
~plot_2_graph.(
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo,
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo
);
)


Prand([1, 2, 4, 8], inf).asStream.nextN(1000).histo.plot; // равномерное дискретное распределение


// линейное распределение
Plprand(0, 7, inf).asStream.nextN(1000).histo.plot;


(
~plot_2_graph.(
	Pwhite(0, 7, inf).asStream.nextN(1000).histo,
	Phprand(0, 7, inf).asStream.nextN(1000).histo
);
)


Phprand(0, 7, inf).asStream.nextN(1000).histo.plot;


// Разные формы распределения используются для создания контраста между частями музыкальной формы
//
// part A
(
Pbind(
	\degree, Phprand(1, 10, inf).trace,
).play;
)

// part B
(
Pbind(
	\degree, Plprand(1, 10, inf).trace,
).play;
)


// gaussian (normal) distribution
// гауссовское (нормальное) распределение
Pgauss(4, 1, inf).asStream.nextN(1000).histo.plot;


(
~plot_2_graph.(
	Pwhite(0.0, 7.0, inf).asStream.nextN(1000).histo,
	Pgauss(4, 1, inf).asStream.nextN(1000).histo
);
)

// экпоненциальное непрерывное распределение
Pexprand(0.01, 7.0, inf).asStream.nextN(1000).histo.plot;


Pgbrown(0.01, 7.0, 0.05, inf).asStream.nextN(1000).histo.plot(discrete: true); // распределение, похожее на броуновское движение


// цифровые методы для генерации массивов случаных чисел
{1.0.linrand }.dup(10000).histo(1000).plot(discrete: true); // function repeats 10000 times, linear distribution

// метод {function}.dup(N) повторяет N раз функцию и результаты добавляет в массив

{1.0.bilinrand }.dup(10000).histo(1000).plot(discrete: true); //треугольное распределение можно использовать как аналог гауссовского



==============================================
               Огибающие (Envelopes)
==============================================



(
Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).test;
)

(
Env.perc(
	).plot;
)

(
Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 5
	).plot;
)

// чтобы использовать в синте, надо запустить огибающую с помощью метода kr()
//
(
{
	arg attk = 0.05, rel = 0.1;
	WhiteNoise.ar(0.1) * Env.perc(
		attackTime: attk,
		releaseTime: rel
	).kr(doneAction: 2); // kr(doneAction: 2) удаляет экземпляр синта из памяти, что позволяет использовать синт в паттернах
}.asSynthDef(name: \noise__proto).add; // теперь не надо задавать fadeTime
)

s.plotTree;

Synth(\noise__proto, args: [\attk, rrand(0.05, 0.2), \rel, 1]);


// огибающую можно использовать для модуляции любых параметров
(
{
	arg attk = 0.05, rel = 0.1;
	var env_amp = Env.perc(
		attackTime: attk,
		releaseTime: rel
	).kr(doneAction: 2);
	SinOsc.ar(440 * env_amp) * env_amp; // kr(doneAction: 2) turns Envelope on and off correctly
}.asSynthDef(name: \sin_var__proto).add; // no need for fadeTime
)

Synth(\sin_var__proto, args: [\attk, rrand(0.05, 0.1), \rel, 1]);


// форма волны синта с огибающей
(
{
	arg attk = 0.05, rel = 0.1;
	WhiteNoise.ar(0.1) * Env.perc(
		attackTime: attk,
		releaseTime: rel
	).kr(doneAction: 2);
}.plot(0.2);
)


(
Pbindef(
	 \noise_seq,
		\instrument, \noise__proto,
		\dur, 0.25,
		\attk, Pwhite(0.01, 0.1, inf),
	).play;
)

(
// change attack by sinus
~clck1 = TempoClock.new(1);

Pbindef(
	\noise_seq,
	\attk, Pfunc({
		sin(~clck1.beats).linlin(-1, 1, 0.01, 0.1);
	})
).play;
)

(
Pbindef(\noise_seq).stop;
~clck1.stop;
)


Масштабирование
(
Pbindef(\scale_seq,
	\freq, Pser([1, 2, 3, 4], inf).linlin(1, 4, 440, 880).trace,
).play;
)


Pbindef(\scale_seq).stop;
/*
.linlin(inMin, inMax, outMin, outMax, clip: 'minmax')
.linexp(inMin, inMax, outMin, outMax, clip: 'minmax')
.explin(inMin, inMax, outMin, outMax, clip: 'minmax')
.expexp(inMin, inMax, outMin, outMax, clip: 'minmax')
*/


// gate start-stop
// управление длительностью в стиле MIDI

(
{
	arg gate = 1, freq = 440;
	var feedback_mod = LFNoise2.kr(1) * 1.9;
	SinOscFB.ar(freq, 0.1 * 2 * 3.14 * feedback_mod) * 0.2 *
	Env.adsr(
		attackTime: 0.1,
		releaseTime: 0.1,
		curve: 3.0
	).kr(doneAction: 2, gate: gate);
}.asSynthDef(name: \fb_sin_adsr__proto).add;
)

~fb_sin_adsr__proto = Synth(\fb_sin_adsr__proto); // start
~fb_sin_adsr__proto.set(\freq, 220); // change
~fb_sin_adsr__proto.set(\freq, 880);


~fb_sin_adsr__proto.set(\gate, 0); // stop
// ~fb_sin_adsr__proto.release(); // аналогично


Самостоятельная работа:
1. сделайте субстрактивный синт на основе шума с использованием полосовых фильтров, амплитудной огибающей adsr. Также огибающая должна менять cutoff финального low-pass фильтр.
2. Напишите пьесу на 2-3 минтты с субстрактивным синтом и любым другим на выбор. Создать контраст между частями с использованием различных случаных распределений. Запуск измеенений с помощью TempoClock.sched