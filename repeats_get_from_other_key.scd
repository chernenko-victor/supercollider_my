Pclutch(pattern, connected)
If the connected pattern is true, Pclutch returns the next value from pattern. If connected is false, the previous pattern value is repeated.

Pdup(n, pattern)
n and pattern are both patterns. Each value from pattern is repeated n times. If n is a pattern, each value can be repeated a different number of times.

Pkey(key)
Read the key in the input event, making previously-calculated values available for other streams.