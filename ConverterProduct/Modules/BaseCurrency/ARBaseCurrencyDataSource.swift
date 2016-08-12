//
//  ARBaseCurrencyDataSource.swift
//  ConverterProduct
//
//  Created by Omikron on 09.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import RxSwift
import RxCocoa

class ARBaseCurrencyDataSource: NSObject, UIScrollViewDelegate {
    
    private let cellRI = "ATBaseCurrencyTableViewCell"
    private var currentBaseCurrency = ARCurrencyService.sharedInstance.currentBaseCurrency
    
    init(tableView : UITableView) {
        
        super.init()
        
        tableView.registerNib(UINib.init(nibName: cellRI, bundle: nil), forCellReuseIdentifier: cellRI)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        ARCurrencyService.sharedInstance.availableCurrency.asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier(cellRI, cellType: ATBaseCurrencyTableViewCell.self)) { (row, element, cell) in
                
                    cell.fillCell(element.currencyAbb)
                
                    if element.currencyAbb == ARCurrencyService.sharedInstance.currentBaseCurrency.value {
                        cell.accessoryType = .Checkmark
                    } else {
                        cell.accessoryType = .None
                    }
                
                }
        .addDisposableTo(disposeBag)
        
        tableView
            .rx_modelSelected(ARCurrencyRate)
            .subscribeNext { value in
                ARCurrencyService.sharedInstance.currentBaseCurrency.value = value.currencyAbb
                print(ARCurrencyService.sharedInstance.currentBaseCurrency.value)
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
