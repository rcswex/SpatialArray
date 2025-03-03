// SpatialArray usage examples
// Ensure SpatialArray.sc is loaded

// Define Fruit class for examples
(
Fruit = {
    var <>name, <>color, <>weight;
    
    *new { |name, color, weight|
        ^super.new.init(name, color, weight);
    }
    
    init { |argName, argColor, argWeight|
        name = argName;
        color = argColor;
        weight = argWeight;
    }
    
    asString {
        ^"%(%, %kg)".format(name, color, weight);
    }
    
    printOn { |stream|
        stream << this.asString;
    }
};
)

// Example 1: Swapping simple values with internal structure visualization
(
// Create a spatial array instance
~intArray = SpatialArray.new;

// Create variables a = 5, b = 10
~intArray.put(\a, 5);
~intArray.put(\b, 10);

// Display initial state
"==== Example 1: Integer Swap with Reference Architecture ====".postln;
"Initial state:".postln;
"a = %".format(~intArray.at(\a)).postln;
"b = %".format(~intArray.at(\b)).postln;
"Internal structure:".postln;
~intArray.debug;

// Swap a and b
~intArray.swap(\a, \b);

// Display state after swap
"\nAfter swap:".postln;
"a = %".format(~intArray.at(\a)).postln;
"b = %".format(~intArray.at(\b)).postln;
"Internal structure:".postln;
~intArray.debug;

// Note how the locations changed but the values array stayed the same!
"Explanation: Notice that the indices in the locations dictionary swapped,".postln;
"but the values array remained unchanged. This demonstrates the reference-".postln;
"based swapping that doesn't need temporary value copies.".postln;
)

// Example 2: Swapping fruit names using legacy methods
(
// Create a spatial array instance
~fruitNames = SpatialArray.new;

// Create variables (using legacy method for demonstration)
~fruitNames.createVariable(\leftFruit, "apple");
~fruitNames.createVariable(\rightFruit, "banana");

// Display initial state
"\n==== Example 2: Fruit Name Swap ====".postln;
"Initial state:".postln;
"leftFruit = %".format(~fruitNames.getValue(\leftFruit)).postln;
"rightFruit = %".format(~fruitNames.getValue(\rightFruit)).postln;
"Internal structure:".postln;
~fruitNames.debug;

// Swap
~fruitNames.swap(\leftFruit, \rightFruit);

// Display state after swap
"\nAfter swap:".postln;
"leftFruit = %".format(~fruitNames.getValue(\leftFruit)).postln;
"rightFruit = %".format(~fruitNames.getValue(\rightFruit)).postln;
"Internal structure:".postln;
~fruitNames.debug;
)

// Example 3: Swapping complex objects (Fruit instances)
(
// Create spatial array instance
~fruitObjects = SpatialArray.new;

// Create fruit objects
~apple = Fruit.new("apple", "red", 0.2);
~banana = Fruit.new("banana", "yellow", 0.15);

// Create variables
~fruitObjects.put(\basketA, ~apple);
~fruitObjects.put(\basketB, ~banana);

// Display initial state
"\n==== Example 3: Complex Fruit Object Swap ====".postln;
"Initial state:".postln;
"basketA: %".format(~fruitObjects.at(\basketA)).postln;
"basketB: %".format(~fruitObjects.at(\basketB)).postln;
"Internal structure:".postln;
~fruitObjects.debug;

// Swap fruits in baskets
~fruitObjects.swap(\basketA, \basketB);

// Display state after swap
"\nAfter swap:".postln;
"basketA: %".format(~fruitObjects.at(\basketA)).postln;
"basketB: %".format(~fruitObjects.at(\basketB)).postln;
"Internal structure:".postln;
~fruitObjects.debug;

"Explanation: Even for complex objects like our Fruit instances, only the".postln;
"references (indices) are swapped, not the actual objects themselves.".postln;
"This is more efficient especially for large objects.".postln;
)

// Example 4: Application to SuperCollider audio synthesis
(
// Create two Synth object parameter settings
~sinSettings = (freq: 440, amp: 0.5, pan: -0.5);
~sawSettings = (freq: 220, amp: 0.3, pan: 0.5);

// Store these settings in a spatial array
~synthSettings = SpatialArray.new;
~synthSettings.put(\sin, ~sinSettings);
~synthSettings.put(\saw, ~sawSettings);

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
"sin settings: %".format(~synthSettings.at(\sin)).postln;
"saw settings: %".format(~synthSettings.at(\saw)).postln;
"Internal structure:".postln;
~synthSettings.debug;

// Swap settings
~synthSettings.swap(\sin, \saw);

// Display state after swap
"\nAfter swap:".postln;
"sin settings: %".format(~synthSettings.at(\sin)).postln;
"saw settings: %".format(~synthSettings.at(\saw)).postln;
"Internal structure:".postln;
~synthSettings.debug;

// Create Synths with the swapped settings
s.waitForBoot({
    ~sinParams = ~synthSettings.at(\sin);
    ~sawParams = ~synthSettings.at(\saw);
    
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

// Example 5: Collection interface methods and performance test
(
~demo = SpatialArray.new;
~demo.put(\a, 1);
~demo.put(\b, 2);
~demo.put(\c, 3);

// Size and content inspection
"\n==== Example 5: Collection Interface and Performance ====".postln;
"Collection size: %".format(~demo.size).postln;
"Contains key 'b'? %".format(~demo.includesKey(\b)).postln;
"Contains value 3? %".format(~demo.includes(3)).postln;

// Iteration example
"All keys:".postln;
~demo.keys.do { |k| k.postln };

"All values:".postln;
~demo.values.do { |v| v.postln };

"Key-value pairs:".postln;
~demo.keysValuesDo { |k, v|
    "% -> %".format(k, v).postln;
};

"Internal structure:".postln;
~demo.debug;

// Performance test - compare with regular Dictionary for large objects
"\nPerformance Test:".postln;
"Creating large objects...".postln;

// Create a large string object
~largeString = String.fill(100000, { 65.rand + 32 });

// Performance test for regular Dictionary
"Regular Dictionary swap test:".postln;
~dictTimer = {
    var dict = Dictionary.new;
    var temp;
    
    dict[\a] = ~largeString;
    dict[\b] = ~largeString ++ "extra";
    
    // Measure time for 1000 swaps
    1000.do {
        // Need temporary variable
        temp = dict[\a];
        dict[\a] = dict[\b];
        dict[\b] = temp;
    };
}.bench;

// Performance test for SpatialArray
"SpatialArray swap test:".postln;
~spatialTimer = {
    var spatial = SpatialArray.new;
    
    spatial.put(\a, ~largeString);
    spatial.put(\b, ~largeString ++ "extra");
    
    // Measure time for 1000 swaps
    1000.do {
        // No temporary variable needed!
        spatial.swap(\a, \b);
    };
}.bench;

"For large objects, SpatialArray's reference-based swap can be more efficient".postln;
"since it doesn't need to copy the actual values during swaps.".postln;
)