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
    
    let defaultCapoKeyPickerRow = 0
    var capoKeyResultArr = [CapoKeyResult]()
    
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

    func updateCapoKeyResultArr() {
        var capoKeys = CapoCalculatorAPI.sharedInstance.getOpenKeyValuePairs(pickedConcertKey)
        capoKeys.sortInPlace({ $0.capoPosition < $1.capoPosition})
        capoKeyResultArr = capoKeys
    }
    
    func getCapoKeyResults() -> [String] {
        var capoKeysArr = [String]()
        if capoKeyResultArr.count > 0 {
            for capoKey in capoKeyResultArr {
                capoKeysArr.append(capoKey.formattedResult())
            }
        }
        return capoKeysArr
    }
    
    func getTranspositionResult(pickerRow: Int) -> TranspositionResult {
        let capoKeyResult = capoKeyResultArr[pickerRow]
        let capoKey = CapoCalculatorAPI.sharedInstance.getKeyByName(capoKeyResult.openKeyName)
        let transResult = TranspositionResult(concertKey: pickedConcertKey, capoKey: capoKey, capoPosition: capoKeyResult.capoPosition)
        
        return transResult
    }
    
    func updateCapoKeyPicker() {
        updateCapoKeyResultArr()
        let capoKeysArr = getCapoKeyResults()
        pickerData = [capoKeysArr]
        capoKeyPicker.selectRow(defaultCapoKeyPickerRow, inComponent: pickerComponent.name.rawValue, animated: false)
        capoKeyPicker.reloadAllComponents()
    }
    
    
    func updateResults(notification: NSNotification){
        setTuningFromSavedDefaults()
        updateCapoKeyPicker()
        updateTranspositionTextView(defaultCapoKeyPickerRow)
    }
    
    func updateTranspositionTextView(pickerRow: Int){
        var strBuild = String()
        
        let transpositionResult = getTranspositionResult(pickerRow)
        strBuild = "Transposition Guide " + transpositionResult.formattedName() + ":\n"
        
        let formattedPairs = transpositionResult.formattedPairs()
        for pair in formattedPairs {
            strBuild.appendContentsOf(pair + "\n")
        }
        transpositionTextView.text.removeAll()
        transpositionTextView.text.appendContentsOf(strBuild)
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
        updateCapoKeyPicker()
        updateTranspositionTextView(defaultCapoKeyPickerRow)
    }
    


    
// MARK: Delegates and DataSource

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            updateTranspositionTextView(row)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }

}

extension DetailViewController: ConcertKeySelectionDelegate {
    func concertKeySelected(concertKey: Key) {
        setPickedConcertKey(concertKey)
        updateCapoKeyPicker()
        updateTranspositionTextView(defaultCapoKeyPickerRow)
    }
}