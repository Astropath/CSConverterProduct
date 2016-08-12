//
//  ARCurrencyRate.swift
//  ConverterProduct
//
//  Created by Omikron on 05.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ARCurrencyRate: NSObject {
    let currencyAbb : String
    let rateValue : Double
    
    init(abbr: String, rate: Double) {
        currencyAbb = abbr
        rateValue = rate
    }
}
