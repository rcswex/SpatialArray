# SpatialArray Quark

## Why SpatialArray?

Imagine swapping an apple and a banana on a table. You would pick up both fruits simultaneously, exchange their positions in the air, and then place them down at the same time. This process is intuitive and simple, maintaining the precise spatial relationship between the objects.

However, in traditional programming, swapping two variable values requires an additional "temporary variable":

```supercollider
// Traditional method to swap a and b
~a = 5;
~b = 10;

// Requires temporary variable c
~c = ~a;   // First store a's value in temporary variable c
~a = ~b;   // Assign b's value to a
~b = ~c;   // Assign the original a value (stored in c) to b
```

Why does the programming world need this extra temporary storage when the physical world doesn't? This is the problem the SpatialArray Quark attempts to solve. By simulating the intuitive nature of physical world exchanges, SpatialArray provides a way to conceptually swap variables without temporary variables.

This is a new spatial array structure designed for SuperCollider, focused on implementing value exchange operations without using temporary variables.

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

In the physical world, when we swap the positions of two objects, we manipulate them simultaneously, exchanging their positions in space and then setting them down at the same time, precisely maintaining their original spatial relationships. No "third position" as temporary storage is needed.

SpatialArray is designed based on this concept:

1. **Separation of position and value**: Variable names are just references, values exist independently
2. **ID layer mapping**: A two-layer mapping (variable name → ID → value) implements indirect referencing
3. **Reference exchange**: Swap operations only exchange references, not values

This allows us to swap variable values simply like this:

```supercollider
// Using SpatialArray to swap a and b
~arr = SpatialArray.new;
~arr.createVariable(\a, 5);
~arr.createVariable(\b, 10);

// No temporary variable needed
~arr.swap(\a, \b);
```

## Differences from Standard SuperCollider Dictionary

SpatialArray may initially seem similar to SuperCollider's standard Dictionary or IdentityDictionary, but there are several key differences:

1. **Two-layer mapping structure**:

   - **Dictionary**: Implements a single key-value mapping (key → value)
   - **SpatialArray**: Internally implements a two-layer mapping (variable name → ID → value), this additional indirect layer is the core innovation

2. **Specialized swap operation**:

   - Dictionary

     : No built-in swap function, swapping values of two keys still requires a temporary variable:

     ```supercollider
     // Dictionary swap requires temporary variable~d = Dictionary.new;~d.put(\a, 5);~d.put(\b, 10);~temp = ~d.at(\a);~d.put(\a, ~d.at(\b));~d.put(\b, ~temp);
     ```

   - SpatialArray

     : Provides a dedicated 

     ```
     swap
     ```

      method, no temporary variable needed:

     ```supercollider
     // SpatialArray doesn't need temporary variable~arr = SpatialArray.new;~arr.createVariable(\a, 5);~arr.createVariable(\b, 10);~arr.swap(\a, \b); // Direct swap
     ```

3. **Design purpose**:

   - **Dictionary**: Designed for general data organization and retrieval
   - **SpatialArray**: Specifically designed to model physical world exchange patterns

4. **Explicit ID layer**:

   - SpatialArray maintains an ID layer, providing additional indirection, conceptually similar to the relationship between object position and identity in the physical world
   - This indirection makes swap operations more intuitive, simulating exchange of object positions rather than changing the objects themselves

5. **Debugging functionality**:

   - SpatialArray's `debug` method can intuitively display all mapping relationships, helping to understand the connections between variables, IDs, and values

While Dictionary may provide similar functionality in some scenarios, SpatialArray offers a clearer conceptual model, an interface optimized specifically for swap operations, and educational value in expressing the relationship between the physical world and programming models.

## Basic Usage

### Creating a Spatial Array and Variables

```supercollider
~arr = SpatialArray.new;

// Create variables
~arr.createVariable(\a, 5);
~arr.createVariable(\b, 10);
```

### Getting and Setting Variable Values

```supercollider
// Get value
~a = ~arr.getValue(\a);  // Returns 5

// Set value
~arr.setValue(\a, 15);
```

### Swapping Variable Values

```supercollider
// Swap values of a and b
~arr.swap(\a, \b);

// Now a=10, b=5
```

### Debugging View

```supercollider
// View internal structure
~arr.debug;
```

## Use Cases

### Simple Value Exchange

The most basic use case is swapping two simple values, such as numbers or strings.

### Complex Object Exchange

For complex objects, such as Synth parameter collections, SpatialArray's advantages become more apparent, avoiding large amounts of data copying.

### Real-time Audio Applications

In audio processing, it can be used to quickly swap different effect parameters, timbral settings, etc.

### Combined with Patterns

Combined with SuperCollider's pattern system, it can create dynamically changing musical structures.

## Technical Notes

- SpatialArray implements a two-layer mapping structure in SuperCollider
- Uses IdentityDictionary as the internal storage mechanism
- All operations are based on symbol lookups, efficient and intuitive

## Examples

Please refer to the accompanying `SpatialArray_Examples.scd` file for complete examples, including:

1. Basic numeric value exchanges
2. Fruit object exchange examples
3. Parameter exchange examples for audio synthesis

## About

The SpatialArray Quark was inspired by the conceptual difference between physical world and programming world exchange operations, aiming to provide a more intuitive variable operation model that is closer to human thinking.

(cc) 2025 by Wenge CHEN.

## License

MIT License
