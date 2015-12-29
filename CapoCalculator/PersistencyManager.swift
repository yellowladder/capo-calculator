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
    
    let tuningKeyConstant = "tuningKey"
    private var tuning = Int()
    
    override init() {
        super.init()
        retrieveKeys()
        if keys.count == 0 {
            resetDefaultKeys()
        }
        retrieveTuning()
    }
    
    
    // MARK: Keys 
    
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
        defaults.synchronize()
        
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
        defaults.synchronize()
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
    
    
    // MARK: Tuning 
    
    private func getDefaultTuning() -> Int {
        return 0
    }
    
    private func persistTuning() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tuning, forKey: tuningKeyConstant)
        defaults.synchronize()
    }
    
    private func retrieveTuning() {
        let defaults = NSUserDefaults.standardUserDefaults()
        tuning = defaults.integerForKey(tuningKeyConstant)
    }
    
    func removePersistedTuning() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(tuningKeyConstant)
        defaults.synchronize()
    }
    
    func resetDefaultTuning() {
        tuning = getDefaultTuning()
        persistTuning()
    }
    
    func getTuning() -> Int {
        return tuning
    }
    
    func updateTuning(updatedTuning: Int) {
        tuning = updatedTuning
        persistTuning()
    }
}











