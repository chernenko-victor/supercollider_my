o = Server.default.options;

// o.outDevice_("Windows WASAPI : Voicemeeter In 1 (VB-Audio Voicemeeter VAIO)");
o.outDevice_("Windows WASAPI : CABLE Input (VB-Audio Virtual Cable)");

// Windows WASAPI : Наушники (Realtek(R) Audio)
o.device = nil;            // или используем устройство по умолчанию


//или перезагружаем, если он уже загружен
Server.default.reboot;