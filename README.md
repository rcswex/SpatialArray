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

Why does the programming world need this extra temporary storage when the physical world doesn't? This is the problem the SpatialArray Quark solves. Unlike previous attempts that only hid the temporary variable, this implementation uses a true reference-based architecture that eliminates the need for temporary value copies altogether.

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

SpatialArray bridges the conceptual gap between physical world exchanges and programming by implementing a two-level reference architecture:

1. **Reference-based architecture**: Keys map to indices, not directly to values
2. **Pointer-like swapping**: Exchange references, not values
3. **Zero-copy operations**: Swapping large objects is efficient with no value copies

Unlike a standard SuperCollider Dictionary where you would need a temporary variable to swap values, SpatialArray's `swap` method exchanges only the references:

```supercollider
// Using SpatialArray to swap a and b
~arr = SpatialArray.new;
~arr.put(\a, 5);
~arr.put(\b, 10);

// No temporary variable needed anywhere
~arr.swap(\a, \b);
```

## How It Works

SpatialArray uses a unique two-level architecture:

1. **Locations Dictionary**: Maps keys to indices in the values array
2. **Values Array**: Stores the actual values

When you swap two variables, only their indices in the locations dictionary are exchanged. The actual values in the values array never move! This is similar to how actual pointers work in lower-level languages - you're just changing what each variable name points to, not copying the values.

```
Before swap:
  Locations:  { a → 0, b → 1 }
  Values:     [ 5, 10 ]

After swap:
  Locations:  { a → 1, b → 0 }  ← Only these indices changed!
  Values:     [ 5, 10 ]        ← Values array remains unchanged
```

## Differences from Standard SuperCollider Dictionary

SpatialArray fundamentally differs from SuperCollider's Dictionary:

1. **True reference-based swapping**: No value copies during swaps
2. **Two-level architecture**: Separate key-to-index and index-to-value mappings
3. **Efficiency for large objects**: Swapping large objects only exchanges small indices

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

### Debugging and Internal Structure

```supercollider
// View internal structure
~arr.debug;  // Shows both the locations dictionary and values array
```

## Use Cases

### Simple Value Exchange

The most basic use case is swapping simple values, such as numbers or strings, with zero-copy efficiency.

### Complex Object Exchange

For complex objects like Synth parameter collections, SpatialArray provides an efficient interface for exchanging settings without copying potentially large data structures.

### Real-time Audio Applications

In audio processing, quickly swap different effect parameters, timbral settings, etc. with minimal overhead:

```supercollider
// Store two sets of synth parameters
~synthSettings = SpatialArray.new;
~synthSettings.put(\bright, (freq: 880, amp: 0.4, pan: 0.7));
~synthSettings.put(\mellow, (freq: 440, amp: 0.3, pan: -0.3));

// Switch between parameter sets in real-time with zero copying
~synthSettings.swap(\bright, \mellow);
```

### Combined with Patterns

Combined with SuperCollider's pattern system to create dynamic musical structures with efficient swapping:

```supercollider
// Store different rhythmic patterns
~patterns = SpatialArray.new;
~patterns.put(\pattern1, Pseq([1, 2, 3, Rest()], inf));
~patterns.put(\pattern2, Pseq([Rest(), 1, 1, 2], inf));

// Swap patterns efficiently during performance
~patterns.swap(\pattern1, \pattern2);
```

## Performance Considerations

SpatialArray's unique approach offers several performance advantages:

1. **Efficient swapping**: Only small indices are swapped, not the actual values
2. **Memory efficiency**: Avoid unnecessary copies of large objects
3. **Speed improvements**: For large objects, reference-based swapping can be significantly faster

## Examples

Please refer to the accompanying `SpatialArrayExample.scd` file for complete examples, including:

1. Basic numeric value exchanges with internal structure visualization
2. Fruit object exchange examples
3. Parameter exchange examples for audio synthesis
4. Collection interface usage
5. Performance comparisons with standard Dictionary

## About

The SpatialArray Quark uses a reference-based architecture to truly implement the conceptual model of physical world exchanges, providing both an intuitive API and performance benefits for common swap operations.

(cc) 2025 by Wenge CHEN.

## License

MIT License
