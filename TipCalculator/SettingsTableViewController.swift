//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by Emily M Yang on 7/29/15.
//  Copyright (c) 2015 Experiences Evolved. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController, UITableViewDelegate {
    

    @IBOutlet weak var defaultTip: UITextField!

    @IBOutlet weak var tipInt: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        var defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("defaultTip") != nil) {
            defaultTip.text = defaults.objectForKey("defaultTip") as! String
        }
        else{
            defaultTip.text = "15"
        }
        
        if (defaults.objectForKey("tipInt") != nil) {
            tipInt.text = defaults.objectForKey("tipInt") as! String
        }
        else{
            self.tipInt.text = "5"
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveNewDefaultTip(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(defaultTip.text, forKey: "defaultTip")
    }
    
    @IBAction func saveNewTipInt(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tipInt.text, forKey: "tipInt")
    }
    


    
}