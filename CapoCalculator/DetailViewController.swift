//
//  DetailViewController.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 12/31/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    // , UIPickerViewDataSource, UIPickerViewDelegate {

// MARK: Outlets and Properties

    @IBOutlet weak var concertKeyPickedText: UILabel!
    @IBOutlet weak var tuningLabel: UILabel!
    @IBOutlet weak var availOptionsText: UITextView!
    
    
    
    enum pickerComponent:Int{
        case name = 0
    }
    
    var pickedConcertKey = Key()
    
    
    
// MARK: Instance Methods

    @nonobjc
    func setPickedConcertKey (concertKey: Key) {
        pickedConcertKey = concertKey
        updatePickedText()
    }
    
    func updatePickedText() {
        concertKeyPickedText.text = "Concert Key: " + pickedConcertKey.keyName
    }
    
    func setPickedConcertKeyFromDefaults() {
        let defaultKeyVal = CapoCalculatorAPI.sharedInstance.getDefaultKeyVal()
        let defaultKey = CapoCalculatorAPI.sharedInstance.getKeyByValue(defaultKeyVal)
        setPickedConcertKey(defaultKey)
    }
    
    // TODO: eliminate redundancy with Settings
    func setTuningFromSavedDefaults() {
        let tuning = CapoCalculatorAPI.sharedInstance.getTuning()
        setTuningInUI(tuning)
    }
    
    // TODO: eliminate redundancy with Settings
    func setTuningInUI(tuning: Int) {
        var tuningStr = String()
        switch tuning {
        case 0:
            tuningStr = "Std"
        case 1:
            tuningStr = "+1"
        case 2:
            tuningStr = "+2"
        case -1:
            tuningStr = "-1"
        case -2:
            tuningStr = "-2"
        default:
            tuningStr = "Invalid"
        }
        tuningLabel.text = "Tuning: " + tuningStr
    }

    func getResults() -> [String] {
        var capoKeys = CapoCalculatorAPI.sharedInstance.getOpenKeyValuePairs(pickedConcertKey)
        capoKeys.sortInPlace({ $0.capoPosition < $1.capoPosition})
        var resultsArr = [String]()
        if capoKeys.count > 0 {
            for capoKey in capoKeys {
                if capoKey.capoPosition == 0 {
                    resultsArr.append("Open in " + capoKey.openKeyName + "\n")
                }
                else {
                    resultsArr.append("Capo " + String(capoKey.capoPosition) + " in " + capoKey.openKeyName + "\n")
                }
            }
        }
        return resultsArr
    }
    
    func displayResults(resultsArr: [String]) {
        var strBuild = String()
        strBuild = "Available Options:\n"
        for result in resultsArr {
            strBuild.appendContentsOf(result)
        }
        availOptionsText.text.removeAll()
        availOptionsText.text.appendContentsOf(strBuild)
    }
    
    func getAndDisplayResults() {
        let resultsArr = getResults()
        displayResults(resultsArr)
    }
    
    func updateResults(notification: NSNotification){
        setTuningFromSavedDefaults()
        getAndDisplayResults()
    }
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateResults:",name:"update", object: nil)
        
        setTuningFromSavedDefaults()
        setPickedConcertKeyFromDefaults()
        getAndDisplayResults()
    }
    


    
// MARK: Delegates and DataSource


}

extension DetailViewController: ConcertKeySelectionDelegate {
    func concertKeySelected(concertKey: Key) {
        setPickedConcertKey(concertKey)
        getAndDisplayResults()
    }
}