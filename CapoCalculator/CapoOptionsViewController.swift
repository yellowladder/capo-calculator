//
//  CapoOptionsViewController.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class CapoOptionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var concertKeyPickedText: UILabel!
    @IBOutlet weak var concertKeyPicker: UIPickerView!
    @IBOutlet weak var tuningLabel: UILabel!
    @IBOutlet weak var availOptionsText: UITextView!
    
    let pickerData = [
        CapoCalculatorAPI.sharedInstance.getAllKeyNames()
    ]
    
    enum pickerComponent:Int{
        case name = 0
    }
    
    var pickedConcertKey = Key()
  
    // MARK: Instance Methods
    
    func getKeyByName(name: String) -> Key {
        return CapoCalculatorAPI.sharedInstance.getKeyByName(name)
    }
    
    func getPickedConcertKey () {
        let nameComponent = pickerComponent.name.rawValue
        let pickedKeyName = pickerData[nameComponent][concertKeyPicker.selectedRowInComponent(nameComponent)]
        pickedConcertKey = getKeyByName(pickedKeyName)
    }
    
    func updatePickedText() {
        concertKeyPickedText.text = "Concert Key: " + pickedConcertKey.keyName
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
    
    func getSelectionAndDisplayResults() {
        getPickedConcertKey()
        updatePickedText()
        let resultsArr = getResults()
        displayResults(resultsArr)
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        concertKeyPicker.delegate = self
        concertKeyPicker.dataSource = self
        concertKeyPicker.selectRow(2, inComponent: pickerComponent.name.rawValue, animated: false)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateResults:",name:"update", object: nil)
        
        setTuningFromSavedDefaults()
        getSelectionAndDisplayResults()
    }
    
    func updateResults(notification: NSNotification){
        setTuningFromSavedDefaults()
        getSelectionAndDisplayResults()
    }

    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
    //    // Dispose of any resources that can be recreated.
   // }


    // MARK: Delegates and DataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getSelectionAndDisplayResults()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    
}

