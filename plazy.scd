Plazy

Pn
a = Pn(Pshuf([1, 2, 2, 3, 3, 3], 4)).asStream;

a.nextN(16)


(
b = Pn(
	Pshuf((1..5), 4)
).asStream;
b.nextN(16);
)

b.nextN(16);