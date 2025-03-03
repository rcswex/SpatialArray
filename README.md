# SpatialArray Quark

## Why SpatialArray?

Imagine swapping an apple and a banana on a table. You would pick up both fruits simultaneously, exchange their positions in the air, and then place them down at the same time. This process is intuitive and simple, maintaining the precise spatial relationship between the objects.

However, in traditional programming, swapping two variable values requires an additional "temporary variable":

```supercollider
// Traditional method to swap a and b
a = 5;
b = 10;

// Requires temporary variable c
c = a;   // First store a's value in temporary variable c
a = b;   // Assign b's value to a
b = c;   // Assign the original a value (stored in c) to b
```

Why does the programming world need this extra temporary storage when the physical world doesn't? This is the problem the SpatialArray Quark attempts to solve. By simulating the intuitive nature of physical world exchanges, SpatialArray provides a way to conceptually swap variables without temporary variables.

## Installation

Copy the `SpatialArray.sc` file to your SuperCollider extensions directory:

```
Platform.userExtensionDir
```

Then recompile the class library:

```supercollider
thisProcess.recompile;
```

## Design Philosophy

SpatialArray is designed to bridge the conceptual gap between how we exchange objects in the physical world and how we swap values in programming:

1. **Container-based approach**: Variables become "containers" for values
2. **Direct swap operations**: A specialized `swap` method exchanges values without temporaries
3. **Standard collection interface**: Familiar SuperCollider collection methods

Unlike a standard SuperCollider Dictionary where you would need a temporary variable to swap values, SpatialArray provides a dedicated `swap` method:

```supercollider
// Using SpatialArray to swap a and b
~arr = SpatialArray.new;
~arr.put(\a, 5);
~arr.put(\b, 10);

// No temporary variable in your code
~arr.swap(\a, \b);
```

## Differences from Standard SuperCollider Dictionary

While SpatialArray may appear similar to SuperCollider's Dictionary, it offers:

1. **Specialized swap operation**: Optimized for exchanging values between keys
2. **Conceptual model**: Designed to model physical world exchange patterns
3. **Backward compatibility**: Maintains older method names (createVariable, getValue, setValue) alongside standard collection methods

## Basic Usage

### Creating a Spatial Array and Variables

```supercollider
~arr = SpatialArray.new;

// Create variables
~arr.put(\a, 5);           // Standard collection style
~arr.createVariable(\b, 10); // Legacy style
```

### Getting and Setting Variable Values

```supercollider
// Get value
~a = ~arr.at(\a);       // Standard collection style
~b = ~arr.getValue(\b); // Legacy style

// Set value
~arr.put(\a, 15);           // Standard collection style
~arr.setValue(\b, 20);      // Legacy style
```

### Swapping Variable Values

```supercollider
// Swap values of a and b
~arr.swap(\a, \b);

// Now a=10, b=5
```

### Collection Interface

```supercollider
// Size and empty checks
~arr.size;     // Number of key-value pairs
~arr.isEmpty;  // Whether the collection is empty

// Keys and values
~arr.keys;     // All keys
~arr.values;   // All values

// Iteration
~arr.keysValuesDo { |k, v| [k, v].postln };

// Conversion
~arr.asArray;  // Convert to array
~arr.asList;   // Convert to list
~arr.asDict;   // Get copy of internal dictionary
```

### Debugging

```supercollider
// View internal structure
~arr.debug;
```

## Use Cases

### Simple Value Exchange

The most basic use case is swapping two simple values, such as numbers or strings.

### Complex Object Exchange

For complex objects, such as Synth parameter collections, SpatialArray provides a clean interface for exchanging settings.

### Real-time Audio Applications

In audio processing, it can be used to quickly swap different effect parameters, timbral settings, etc:

```supercollider
// Store two sets of synth parameters
~synthSettings = SpatialArray.new;
~synthSettings.put(\bright, (freq: 880, amp: 0.4, pan: 0.7));
~synthSettings.put(\mellow, (freq: 440, amp: 0.3, pan: -0.3));

// Switch between parameter sets in real-time
~synthSettings.swap(\bright, \mellow);
```

### Combined with Patterns

Combined with SuperCollider's pattern system to create dynamic musical structures:

```supercollider
// Store different rhythmic patterns
~patterns = SpatialArray.new;
~patterns.put(\pattern1, Pseq([1, 2, 3, Rest()], inf));
~patterns.put(\pattern2, Pseq([Rest(), 1, 1, 2], inf));

// Swap patterns during performance
~patterns.swap(\pattern1, \pattern2);
```

## Technical Notes

- SpatialArray provides dictionary-like functionality
- Uses IdentityDictionary as the internal storage mechanism
- Implements standard collection interface methods

## Examples

Please refer to the accompanying `SpatialArrayExample.scd` file for complete examples, including:

1. Basic numeric value exchanges
2. Fruit object exchange examples
3. Parameter exchange examples for audio synthesis
4. Collection interface usage

## About

The SpatialArray Quark was inspired by the conceptual difference between physical world and programming world exchange operations, aiming to provide a more intuitive variable operation model that is closer to human thinking.

(cc) 2025 by Wenge CHEN.

## License

MIT License
