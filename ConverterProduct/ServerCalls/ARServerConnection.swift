//
//  ARServerConnection.swift
//  ConverterProduct
//
//  Created by Omikron on 04.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

protocol ARServerConnectionProtocol {
    func getRatesData(currentBaseCurrency : String) -> Observable<ARRatesList>
}

class ARServerConnection: NSObject {
    
    static func get() -> ARServerConnectionProtocol {
        return ARServerCalls()
    }
    
}
