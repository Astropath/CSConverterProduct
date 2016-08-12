//
//  ARTestServerCalls.swift
//  ConverterProduct
//
//  Created by Omikron on 04.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import Foundation
import RxSwift

class ARTestServerCalls: NSObject, ARServerConnectionProtocol {
    
    func getRatesData(currentBaseCurrency : String) -> Observable<ARRatesList> {
        return Observable.just(ARRatesList(dict: [:]))
    }
    
}