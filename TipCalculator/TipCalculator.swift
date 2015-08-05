//
//  TipCalculator.swift
//  TipCalculator
//
//  Created by Emily M Yang on 7/29/15.
//  Copyright (c) 2015 Experiences Evolved. All rights reserved.
//

import Foundation

class TipCalculator {
    
    var total: Double
    
    init(total: Double) {
        self.total = total
    }
    
    
    func calcTipWithTipPct(tipPct: Double) -> Double {
        return total * tipPct
    }
    
    func calcBillTotal(tipPct: Double) -> Double{
        return total + (total*tipPct)
    }
    
}