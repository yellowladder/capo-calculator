//
//  CapoCalculatorTests.swift
//  CapoCalculatorTests
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import XCTest
@testable import CapoCalculator

class CapoCalculatorTests: XCTestCase {
    
    override class func tearDown() {
        // Called once after all tests are run
        super.tearDown()
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
    }
    
    func testKeyInitialization() {
        //success case
        let potentialKey = Key(name: "MyKey", value: 0, isValidOpenKey: true)
        XCTAssertNotNil(potentialKey)
        
        let emptyKey = Key()
        XCTAssertNotNil(emptyKey)
        
    }
    
    func testApiGetAllKeys() {
        let allKeys = CapoCalculatorAPI.sharedInstance.getAllKeys()
        let expectedCount = 12
        XCTAssert(allKeys.count == expectedCount)
    }

    func testApiGetAllKeyNames() {
        let allKeyNames = CapoCalculatorAPI.sharedInstance.getAllKeyNames()
        let expectedCount = 12
        XCTAssert(allKeyNames.count == expectedCount)
    }

    func testApiGetDefaultValidOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 5
        XCTAssert(allValidOpenKeys.count == expectedCount)
    }
    
    func testApiInvalidateOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        CapoCalculatorAPI.sharedInstance.makeKeyInvalid("D")
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 4
        XCTAssert(allValidOpenKeys.count == expectedCount)
    }
    
    func testApiValidateOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        CapoCalculatorAPI.sharedInstance.makeKeyValid("F")
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 6
        XCTAssert(allValidOpenKeys.count == expectedCount)
    }
    
    func testApiGetKeyByName() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let foundKey = CapoCalculatorAPI.sharedInstance.getKeyByName("E")
        let expectedKeyVal = 4
        XCTAssert(foundKey.keyVal == expectedKeyVal)
    }
    
    func testApiGetKeyByValue() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let foundKey = CapoCalculatorAPI.sharedInstance.getKeyByValue(4)
        let expectedKeyName = "E"
        XCTAssert(foundKey.keyName == expectedKeyName)
    }
    
    func testApiDefaultTuning() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let foundTuning = CapoCalculatorAPI.sharedInstance.getTuning()
        let expectedTuning = 0
        XCTAssert(foundTuning == expectedTuning)
    }
    
    func testApiChangeTuning() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let intendedTuning = 2
        CapoCalculatorAPI.sharedInstance.updateTuning(intendedTuning)
        let foundTuning = CapoCalculatorAPI.sharedInstance.getTuning()
        let expectedTuning = 2
        XCTAssert(foundTuning == expectedTuning)
    }
}
