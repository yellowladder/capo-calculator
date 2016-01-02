//
//  TranspositionResult.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 1/1/16.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class TranspositionResult {
    var concertKey: Key = Key()
    var capoKey: Key = Key()
    var capoPosition: Int = -1
    
    convenience init(concertKey: Key, capoKey: Key, capoPosition: Int) {
        self.init()
        self.concertKey = concertKey
        self.capoKey = capoKey
        self.capoPosition = capoPosition
    }
    
    convenience init(concertKeyName: String, capoKeyName: String, capoPosition: Int) {
        self.init()
        self.concertKey = CapoCalculatorAPI.sharedInstance.getKeyByName(concertKeyName)
        self.capoKey = CapoCalculatorAPI.sharedInstance.getKeyByName(capoKeyName)
        self.capoPosition = capoPosition
    }
    
    convenience init(concertKeyVal: Int, capoKeyVal: Int, capoPosition: Int) {
        self.init()
        self.concertKey = CapoCalculatorAPI.sharedInstance.getKeyByValue(concertKeyVal)
        self.capoKey = CapoCalculatorAPI.sharedInstance.getKeyByValue(capoKeyVal)
        self.capoPosition = capoPosition
    }
    
    func formattedCapoPosition() -> String {
        var strFormatted = String()
        if self.capoPosition == 0 {
            strFormatted = "Open"
        }
        else
        {
            strFormatted = "Capo " + String(self.capoPosition)
        }
        return strFormatted
    }
    
    func formattedName() -> String {
        var strFormatted = String()
        if concertKey.keyName == capoKey.keyName {
            strFormatted = "(no change)"
        }
        else {
            strFormatted = "from Concert " + concertKey.keyName + " to " + capoKey.keyName + "(" + formattedCapoPosition() + ")"
        }
        return strFormatted
    }
    
    func transpositionPairs() -> [Key:Key] {
        let pairs = CapoCalculatorAPI.sharedInstance.getTranspositionPairs(self.concertKey, capoKey: self.capoKey)
        return pairs
    }
    
    func formattedPairs() -> [String] {
        var formattedStr = [String]()
        let chordList = CapoCalculatorAPI.sharedInstance.getAllKeys()
        let pairs = transpositionPairs()
        for chord in chordList {
            let foundTransChord = pairs[chord]
            if (foundTransChord != nil)
            {
               formattedStr.append(chord.keyName + " -> " + foundTransChord!.keyName)
            }
        }
        return formattedStr
    }
}
