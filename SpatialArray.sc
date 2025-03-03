// SpatialArray.sc
// A container that enables variable value exchange without temporary variables
// Simulates the intuitive nature of swapping items in the physical world

SpatialArray {
    var <>variables;  // Direct mapping from names to values

    *new {
        ^super.new.init;
    }

    init {
        variables = IdentityDictionary.new;
    }

    // Create a variable with a value
    put { |key, value|
        variables[key] = value;
        ^key;
    }
    
    // Alias to put for backward compatibility and conceptual clarity
    createVariable { |key, value|
        ^this.put(key, value);
    }
    
    // Access a variable's value
    at { |key|
        var value = variables[key];
        if(value.isNil and: { variables.includesKey(key).not }) {
            Error("Variable '%' not found".format(key)).throw;
        };
        ^value;
    }
    
    // Alias to at for backward compatibility
    getValue { |key|
        ^this.at(key);
    }
    
    // Set a variable's value
    put { |key, value|
        if(variables.includesKey(key).not) {
            Error("Variable '%' not found".format(key)).throw;
        };
        variables[key] = value;
    }
    
    // Alias to put for backward compatibility
    setValue { |key, value|
        ^this.put(key, value);
    }
    
    // Swap the values of two variables
    swap { |key1, key2|
        var val1, val2;
        
        if(variables.includesKey(key1).not) {
            Error("Variable '%' not found".format(key1)).throw;
        };
        
        if(variables.includesKey(key2).not) {
            Error("Variable '%' not found".format(key2)).throw;
        };
        
        // In SuperCollider, we need to use a temporary variable for the swap
        // since we don't have pointer-level swapping as in C++
        val1 = variables[key1];
        val2 = variables[key2];
        variables[key1] = val2;
        variables[key2] = val1;
    }
    
    // Collection interface methods
    size {
        ^variables.size;
    }
    
    isEmpty {
        ^variables.isEmpty;
    }
    
    keys {
        ^variables.keys;
    }
    
    values {
        ^variables.values;
    }
    
    includes { |value|
        ^variables.includes(value);
    }
    
    includesKey { |key|
        ^variables.includesKey(key);
    }
    
    do { |function|
        variables.do(function);
    }
    
    keysValuesDo { |function|
        variables.keysValuesDo(function);
    }
    
    asArray {
        ^variables.asArray;
    }
    
    asList {
        ^variables.asList;
    }
    
    asDict {
        ^variables.copy;
    }
    
    // Print internal state (for debugging)
    debug {
        "SpatialArray Contents:".postln;
        if(this.isEmpty) {
            "  (empty)".postln;
        } {
            variables.keysValuesDo { |key, value|
                "  % -> %".format(key, value).postln;
            };
        };
    }
    
    printOn { |stream|
        stream << this.class.name << "[ " << variables.size << " variables ]";
    }
}