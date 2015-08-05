//
//  ViewController.swift
//  TipCalculator
//
//  Created by Emily M Yang on 7/28/15.
//  Copyright (c) 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var colorBackground: UIView!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billInput: UITextField!


    @IBOutlet weak var calculatedTip: UITextView!
    @IBOutlet weak var calculatedBillTotal: UITextView!


    @IBOutlet weak var tipSegmentControl: UISegmentedControl!

    
    var currentString = ""
    var defaultTip = 0.10
    var tipInt = 0.05
    
    let tipCalc = TipCalculator(total: 0)
    
    func refreshUI() {
        // 1
  //      billInput.text = String(format: "%0.2f", tipCalc.total)
        self.tipSegmentControl.setTitle(String(format: "%0.2f", defaultTip*100), forSegmentAtIndex: 1)
        self.tipSegmentControl.setTitle(String(format: "%0.2f", (defaultTip-tipInt)*100), forSegmentAtIndex: 0)
        self.tipSegmentControl.setTitle(String(format: "%0.2f", (defaultTip+tipInt)*100), forSegmentAtIndex: 2)
        
        calculatedTip.text = ""
        calculatedBillTotal.text = ""
    }
    
    func recalculateTipAndTotal(tipPct: Double ){

        if billInput.text != ""{
            var formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale() // This is the default
            //formatter.locale = NSLocale(localeIdentifier: "es_CL")
            //   tipCalc.total = [NSDecimalNumber decimalNumberWithString:textfield.text locale:[NSLocale currentLocale]].doubleValue;
        
            tipCalc.total = formatter.numberFromString(billInput.text)!.doubleValue
            //tipCalc.total = Double((billInput.text as NSString).doubleValue)
            println("recalc: "+billInput.text)
            
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.calculatedTip.alpha = 0.0
                self.calculatedBillTotal.alpha = 0.0
                self.tipLabel.alpha = 0.0
                self.billLabel.alpha = 0.0
                self.colorBackground.alpha = 0.0
                
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    //Once the label is completely invisible, set the text and fade it back in
                    self.calculatedTip.text =  formatter.stringFromNumber(self.tipCalc.calcTipWithTipPct(tipPct))
                    println("calculatedTip: ")
                    println(self.calculatedTip.text)
                    
                    self.calculatedBillTotal.text = formatter.stringFromNumber(self.tipCalc.calcBillTotal(tipPct))
                    println("calculatedBillTotal: ")
                    println(self.calculatedBillTotal.text)
                    
                    // Fade in
                    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.calculatedTip.alpha = 1.0
                        self.calculatedBillTotal.alpha = 1.0
                        self.tipLabel.alpha = 1.0
                        self.billLabel.alpha = 1.0
                        self.colorBackground.alpha = 1.0
                        }, completion: nil)

            })
            

        }
    }
    
    func getSelectedTipAmount() ->Double{
        switch tipSegmentControl.selectedSegmentIndex
        {
        case 0:
            return defaultTip-0.05;
        case 1:
            return defaultTip;
        case 2:
            return defaultTip+0.05;
        default:
            return defaultTip;
        }
    }
    
    //Textfield delegates
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            println(currentString)
            formatCurrency(string: currentString)
        default:
            var array = Array(string)
            var currentStringArray = Array(currentString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(string: currentString)
                
            }
        }
        return false
    }
    
    func formatCurrency(#string: String) {
        println("format \(string)")
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
       // formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: currentString).doubleValue)/100
        billInput.text = formatter.stringFromNumber(numberFromField)
        recalculateTipAndTotal(getSelectedTipAmount())
        println(billInput.text )
    }
    
    @IBAction func tipPercentageChanged(sender : AnyObject) {
        switch tipSegmentControl.selectedSegmentIndex
        {
        case 0:
            recalculateTipAndTotal(defaultTip-tipInt);
        case 1:
            recalculateTipAndTotal(defaultTip);
        case 2:
            recalculateTipAndTotal(defaultTip+tipInt);
        default:
            break;
        }
    }
    
    @IBAction func billAmountChanged(sender : AnyObject) {
        recalculateTipAndTotal(getSelectedTipAmount())
  /*
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billInput.text, forKey: "billAmount") */
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        billInput.resignFirstResponder()
    }
    
    func getDefaults(){
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("defaultTip") != nil) {
            defaultTip = (defaults.objectForKey("defaultTip") as! NSString).doubleValue/100
        }
        else{
            defaultTip = 0.15
        }
        
        if (defaults.objectForKey("tipInt") != nil) {
            tipInt = (defaults.objectForKey("tipInt") as! NSString).doubleValue/100
        }
        else{
            tipInt = 0.05
        }
 
 /*       if (defaults.objectForKey("billAmount") != nil) {
            textField(textField: billInput, shouldChangeCharactersInRange: NSRange, replacementString: <#String#>)
            currentString = defaults.objectForKey("billAmount") as! String
            billInput.text = defaults.objectForKey("billAmount") as! String
            

        }
        else{
            billInput.text = ""
        } */
    
        refreshUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.billInput.delegate = self
        self.billInput.becomeFirstResponder()
        tipSegmentControl.selectedSegmentIndex = 1
        
        getDefaults()
        
        //tipSegmentControl.frame = CGRect(x: 10, y: 10, width: 300, height: 100)
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        getDefaults()
        recalculateTipAndTotal(getSelectedTipAmount())
        formatCurrency(string: currentString)
        
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        formatCurrency(string: currentString)
        recalculateTipAndTotal(getSelectedTipAmount())
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

