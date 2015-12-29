//
//  PersistencyManager.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {

    let keyListKeyConstant = "keyListKey"
    private var keys = [Key]()
    
    override init() {
        super.init()
        retrieveKeys()
        if keys.count == 0 {
            resetDefaultKeys()
        }
    }
    
    private func getDefaultKeys() -> [Key] {
        var defaultKeys = [Key]()
        defaultKeys = [
                Key(name: "C", value: 0, isValidOpenKey: true),
                Key(name: "C#/Db", value: 1, isValidOpenKey: false),
                Key(name: "D", value: 2, isValidOpenKey: true),
                Key(name: "D#/Eb", value: 3, isValidOpenKey: false),
                Key(name: "E", value: 4, isValidOpenKey: true),
                Key(name: "F", value: 5, isValidOpenKey: false),
                Key(name: "F#/Gb", value: 6, isValidOpenKey: false),
                Key(name: "G", value: 7, isValidOpenKey: true),
                Key(name: "G#/Ab", value: 8, isValidOpenKey: false),
                Key(name: "A", value: 9, isValidOpenKey: true),
                Key(name: "A#/Bb", value: 10, isValidOpenKey: false),
                Key(name: "B", value: 11, isValidOpenKey: false)
        ]
        return defaultKeys
    }

    private func persistKeys() {
        let defaults = NSUserDefaults.standardUserDefaults()
        NSKeyedArchiver.setClassName("Key", forClass: Key.self)
        let data = NSKeyedArchiver.archivedDataWithRootObject(keys)
        defaults.setObject(data, forKey: keyListKeyConstant)
        
    }
    
    private func retrieveKeys() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(keyListKeyConstant) as? NSData {
            NSKeyedUnarchiver.setClass(Key.self, forClassName: "Key")
            keys = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Key]
        }
    }
 
    func removePersistedKeys() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(keyListKeyConstant)
    }
    
    func resetDefaultKeys() {
        keys = getDefaultKeys()
        persistKeys()
    }

    func getAllKeys() -> [Key] {
        return keys as [Key]
    }
    
    func getValidOpenKeys() -> [Key] {
        return keys.filter() {key in
            return key.keyOpenValid
        }
    }
    
    func updateValidOpenKey(updatedKey: Key, isValid: Bool) {
        let idx = updatedKey.keyVal
        keys[idx] = Key(name: updatedKey.keyName, value: updatedKey.keyVal, isValidOpenKey: isValid)
        persistKeys()
    }
}
