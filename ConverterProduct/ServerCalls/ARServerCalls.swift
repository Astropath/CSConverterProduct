//
//  ARServerCalls.swift
//  ConverterProduct
//
//  Created by Omikron on 04.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

private let SERVER_API_URL = "http://api.fixer.io/"

class ARServerCalls: NSObject, ARServerConnectionProtocol {
    
    func getRatesData(currentBaseCurrency : String) -> Observable<ARRatesList> {
        let stringURL = SERVER_API_URL + "latest"
        return request(.GET, stringURL, parameters: ["base" : currentBaseCurrency] , encoding: .URL, headers: [:]).flatMap {
            $0
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .rx_JSON()
                .map { json in
                    let response = json as? NSDictionary
                    let rateList = ARRatesList(dict: response!)
                    return rateList
            }
        }
    }
    
}
