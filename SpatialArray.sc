// SpatialArray.sc
// Spatial Array: A structure allowing variable value exchange without temporary variables
// Simulates the intuitive nature of swapping items in the physical world

SpatialArray {
    var <>valueSpace;  // Value storage space
    var <>objectIDs;   // Mapping from names to IDs
    var <>nextID;      // Next available ID

    *new {
        ^super.new.init;
    }

    init {
        valueSpace = IdentityDictionary.new;
        objectIDs = IdentityDictionary.new;
        nextID = 0;
    }

    // Create a variable and assign a value
    createVariable { |name, value|
        var id = nextID;
        nextID = nextID + 1;
        
        // Store value and ID mapping
        valueSpace[id] = value;
        objectIDs[name] = id;
        
        ^name;
    }
    
    // Get the value of a variable
    getValue { |name|
        var id = objectIDs[name];
        if(id.isNil) {
            Error("Variable '%' not found".format(name)).throw;
        };
        
        ^valueSpace[id];
    }
    
    // Set the value of a variable
    setValue { |name, value|
        var id = objectIDs[name];
        if(id.isNil) {
            Error("Variable '%' not found".format(name)).throw;
        };
        
        valueSpace[id] = value;
    }
    
    // Swap the values of two variables (no temporary variable needed)
    swap { |name1, name2|
        var id1, id2;
        
        id1 = objectIDs[name1];
        if(id1.isNil) {
            Error("Variable '%' not found".format(name1)).throw;
        };
        
        id2 = objectIDs[name2];
        if(id2.isNil) {
            Error("Variable '%' not found".format(name2)).throw;
        };
        
        // Directly swap IDs, not values
        objectIDs[name1] = id2;
        objectIDs[name2] = id1;
    }
    
    // Print internal state (for debugging)
    debug {
        "Value Space:".postln;
        valueSpace.keysValuesDo { |id, value|
            "  % -> %".format(id, value).postln;
        };
        
        "Pointer Mappings:".postln;
        objectIDs.keysValuesDo { |name, id|
            "  % -> % (value: %)".format(name, id, valueSpace[id]).postln;
        };
    }
}

// Extension: Class supporting fruit objects
Fruit {
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
}