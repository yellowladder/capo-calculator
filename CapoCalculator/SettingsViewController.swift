//
//  SettingsViewController.swift
//  CapoCalculator
//
//  Created by Jeff Brumley on 12/28/15.
//  Copyright © 2015 Yellow Ladder Productions. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: Outlets and Properties
    
    
    @IBOutlet weak var validKeyC: UISwitch!
    @IBOutlet weak var validKeyCSh: UISwitch!
    @IBOutlet weak var validKeyD: UISwitch!
    @IBOutlet weak var validKeyDSh: UISwitch!
    @IBOutlet weak var validKeyE: UISwitch!
    @IBOutlet weak var validKeyF: UISwitch!
    @IBOutlet weak var validKeyFSh: UISwitch!
    @IBOutlet weak var validKeyG: UISwitch!
    @IBOutlet weak var validKeyGSh: UISwitch!
    @IBOutlet weak var validKeyA: UISwitch!
    @IBOutlet weak var validKeyASh: UISwitch!
    @IBOutlet weak var validKeyB: UISwitch!
    
    @IBOutlet var validKeySwitchCollection: [UISwitch]!
    
    
    
    // MARK: Instance Methods
    
    func setValidKeyInUI(keyVal: Int, isValid: Bool) {
        let mySwitch = validKeySwitchCollection.filter() { ($0 as UISwitch).tag == keyVal }.first!
        mySwitch.setOn(isValid, animated: false)
    }
    
    func setValidKeysFromSavedDefaults() {
        var allKeys = [Key]()
        allKeys = CapoCalculatorAPI.sharedInstance.getAllKeys()

        if allKeys.count > 0 {
            for key in allKeys {
                setValidKeyInUI(key.keyVal, isValid: key.keyOpenValid)
            }
        }
    }
    
    func validKeySwitchStateChanged(changedSwitch: UISwitch) {
        let keyVal = changedSwitch.tag
        let switchVal = changedSwitch.on
        
        switch switchVal {
        case true:
            CapoCalculatorAPI.sharedInstance.makeKeyValid(keyVal)
        case false:
            CapoCalculatorAPI.sharedInstance.makeKeyInvalid(keyVal)
        }
    }
    
    func addSwitchHandlers() {
        for mySwitch in validKeySwitchCollection {
            mySwitch.addTarget(self, action: Selector("validKeySwitchStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setValidKeysFromSavedDefaults()
        addSwitchHandlers()
    }
    
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
    //    // Dispose of any resources that can be recreated.
    // }
    
    
    // MARK: Delegates and DataSource
    
    
    
}

