~devices = ServerOptions.devices;
// ~devices.postln;

(
~devices.do({
	arg val, indx;
	("indx = " ++indx++ ", val = "++val).postln;
});
)

~in_dev_arr = ServerOptions.inDevices;
~in_dev_arr.do({|val, indx| ("indx = " ++indx++ ", val = "++val).postln; });
/*
array
  scramble
  rotate
  reverse
*/