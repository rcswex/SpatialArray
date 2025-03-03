// SpatialArray usage examples
// Ensure SpatialArray.sc is loaded

// Example 1: Swapping simple values
(
// Create a spatial array instance
~intArray = SpatialArray.new;

// Create variables a = 5, b = 10
~intArray.createVariable(\a, 5);
~intArray.createVariable(\b, 10);

// Display initial state
"==== Example 1: Integer Swap ====".postln;
"Initial state:".postln;
"a = %".format(~intArray.getValue(\a)).postln;
"b = %".format(~intArray.getValue(\b)).postln;
"Internal structure:".postln;
~intArray.debug;

// Swap a and b
~intArray.swap(\a, \b);

// Display state after swap
"\nAfter swap:".postln;
"a = %".format(~intArray.getValue(\a)).postln;
"b = %".format(~intArray.getValue(\b)).postln;
"Internal structure:".postln;
~intArray.debug;
)

// Example 2: Swapping fruit names
(
// Create a spatial array instance
~fruitNames = SpatialArray.new;

// Create variables
~fruitNames.createVariable(\leftFruit, "apple");
~fruitNames.createVariable(\rightFruit, "banana");

// Display initial state
"\n==== Example 2: Fruit Name Swap ====".postln;
"Initial state:".postln;
"leftFruit = %".format(~fruitNames.getValue(\leftFruit)).postln;
"rightFruit = %".format(~fruitNames.getValue(\rightFruit)).postln;

// Swap
~fruitNames.swap(\leftFruit, \rightFruit);

// Display state after swap
"\nAfter swap:".postln;
"leftFruit = %".format(~fruitNames.getValue(\leftFruit)).postln;
"rightFruit = %".format(~fruitNames.getValue(\rightFruit)).postln;
)

// Example 3: Swapping custom objects (Fruit instances)
(
// Create spatial array instance
~fruitObjects = SpatialArray.new;

// Create fruit objects
~apple = Fruit.new("apple", "red", 0.2);
~banana = Fruit.new("banana", "yellow", 0.15);

// Create variables
~fruitObjects.createVariable(\basketA, ~apple);
~fruitObjects.createVariable(\basketB, ~banana);

// Display initial state
"\n==== Example 3: Complex Fruit Object Swap ====".postln;
"Initial state:".postln;
"basketA: %".format(~fruitObjects.getValue(\basketA)).postln;
"basketB: %".format(~fruitObjects.getValue(\basketB)).postln;

// Swap fruits in baskets
~fruitObjects.swap(\basketA, \basketB);

// Display state after swap
"\nAfter swap:".postln;
"basketA: %".format(~fruitObjects.getValue(\basketA)).postln;
"basketB: %".format(~fruitObjects.getValue(\basketB)).postln;
)

// Example 4: Application to SuperCollider audio synthesis
(
// Create two Synth object parameter settings
~sinSettings = (freq: 440, amp: 0.5, pan: -0.5);
~sawSettings = (freq: 220, amp: 0.3, pan: 0.5);

// Store these settings in a spatial array
~synthSettings = SpatialArray.new;
~synthSettings.createVariable(\sin, ~sinSettings);
~synthSettings.createVariable(\saw, ~sawSettings);

// Create SynthDefs based on these settings
SynthDef(\sin, { |freq=440, amp=0.5, pan=0|
    var sig = SinOsc.ar(freq) * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).store;

SynthDef(\saw, { |freq=220, amp=0.3, pan=0|
    var sig = Saw.ar(freq) * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).store;

// Display initial state
"\n==== Example 4: Audio Synthesis Settings Swap ====".postln;
"Initial state:".postln;
"sin settings: %".format(~synthSettings.getValue(\sin)).postln;
"saw settings: %".format(~synthSettings.getValue(\saw)).postln;

// Swap settings
~synthSettings.swap(\sin, \saw);

// Display state after swap
"\nAfter swap:".postln;
"sin settings: %".format(~synthSettings.getValue(\sin)).postln;
"saw settings: %".format(~synthSettings.getValue(\saw)).postln;

// Use the swapped settings to create Synths
s.waitForBoot({
    ~sinParams = ~synthSettings.getValue(\sin);
    ~sawParams = ~synthSettings.getValue(\saw);
    
    ~sinSynth = Synth(\sin, [\freq, ~sinParams.freq, \amp, ~sinParams.amp, \pan, ~sinParams.pan]);
    ~sawSynth = Synth(\saw, [\freq, ~sawParams.freq, \amp, ~sawParams.amp, \pan, ~sawParams.pan]);
    
    // Release after 2 seconds
    SystemClock.sched(2, {
        ~sinSynth.release;
        ~sawSynth.release;
        nil;
    });
});
)