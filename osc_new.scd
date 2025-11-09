NetAddr.langPort;
// see IP address of computer where Supercollider runs
// in network settings or in terminal with 'ifconfig' command
// input port and IP to OSC sender soft

// see all incoming OSC messages
OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off

// control synth parameter with OSC
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
		arg ...args; // all input argument to array 'args'
		args.postln;
		// args[0][1] is osc value
		(args[0][1] * 1000).postln; //[/fader1, 0.29648995399475]
		~sin.set(\freq, args[0][1] * 1000);
    },
	'/fader1' // osc path
);
)

o.free;

//////////////////////////////////////////////
~remote_port = 65535
~remote_ip = 1.2.3.4

// send message to remote
b = NetAddr.new(~remote_ip, ~remote_port);    // create the NetAddr
b.sendMsg("/fader1", 0.5);
b.free;