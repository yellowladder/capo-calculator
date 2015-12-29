//
//  CapoCalculatorAPI.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class CapoCalculatorAPI: NSObject {
    
    static let sharedInstance = CapoCalculatorAPI()

    private let persistencyManager: PersistencyManager
    
    override private init() {
        persistencyManager = PersistencyManager()
        super.init()
    }
    
    // MARK: Keys 
    
    func getAllKeys() -> [Key] {
        return persistencyManager.getAllKeys()
    }
    
    func getAllKeyNames() -> [String] {
        var keyNames = [String]()
        let allKeys = getAllKeys()
        for key in allKeys{
            keyNames.append(key.keyName)
        }
        return keyNames
    }
    
    func getValidOpenKeys() -> [Key] {
        return persistencyManager.getValidOpenKeys()
    }
    
    func getKeyByName(name: String) -> Key {
        let foundKey = getAllKeys().filter() { ($0 as Key).keyName == name }.first!
        return foundKey
    }
    
    func getKeyByValue(value: Int) -> Key {
        let foundKey = getAllKeys().filter() { ($0 as Key).keyVal == value }.first!
        return foundKey
    }

    func getOpenKeyValuePairs(concertKey: Key) -> [CapoKeyResult] {
        let tuning = getTuning()
        var capoKeys = [CapoKeyResult]()
        for key in getValidOpenKeys() {
            capoKeys.append(CapoKeyResult(openKeyName: key.keyName, capoPosition: key.availableCapoKey(concertKey.keyVal, tuning: tuning)))
        }
        return capoKeys
    }
    
    func makeKeyValid(name:String) {
        let thisKey = getKeyByName(name)
        persistencyManager.updateValidOpenKey(thisKey, isValid: true)
    }

    @nonobjc
    func makeKeyValid(value: Int) {
        let thisKey = getKeyByValue(value)
        persistencyManager.updateValidOpenKey(thisKey, isValid: true)
    }

    func makeKeyInvalid(name:String) {
        let thisKey = getKeyByName(name)
        persistencyManager.updateValidOpenKey(thisKey, isValid: false)
    }

    @nonobjc
    func makeKeyInvalid(value: Int) {
        let thisKey = getKeyByValue(value)
        persistencyManager.updateValidOpenKey(thisKey, isValid: false)
    }

    func resetDefaultKeys() {
        persistencyManager.resetDefaultKeys()
    }
    
    // MARK: Tuning
    
    func resetDefaultTuning() {
        persistencyManager.resetDefaultTuning()
    }
    
    func getTuning() -> Int {
        return persistencyManager.getTuning()
    }
    
    func updateTuning(updatedTuning: Int) {
        persistencyManager.updateTuning(updatedTuning)
    }
}
