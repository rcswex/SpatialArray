// SpatialArray.sc
// A container that enables variable value exchange without temporary variables
// Implements a reference-based architecture to truly simulate physical world swapping

SpatialArray {
    var <>locations;   // Dictionary mapping keys to indices in values array
    var <>values;      // Array storing the actual values
    
    *new {
        ^super.new.init;
    }
    
    init {
        locations = IdentityDictionary.new;
        values = Array.new;
    }
    
    // Create a variable with a value
    put { |key, value|
        if(locations.includesKey(key).not) {
            // New key: add to the end
            locations[key] = values.size;
            values = values.add(value);
        } {
            // Existing key: update value at existing index
            values[locations[key]] = value;
        };
        ^key;
    }
    
    // Alias to put for backward compatibility and conceptual clarity
    createVariable { |key, value|
        ^this.put(key, value);
    }
    
    // Access a variable's value
    at { |key|
        var index = locations[key];
        if(index.isNil) {
            Error("Variable '%' not found".format(key)).throw;
        };
        ^values[index];
    }
    
    // Alias to at for backward compatibility
    getValue { |key|
        ^this.at(key);
    }
    
    // Set a variable's value
    update { |key, value|
        var index = locations[key];
        if(index.isNil) {
            Error("Variable '%' not found".format(key)).throw;
        };
        values[index] = value;
    }
    
    // Alias to update for backward compatibility
    setValue { |key, value|
        this.update(key, value);
    }
    
    // Swap the values of two variables - WITHOUT TEMPORARY VARIABLES!
    swap { |key1, key2|
        var index1, index2;
        
        index1 = locations[key1];
        index2 = locations[key2];
        
        if(index1.isNil) {
            Error("Variable '%' not found".format(key1)).throw;
        };
        
        if(index2.isNil) {
            Error("Variable '%' not found".format(key2)).throw;
        };
        
        // The key trick: swap the indices in the locations dictionary
        // instead of swapping the values themselves
        locations[key1] = index2;
        locations[key2] = index1;
        
        // No need to swap the actual values in the array!
        // The references via locations dict now point to the other values
    }
    
    // Collection interface methods
    size {
        ^locations.size;
    }
    
    isEmpty {
        ^locations.isEmpty;
    }
    
    keys {
        ^locations.keys;
    }
    
    values {
        // Map each key to its value through our indirection
        var result = Array.new(this.size);
        locations.keysValuesDo { |key, index|
            result = result.add(values[index]);
        };
        ^result;
    }
    
    includes { |value|
        ^values.includes(value);
    }
    
    includesKey { |key|
        ^locations.includesKey(key);
    }
    
    do { |function|
        this.values.do(function);
    }
    
    keysValuesDo { |function|
        locations.keysValuesDo { |key, index|
            function.value(key, values[index]);
        };
    }
    
    asArray {
        var result = Array.new(this.size);
        this.keysValuesDo { |key, value|
            result = result.add([key, value]);
        };
        ^result;
    }
    
    asList {
        ^this.asArray.asList;
    }
    
    asDict {
        var dict = IdentityDictionary.new;
        this.keysValuesDo { |key, value|
            dict[key] = value;
        };
        ^dict;
    }
    
    // Print internal state (for debugging)
    debug {
        "SpatialArray Contents:".postln;
        if(this.isEmpty) {
            "  (empty)".postln;
        } {
            "  Internal structure:".postln;
            "    Locations:".postln;
            locations.keysValuesDo { |key, index|
                "      % -> index %".format(key, index).postln;
            };
            "    Values:".postln;
            values.do { |val, i|
                "      [%] = %".format(i, val).postln;
            };
            "  Logical view:".postln;
            this.keysValuesDo { |key, value|
                "    % -> %".format(key, value).postln;
            };
        };
    }
    
    printOn { |stream|
        stream << this.class.name << "[ " << this.size << " variables ]";
    }
}