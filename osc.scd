NetAddr.langPort;
NetAddr.localAddr;
// -> a NetAddr(127.0.0.1, 57120)


// reseive if send port constant
n = NetAddr.new("127.0.0.1", 7771);    // create the NetAddr, port the other application is sending from, not the port SC is receiving on
// create the OSCFunc
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
o.free;    // remove the OSCFunc when you are done.

// filter by message, if send port isnt constant
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye'); // create the OSCFunc
o.free;    // remove the OSCFunc when you are done.

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off


// send message
b = NetAddr.new("127.0.0.1", ~remote_port);    // create the NetAddr
b.sendMsg("/hello", "there");    // send the application the message "hello" with the parameter "there"