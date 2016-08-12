//
//  ARIPadViewController.swift
//  ConverterProduct
//
//  Created by Omikron on 11.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ARIPadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self

        ARCurrencyService.sharedInstance.currentBaseCurrency.asObservable()
            .subscribeNext { (newValue) in
                weakSelf!.title = newValue
            }
        .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
