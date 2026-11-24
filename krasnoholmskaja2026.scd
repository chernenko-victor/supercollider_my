// krasnoholmskaja2026

~devArr = ServerOptions.outDevices; // выходные

(
~devArr.do({
	arg i;
	i.postln;
});
)


s.options.outDevice_("ASIO : ReaRoute ASIO (x64)");


// 3. reboot server
s.reboot;


//
s.options.outDevice = nil;


// Pbind().play;

// extra_examples2026.scd :: Bjorklund


//   mod         mod       mod
//    |           |         |
// U-distr + vari voice + strum
//   dur