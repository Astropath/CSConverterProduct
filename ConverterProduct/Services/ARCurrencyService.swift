//
//  ARCurrencyService.swift
//  ConverterProduct
//
//  Created by Omikron on 05.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import RxSwift
import ReachabilitySwift

class ARCurrencyService: NSObject {
    
    static let sharedInstance = ARCurrencyService()
    
    var currentBaseCurrency = Variable<String>("")
    
    var availableCurrency = Variable<Array<ARCurrencyRate>>([])
    var selectedCurrencyArray = Variable<Array<ARCurrencyRate>>([])
    
    var isInternetConnectionAvailable = Variable<Bool>(false)
    var reachability: Reachability? = nil
    
    var availableCurrencyIsLoaded = false
    
    
    private override init() {
        
        super.init()
        weak var weakSelf = self
        
        setupReachability(weakSelf!)
        
        // request data on current currency
        
        requestDataOfCurrentCurrency()
        
        // request all available currency
        
        requestAllAvailableCurrency()
        
    }
    
    //MARK: - Reachability
    
    func setupReachability(weakSelf : ARCurrencyService) {
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        
        reachability!.whenReachable = { reachability in
            weak var weakSelf = self
            dispatch_async(dispatch_get_main_queue()) {
                
                if self.availableCurrencyIsLoaded == false {
                    weakSelf!.requestAllAvailableCurrency()
                }
                
                weakSelf!.isInternetConnectionAvailable.value = true
            }
        }
        reachability!.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                weakSelf.isInternetConnectionAvailable.value = false
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    //MARK: - Helpers
    
    func requestDataOfCurrentCurrency() {
        weak var weakSelf = self
        currentBaseCurrency.value = NSUserDefaults.standardUserDefaults().objectForKey(kLastChoosen) as! String
        
        currentBaseCurrency.asObservable().subscribe(onNext: { (newValue) in
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kLastChoosen)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            ARServerConnection.get().getRatesData(newValue).subscribe(onNext: { ratesListObject in
                var newSelectedRatesArray : Array<ARCurrencyRate> = []
                for oldRate in weakSelf!.selectedCurrencyArray.value {
                    for newRate in ratesListObject.rates {
                        if oldRate.currencyAbb == newRate.currencyAbb {
                            newSelectedRatesArray.append(newRate)
                            break
                        }
                    }
                }
                
                weakSelf!.availableCurrency.value = ratesListObject.rates
                weakSelf!.selectedCurrencyArray.value = newSelectedRatesArray
                }, onError: { error in
                    let nsError = error as NSError
                    ARRootAlertController.showErrorAlertWithParameters(nsError.localizedDescription)
                    print(nsError.localizedDescription)
            }) {
                
                }.addDisposableTo(disposeBag)
            
            }, onError: { (error) in
                
                let nsError = error as NSError
                ARRootAlertController.showErrorAlertWithParameters(nsError.localizedDescription)
                print(nsError.localizedDescription)
            }, onCompleted: {
                
        }) {
            
            }
            .addDisposableTo(disposeBag)
    }
    
    func requestAllAvailableCurrency() {
        weak var weakSelf = self
        let baseCurrency = NSUserDefaults.standardUserDefaults().objectForKey(kLastChoosen) as! String
        
        ARServerConnection.get().getRatesData(baseCurrency).subscribe(onNext: { ratesListObject in
            weakSelf!.availableCurrency.value = ratesListObject.rates
            weakSelf!.availableCurrencyIsLoaded = true
            
            if NSUserDefaults.standardUserDefaults().objectForKey(kSelectedCurrencyArray) != nil {
                let dataArray = NSUserDefaults.standardUserDefaults().objectForKey(kSelectedCurrencyArray) as! Array<String>
                var oldSelectedCurrencyArray : Array<ARCurrencyRate> = []
                for rate in ratesListObject.rates {
                    for rateAbb in dataArray {
                        if rateAbb == rate.currencyAbb {
                            oldSelectedCurrencyArray.append(rate)
                        }
                    }
                }
                weakSelf!.selectedCurrencyArray.value = oldSelectedCurrencyArray
            }
            
            }, onError: { error in
                let nsError = error as NSError
                ARRootAlertController.showErrorAlertWithParameters(nsError.localizedDescription)
                print(nsError.localizedDescription)
        }) {
            
            }
            .addDisposableTo(disposeBag)

    }

}
