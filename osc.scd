
Для каждого пути своя функция

// 1. Слушатель ТОЛЬКО для высоты тона первого синтезатора
OSCdef(\pitchListener, { |msg|
    var pitchValue = msg[3]; // Берем полезные данные
    defer { 
        "Синтезатор 1 сменил ноту на: %".format(pitchValue).postln;
        // Здесь ваш код для изменения паттерна или графики
    };
}, '/synth1/pitch'); // Жестко привязан к этому пути


// 2. Слушатель ТОЛЬКО для громкости второго синтезатора
OSCdef(\ampListener, { |msg|
    var ampValue = msg[3]; // Берем полезные данные
    defer { 
        "Синтезатор 2 сменил громкость на: %".format(ampValue).postln;
        // Здесь ваш код управления громкостью
    };
}, '/synth2/amp'); // Жестко привязан к этому пути





если у вас есть 10 одинаковых синтезаторов, и вы хотите одной функцией поймать громкость от любого из них, вы можете использовать символ *:


OSCdef(\globalAmpListener, { |msg|
    // msg[0] будет содержать точный адрес, с которого пришел сигнал (например, '/synth5/amp')
    var exactAddress = msg[0]; 
    var ampValue = msg[3];
    
    defer {
        "Пришел сигнал от %. Громкость: %".format(exactAddress, ampValue).postln;
    };
}, '/synth*/amp'); // Поймает /synth1/amp, /synth2/amp, /synth9/amp и т.д.



Главное правило для запоминания:Звук, синты, сервер, паттерны, часы TempoClock -> defer НЕ нужен.Окна, кнопки, ползунки, текстовые поля на экране ->
? defer ОБЯЗАТЕЛЕН.

Это не совсем так:
Используйте defer всегда и только тогда, когда код внутри OSCdef должен обратиться к Потоку Приложения (AppClock).


1. Когда defer ОБЯЗАТЕЛЕН (AppClock)Это всё, что связано с визуальной частью программы и её интерфейсом:Любое управление GUI: Изменение цвета кнопок, движение ползунков (~slider.value_), обновление текста.Открытие новых окон: Создание Window.new или графических панелей .gui.Тяжелые дисковые операции: Попытка открыть диалоговое окно выбора файла.



Прямое управление запущенными синтами (x.set(\freq, 440)) или создание новых звуков (Synth(\ping)) не требует defer.



Паттерны (Pdef) и задачи (Task) работают на музыкальных часах. В SuperCollider есть двое главных часов:SystemClock (высокая точность для музыки, работает в связке с сетевым потоком).AppClock (низкая точность, обслуживает интерфейс)



Если ваш Pdef или Task запущены на TempoClock или SystemClock (что происходит в 99% случаев для точного ритма) — defer НЕ нужен.



Если ваш Task или Pdef были запущены на AppClock (например, задача, которая раз в секунду обновляет текст на экране) — defer ОБЯЗАТЕЛЕН.



Чтобы узнать, на каких именно часах (TempoClock, SystemClock или AppClock) в данный микромомент выполняется ваш код, используйте метод thisThread.clock


Если thisThread.clock возвращает AppClock — вы можете смело управлять кнопками и ползунками без всяких defer.Если возвращается SystemClock или a TempoClock — этот поток предназначен для звука, и для изменения графики вам обязательно потребуется обернуть код в defer { ... }.

//////////////////////////////
NetAddr.langPort;
NetAddr.localAddr;
// -> a NetAddr(127.0.0.1, 57120)


// reseive if send port constant
n = NetAddr.new("127.0.0.1", 7771);    // create the NetAddr, port the other application is sending from, not the port SC is receiving on
// create the OSCFunc
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
o.free;    // remove the OSCFunc when you are done.

// filter by message, if send port isnt constant
//arg msg, time, addr, recvPort;
		//[msg, time, addr, recvPort].postln;

(
SynthDef(\sin_proto, {
	arg freq = 440;
	var sig = SinOsc.ar(freq);
	Out.ar(0, sig * 0.2);
}).add;
)

~sin = Synth(\sin_proto);
~sin.set(\freq, 220);
~sin.free;

(
o = OSCFunc(
	{
		arg ...args;
		(args[0][1] * 1000).postln; //[/fader1, 0.29648995399475]
		~sin.set(\freq, args[0][1] * 1000);
    },
	'/fader1'
);
)
// create the OSCFunc
o.free;   // remove the OSCFunc when you are done.

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off


~remote_port = 65535

// send message
b = NetAddr.new("127.0.0.1", ~remote_port);    // create the NetAddr
b.sendMsg("/fader1", 0.5);    // send the application the message "hello" with the parameter "there"
b.free;
