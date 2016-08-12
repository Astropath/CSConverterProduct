//
//  ARConvertCurrencyListDataSource.swift
//  ConverterProduct
//
//  Created by Omikron on 10.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ARConvertCurrencyListDataSource: NSObject, UIScrollViewDelegate {

    private let cellRI = "ATBaseCurrencyTableViewCell"
    private var currentBaseCurrency = ARCurrencyService.sharedInstance.currentBaseCurrency
    
    init(tableView : UITableView) {
        
        super.init()
        
        tableView.registerNib(UINib.init(nibName: cellRI, bundle: nil), forCellReuseIdentifier: cellRI)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        ARCurrencyService.sharedInstance.availableCurrency.asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier(cellRI, cellType: ATBaseCurrencyTableViewCell.self)) { (row, element, cell) in
                
                cell.fillCell(element.currencyAbb)
                
                if ARCurrencyService.sharedInstance.selectedCurrencyArray.value.contains(element) == true {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
                
            }
        .addDisposableTo(disposeBag)
        
        tableView
            .rx_modelSelected(ARCurrencyRate)
            .subscribeNext { value in
                if ARCurrencyService.sharedInstance.selectedCurrencyArray.value.contains(value) == true {
                    let array = ARCurrencyService.sharedInstance.selectedCurrencyArray.value
                    ARCurrencyService.sharedInstance.selectedCurrencyArray.value.removeAtIndex(array.indexOf(value)!)
                    var dataArray = NSUserDefaults.standardUserDefaults().objectForKey(kSelectedCurrencyArray) as! Array<String>
                    dataArray.removeAtIndex(dataArray.indexOf(value.currencyAbb)!)
                    NSUserDefaults.standardUserDefaults().setObject(dataArray, forKey: kSelectedCurrencyArray)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                } else {
                    ARCurrencyService.sharedInstance.selectedCurrencyArray.value.append(value)
                    
                    var dataArray = NSUserDefaults.standardUserDefaults().objectForKey(kSelectedCurrencyArray) as! Array<String>
                    dataArray.append(value.currencyAbb)
                    
                    NSUserDefaults.standardUserDefaults().setObject(dataArray, forKey: kSelectedCurrencyArray)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }

                tableView.reloadData()
            }
        .addDisposableTo(disposeBag)
        
        weak var weakSelf = self
        tableView.rx_setDelegate(weakSelf!)
        .dispose()
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
}
