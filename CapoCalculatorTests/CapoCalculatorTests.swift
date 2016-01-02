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
    
    // MARK: Utility 
    
    override class func tearDown() {
        // Called once after all tests are run
        super.tearDown()
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
    }
    
    // MARK: Keys
    
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
        XCTAssertEqual(allKeys.count, expectedCount)
    }

    func testApiGetAllKeyNames() {
        let allKeyNames = CapoCalculatorAPI.sharedInstance.getAllKeyNames()
        let expectedCount = 12
        XCTAssertEqual(allKeyNames.count, expectedCount)
    }

    func testApiGetDefaultValidOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 5
        XCTAssertEqual(allValidOpenKeys.count, expectedCount)
    }
    
    func testApiInvalidateOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        CapoCalculatorAPI.sharedInstance.makeKeyInvalid("D")
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 4
        XCTAssertEqual(allValidOpenKeys.count, expectedCount)
    }
    
    func testApiValidateOpenKeys() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        CapoCalculatorAPI.sharedInstance.makeKeyValid("F")
        let allValidOpenKeys = CapoCalculatorAPI.sharedInstance.getValidOpenKeys()
        let expectedCount = 6
        XCTAssertEqual(allValidOpenKeys.count, expectedCount)
    }
    
    func testApiGetKeyByName() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let foundKey = CapoCalculatorAPI.sharedInstance.getKeyByName("E")
        let expectedKeyVal = 4
        XCTAssertEqual(foundKey.keyVal, expectedKeyVal)
    }
    
    func testApiGetKeyByValue() {
        CapoCalculatorAPI.sharedInstance.resetDefaultKeys()
        let foundKey = CapoCalculatorAPI.sharedInstance.getKeyByValue(4)
        let expectedKeyName = "E"
        XCTAssertEqual(foundKey.keyName, expectedKeyName)
    }
    
    // MARK: Tuning 
    
    func testApiDefaultTuning() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let foundTuning = CapoCalculatorAPI.sharedInstance.getTuning()
        let expectedTuning = 0
        XCTAssertEqual(foundTuning, expectedTuning)
    }
    
    func testApiChangeTuning() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let intendedTuning = 2
        CapoCalculatorAPI.sharedInstance.updateTuning(intendedTuning)
        let foundTuning = CapoCalculatorAPI.sharedInstance.getTuning()
        let expectedTuning = 2
        XCTAssertEqual(foundTuning, expectedTuning)
    }
    
    
    // MARK: Transposition
    func testCreateTranspositionPairByName() {
        let concertKeyName = "B"
        let capoKeyName = "A"
        let transResult = TranspositionResult(concertKeyName: concertKeyName, capoKeyName: capoKeyName, capoPosition: 2)
        let foundConcertKeyName = transResult.concertKey.keyName
        let foundCapoKeyName = transResult.capoKey.keyName
        XCTAssertEqual(foundConcertKeyName, concertKeyName)
        XCTAssertEqual(foundCapoKeyName, capoKeyName)
    }

    func testCreateTranspositionPairByValue() {
        let concertKeyVal = 2
        let capoKeyVal = 0
        let transResult = TranspositionResult(concertKeyVal: concertKeyVal, capoKeyVal: capoKeyVal, capoPosition: 2)
        let foundConcertKeyVal = transResult.concertKey.keyVal
        let foundCapoKeyVal = transResult.capoKey.keyVal
        XCTAssertEqual(foundConcertKeyVal, concertKeyVal)
        XCTAssertEqual(foundCapoKeyVal, capoKeyVal)
    }
    
    func testApiGetTranspositionPairs() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let concertKey = CapoCalculatorAPI.sharedInstance.getKeyByName("C")
        let capoKey = CapoCalculatorAPI.sharedInstance.getKeyByName("A")
        let foundPairs = CapoCalculatorAPI.sharedInstance.getTranspositionPairs(concertKey, capoKey: capoKey)
        let expectedCount = 12
        let foundCount = foundPairs.count
        XCTAssertEqual(foundCount, expectedCount)
    }
     
    
    func testApiTranspositionStaysWithTuningChange() {
        CapoCalculatorAPI.sharedInstance.resetDefaultTuning()
        let intendedTuning = -1
        CapoCalculatorAPI.sharedInstance.updateTuning(intendedTuning)
        let concertKey = CapoCalculatorAPI.sharedInstance.getKeyByName("A#/Bb")
        let capoKey = CapoCalculatorAPI.sharedInstance.getKeyByName("A")
        let foundPairs = CapoCalculatorAPI.sharedInstance.getTranspositionPairs(concertKey, capoKey: capoKey)
        let foundCapoKey = foundPairs[concertKey]
        XCTAssertEqual(capoKey.keyName, foundCapoKey?.keyName)
    }
    
    func testTranspositionResultReturnsPairs() {
        let transResult = TranspositionResult(concertKeyName: "B", capoKeyName: "A", capoPosition: 2)
        let foundPairs = transResult.transpositionPairs()
        let expectedCount = 12
        let foundCount = foundPairs.count
        XCTAssertEqual(foundCount, expectedCount)
    }
    
    func testTranspositionResultFormattedReturnsPairs() {
        let transResult = TranspositionResult(concertKeyName: "C", capoKeyName: "A", capoPosition: 3)
        let foundFormattedPairs = transResult.formattedPairs()
        let expectedCount = 12
        let foundCount = foundFormattedPairs.count
        XCTAssertEqual(foundCount, expectedCount)
    }
    
    func testTranspositionResultFormattedOrderedPairs() {
        let transResult = TranspositionResult(concertKeyName: "C", capoKeyName: "A", capoPosition: 3)
        let foundFormattedPairs = transResult.formattedPairs()
        let expectedOutputAtIndex0 = "C -> A"
        let expectedOutputAtIndex11 = "B -> G#/Ab"
        let foundOutputAtIndex0 = foundFormattedPairs[0]
        let foundOutputAtIndex11 = foundFormattedPairs[11]
        XCTAssertEqual(foundOutputAtIndex0, expectedOutputAtIndex0)
        XCTAssertEqual(foundOutputAtIndex11, expectedOutputAtIndex11)
    }
}
