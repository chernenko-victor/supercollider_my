(
// Pwhite(1.0, 0.0, inf).asStream.nextN(1000).histo(50, 0, 1.0).plot;
// Prand([1, 2, 3, 4], inf).asStream.nextN(1000).histo.plot;
// {0.001.exprand(1.0)}.dup(1000).histo(200).plot;
{-1 * (1.0.bilinrand)}.dup(1000).histo(200).plot;
)

{10 - 10.linrand}.dup(1000).histo.plot;
{10.linrand}.dup(1000).histo.plot;

