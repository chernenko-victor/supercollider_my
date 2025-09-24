Pclutch

Pclutch(Pseq([1, 2, 3, 4, 5], 3), Pseq([0, 0, 1, 0, 0, 0, 1, 1])).asStream.nextN(10);
-> [ 1, 1, 2, 2, 2, 2, 3, 4, nil, nil ]