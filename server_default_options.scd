~devices_arr = ServerOptions.devices; // no devices list in Server.default.options

(
~devices_arr.do({
	arg ...args;
	args.postln;
});
)

o = Server.default.options; // change device only through Server.default.options

o.device = nil; // change to default device
o.device = "ASIO : ReaRoute ASIO (x64)";

Server.default.reboot;

(
{
	Out.ar(0, SinOsc.ar());
}.play(Server.default);
)


Server.default.boot;
Server.default.serverRunning;

s.plotTree;


o.numOutputBusChannels;
o.bindAddress;
o.memSize;

===================

o = Server.default.options;
o.inDevice_("ASIO : ReaRoute ASIO (x64)");
o.outDevice_("ASIO : ReaRoute ASIO (x64)");
Server.default.reboot;


s.boot;
s.dumpOSC(3); // max debugging
// don't call .play yet...

s.status; // say what?
Server.all; // should return a set of Servers
Server.allBootedServers; // should return a set of booted servers

// if all seems ok, call
{SinOsc.ar(440)}.play; // call it with an arg, maybe that's whats wrong.

