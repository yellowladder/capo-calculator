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
    
    @IBOutlet weak var availOptionsLabel: UILabel!
    
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
        availOptionsLabel.text?.removeAll()
        var strBuild = String()
        strBuild = "Available Options:\n"
        for result in resultsArr {
            strBuild.appendContentsOf(result)
        }
        availOptionsLabel.text?.appendContentsOf(strBuild)
    }
    
    func getSelectionAndDisplayResults() {
        getPickedConcertKey()
        updatePickedText()
        let resultsArr = getResults()
        displayResults(resultsArr)
        
    }

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        concertKeyPicker.delegate = self
        concertKeyPicker.dataSource = self
        concertKeyPicker.selectRow(2, inComponent: pickerComponent.name.rawValue, animated: false)
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

