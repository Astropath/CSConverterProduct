//
//  ARMainViewController.swift
//  ConverterProduct
//
//  Created by Omikron on 05.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

var disposeBag = DisposeBag()

class ARMainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var notValidWarningLabel: UILabel!
    @IBOutlet weak var lostInternetConnectionLabel: UILabel!
    @IBOutlet weak var currentBaseCurrencyButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let showBaseCurrencySegue = "showBaseCurrencySegue"
    private let showConvertCurrencyListSegue = "showConvertCurrencyListSegue"
    
    private var dataSource : ARSelectedCurrencyDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ARSelectedCurrencyDataSource(tableView: tableView)
        
        weak var weakSelf = self
        
        let valueValid = scoreTextField.rx_text
            .map { Double($0) != nil || $0.characters.count == 0}
            .shareReplay(1)
        
        valueValid
            .bindTo(notValidWarningLabel.rx_hidden)
        .addDisposableTo(disposeBag)
        
        let internetAvailable =  ARCurrencyService.sharedInstance.isInternetConnectionAvailable.asObservable()
            .map { $0 == true }
            .shareReplay(1)
        
        internetAvailable
            .bindTo(lostInternetConnectionLabel.rx_hidden)
        .addDisposableTo(disposeBag)
        
        scoreTextField.rx_text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (text) in
               weakSelf!.dataSource!.convertedValue = (text as NSString).doubleValue
               weakSelf!.tableView.reloadData()
               print(text)
            }, onError: { (error) in
                
            }, onCompleted: { 
                
            }) { 
                
            }
        .addDisposableTo(disposeBag)
        
        ARCurrencyService.sharedInstance.currentBaseCurrency.asObservable()
            .subscribeNext { (newValue) in
               weakSelf!.title = newValue
               weakSelf!.currentBaseCurrencyButton.setImage(UIImage(named: newValue), forState: .Normal)
        }
        .addDisposableTo(disposeBag)
        
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            setupScoreTextField()
            setupEmptyLabel()
        }

    }
    
    func setupScoreTextField() {
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ARMainViewController.doneButtonTap))]
        numberToolbar.sizeToFit()
        scoreTextField.inputAccessoryView = numberToolbar
    }
    
    func setupEmptyLabel() {
        let countCheck = ARCurrencyService.sharedInstance.selectedCurrencyArray.asObservable()
            .map { $0.count > 0}
            .shareReplay(1)
        
        countCheck
            .bindTo(emptyLabel.rx_hidden)
            .addDisposableTo(disposeBag)
    }
    
    func doneButtonTap() {
        scoreTextField.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 15 // Bool
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectMainCurrencyButtonTap(sender: AnyObject) {
        performSegueWithIdentifier(showBaseCurrencySegue, sender: nil)
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

