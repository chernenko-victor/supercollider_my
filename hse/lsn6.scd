lsn6_181025.scd



===================================================
            паттерны разной длины
            синхронизация каждый 4 бита
===================================== =============

(
Pbindef(
	\seq3,
	\instrument, "kick808",
	\dur, Pseq(
		[
				Pn(1, 3), Rest(1/4), 3/4, Pn(1, 3), Rest(1)
		], inf).trace,
	\amp, 0.4,
	\rel, 0.7,
	\dist, 0.5,
).play(~clck3, quant: 1);

Pdef(
\ppolyrythm1,
Pn(
// Паттерн играет случайное количество нот длительностью 0.3 бита.
// 0.3 не делится ровно на 1 или 4.
  Psync(
    Pbind(
        \dur, 0.3,
        \note, Pseq([0, 2, 4, 7], 3) // Всего 12 нот по 0.3 = 3.6 бита
    ),
    quant: 1.0, // Округлить общую длительность до целого бита
    maxdur: 4.0 // Но не дольше 4 битов
  ),
  inf
)
).play(~clck3);
)

Pbindef(\seq3).stop;




///////////////////////////////////////
//
//       feedback, chaos
//
////////////////////////////////////////

// but for using in patterns we must make it synth
(
{
	arg freq = 440; // inputs of synth
	// we can send values from Pbind by arg's name
	// for ex., \freq, 220,

	var feedback_mod = LFNoise2.kr(1) * 1.9;
	SinOscFB.ar(freq, 0.1 * 2 * 3.14 * feedback_mod ) * 0.2;
}.asSynthDef(fadeTime: 0.1, name: \fb_sin__proto).add;
)


(
// as a frequency control
{ SinOsc.ar(
	HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	)*800+900
)
* 0.04 ! 2 }.scope();
)

LatoocarfianL

(
{
HenonC.ar(
		4,
		MouseX.kr(1, 1.4),
		MouseY.kr(1, 0.3)
	);
}.scope;
)

FBSineC

{ SinOsc.ar(Lag.ar(LorenzL.ar(MouseX.kr(1, 200)), 3e-3)*800+900)*0.4 }.play(s);

{ SinOsc.ar(StandardL.ar(40, MouseX.kr(0.9, 4))*800+900)*0.4 }.play(s);


Logistic



// ....

================================================
дополнения
================================================

(
{
	"test fork".postln;
	3.wait;

	rrand(1, 11).postln;
	Pdef(\test_ptrn_pl,
		Pbind(
			\degree, Prand(
				// [1, 3, 6, 8] + Prand([0, 1, 4], 1),
				//([0, 0, 0, 0] + {rrand(1, 7)}),
				(1 .. 20).clump(4),
				inf
			)
		).trace
	).play;
	10.wait;

	"end function fork".postln;
	Pdef(\test_ptrn_pl).stop;
}.fork;
)

================================


нельзя использовать индекс, который больше или равен размера массива
чтобы не проверять, можно вместо [] использовать методы:
.clipAt(index)
.wrapAt(index)
.foldAt(index)


rotate(n: 1) // перестановка элементов в массиве

.reshape( ... shape) //

.windex //Interprets the array as a list of probabilities which should sum to 1.0 and returns a random index value based on those probabilities.



==============================================
итеграция в VS code
==============================================
/*
vscode-supercollider (originally developed by scztt and maintained via community contributors). It uses the Language Server Protocol (LSP) to communicate directly with SuperCollider (sclang).


FluCoMa Gerard Roma
*/
