//
//  ARRatesList.swift
//  ConverterProduct
//
//  Created by Omikron on 04.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import Foundation

class ARRatesList: NSObject {
    
    let baseRate : ARCurrencyRate
    let date : String
    let rates : Array<ARCurrencyRate>

    init(dict: NSDictionary) {
        
        baseRate = ARCurrencyRate(abbr: dict.objectForKey("base") as! String, rate: 1.0)
        date = dict.objectForKey("date") as! String
        
        let ratesDict = dict.objectForKey("rates") as! NSDictionary
        var ratesArray : Array<ARCurrencyRate> = []
        ratesArray.append(baseRate)
        for (key, value) in ratesDict {
            ratesArray.append(ARCurrencyRate(abbr: key as! String, rate: value.doubleValue))
        }
        ratesArray.sortInPlace { (a, b) -> Bool in
            return a.currencyAbb < b.currencyAbb
        }
        rates = ratesArray
        
    }
    
}