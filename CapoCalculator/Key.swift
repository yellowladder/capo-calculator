//
//  Key.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

@objc(Key)
class Key : NSObject, NSCoding {
    var keyVal: Int = -1
    var keyName: String = "Undefined"
    var keyOpenValid: Bool = false
    
    convenience init(name: String, value: Int, isValidOpenKey: Bool)
    {
        self.init()
        self.keyVal = value
        self.keyName = name
        self.keyOpenValid = isValidOpenKey
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.keyVal = aDecoder.decodeIntegerForKey("keyVal")
        self.keyName = aDecoder.decodeObjectForKey("keyName") as! String
        self.keyOpenValid = aDecoder.decodeBoolForKey("keyOpenValid")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(keyVal, forKey: "keyVal")
        aCoder.encodeObject(keyName, forKey: "keyName")
        aCoder.encodeBool(keyOpenValid, forKey: "keyOpenValid")
    }
    
    func availableCapoKey(let concertKeyVal: Int) -> Int {
        let intermedVal = concertKeyVal - keyVal
        if (intermedVal >= 0) {
            return intermedVal
        }
        else {
            return intermedVal + 12
        }
    }
}