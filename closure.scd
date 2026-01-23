(
// Define a function that returns a counter function
~makeCounter = {
    var count = 0; // This variable persists inside the closure
    {
        count = count + 1;
        count.postln;
    }
};

// Create an instance of the counter
~myCounter = ~makeCounter.value;
)

// Call it multiple times:
~myCounter.value; // Posts 1
~myCounter.value; // Posts 2
