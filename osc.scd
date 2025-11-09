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