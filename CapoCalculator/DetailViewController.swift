//
//  DetailViewController.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 12/31/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

// MARK: Outlets and Properties

    @IBOutlet weak var concertKeyLabel: UILabel!
    @IBOutlet weak var tuningLabel: UILabel!
    @IBOutlet weak var capoKeyPicker: UIPickerView!
    @IBOutlet weak var transpositionTextView: UITextView!
    
    enum pickerComponent:Int{
        case name = 0
    }
    
    var pickedConcertKey = Key()
    
    var pickerData = [[String]]()
    
// MARK: Instance Methods

    @nonobjc
    func setPickedConcertKey (concertKey: Key) {
        pickedConcertKey = concertKey
        updatePickedText()
    }
    
    func updatePickedText() {
        concertKeyLabel.text = "Concert Key: " + pickedConcertKey.keyName
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

    func getCapoKeyResults() -> [String] {
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
    
    func updateCapoKeyPicker(capoKeysArr: [String]) {
        pickerData = [capoKeysArr]
        capoKeyPicker.selectRow(0, inComponent: pickerComponent.name.rawValue, animated: false)
        capoKeyPicker.reloadAllComponents()
    }
    
    func getAndDisplayResults() {
        let capoKeysArr = getCapoKeyResults()
        updateCapoKeyPicker(capoKeysArr)
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
        capoKeyPicker.delegate = self
        capoKeyPicker.dataSource = self

        setTuningFromSavedDefaults()
        setPickedConcertKeyFromDefaults()
        getAndDisplayResults()
    }
    


    
// MARK: Delegates and DataSource

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }

}

extension DetailViewController: ConcertKeySelectionDelegate {
    func concertKeySelected(concertKey: Key) {
        setPickedConcertKey(concertKey)
        getAndDisplayResults()
    }
}