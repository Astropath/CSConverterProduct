//
//  ARSelectedCurrencyDataSource.swift
//  ConverterProduct
//
//  Created by Omikron on 05.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import RxSwift
import RxCocoa

class ARSelectedCurrencyDataSource: NSObject, UIScrollViewDelegate {
    
    private let cellRI = "ARConvertTableViewCell"
    var convertedValue : Double = 0.0
    
    init(tableView : UITableView) {
        super.init()
        
        weak var weakSelf = self
        
        tableView.registerNib(UINib.init(nibName: cellRI, bundle: nil), forCellReuseIdentifier: cellRI)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        ARCurrencyService.sharedInstance.selectedCurrencyArray.asObservable().bindTo(tableView.rx_itemsWithCellIdentifier(cellRI, cellType: ARConvertTableViewCell.self)) { (row, element, cell) in
               cell.fillCell(weakSelf!.convertedValue * element.rateValue, imageName: element.currencyAbb)
            }
        .addDisposableTo(disposeBag)
        
        tableView.rx_setDelegate(weakSelf!)
        .dispose()
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }

}
