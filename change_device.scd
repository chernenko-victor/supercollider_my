// ========================================
// ===============    NB   ================
// ========================================

// reboot needed after all changes to server options



// ====================================================
// ===============    change devices   ================
// ====================================================

ServerOptions.devices; // все устройства
ServerOptions.inDevices; // входные
~devArr = ServerOptions.outDevices; // выходные

(
~devArr.do({
	arg i;
	i.postln;
});
)

o = Server.default.options; // or simply o = s.options;

// переключить устройство
o.outDevice_("Windows WASAPI : CABLE Input (VB-Audio Virtual Cable)");

o.outDevice = nil;

o.outDevice_("Windows DirectSound : Headphones (USB AUDIO DEVICE)"); // works well with csound


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


s.sampleRate; // Check sample rate


// but developer had an great idea to make users more troubles
// so to change sample rate not
// s.sampleRate = 44100 but
// but
s.options.sampleRate = 44100;


// enough troubles? No!
// more troubles for good of troubles!!!!!!
s.memSize; // trow error
// only

s.options.memSize;

s.options.blockSize; // Check control block size (internal)
s.options.blockSize = 128; // set new blockSize
// reboot

s.blockSize; // trow error

s.options.hardwareBufferSize; // nil means default
// s.options.hardwareBufferSize = 128;

s.options.numBuffers; // for BufRead ...
// s.numBuffers;

