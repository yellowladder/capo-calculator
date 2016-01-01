//
//  MasterViewController.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 11/27/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

protocol ConcertKeySelectionDelegate: class {
    func concertKeySelected(concertKey: Key)
}

class MasterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var concertKeyPicker: UIPickerView!
    weak var delegate: ConcertKeySelectionDelegate?
    
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

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaultKeyVal = CapoCalculatorAPI.sharedInstance.getDefaultKeyVal()
        
        concertKeyPicker.delegate = self
        concertKeyPicker.dataSource = self
        concertKeyPicker.selectRow(defaultKeyVal, inComponent: pickerComponent.name.rawValue, animated: false)
        
        getPickedConcertKey()
    }
    
    
    func updateDelegate() {
        self.delegate?.concertKeySelected(pickedConcertKey)
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
        getPickedConcertKey()
        updateDelegate()
        
        if let detailViewController = self.delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    
}

