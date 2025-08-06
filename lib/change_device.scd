ServerOptions.devices; // все устройства
ServerOptions.inDevices; // входные
~devArr = ServerOptions.outDevices; // выходные

(
~devArr.do({
	arg item, i;
	[i, item]. postln;
});
)

o = Server.default.options;

// CRASHES!!! WTF?
// o.device;
//
// o.numOutputBusChannel;
//
// //переключить устройство
// // o.device ="ASIO : ReaRoute ASIO (x64)";     // в кавычках пишем название устройства из списка
// /*o.device ="Windows DirectSound : Headphones (USB AUDIO DEVICE)";*/
// o.device = "Windows WDM-KS : Headphones (USB AUDIO DEVICE)";
// o.device = nil;            // или используем устройство по умолчанию

o.outDevice_("Windows DirectSound : Headphones (USB AUDIO DEVICE)"); // works well with csound

o.outDevice_("MME : Переназначение звуковых устр. - Output");

o.outDevice_("ASIO : ReaRoute ASIO (x64)");

// o.outDevice_("Windows DirectSound : Headphones (USB AUDIO DEVICE)   (device #10 with 0 ins 2 outs)"); // and what to do with two device with same name???

o.outDevice_("Windows WDM-KS : Headphones (USB AUDIO DEVICE)"); // shit sound!!!


//Выбор устройства не вступит в силу, пока сервер не будет (повторно) загружен.
//так что или загружаем сервер
Server.default.boot;

//или перезагружаем, если он уже загружен
Server.default.reboot;

{WhiteNoise.ar(0.2)}.play;

{WhiteNoise.ar(0.2)!8}.play;

(
{
	var sig;
	sig = In.ar(2, 16);
	sig;
	// DelayN.ar(sig, 2, 1, 0.5);
	//Out.ar(0, [0, 0, sig, sig]);
}.scope;
)

s.plotTree;
