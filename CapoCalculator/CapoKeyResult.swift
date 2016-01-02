//
//  CapoKeyResult.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/28/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class CapoKeyResult {
    var openKeyName: String = "Undefined"
    var capoPosition: Int = -1
    
    convenience init(name: String, capoPosition: Int) {
        self.init()
        self.openKeyName = name
        self.capoPosition = capoPosition
    }
    
    func formattedResult() -> String {
        var strFormatted = String()
        if self.capoPosition == 0 {
            strFormatted = "Open in " + self.openKeyName + "\n"
        }
        else {
            strFormatted = "Capo " + String(self.capoPosition) + " in " + self.openKeyName + "\n"
        }
        return strFormatted
    }
}
