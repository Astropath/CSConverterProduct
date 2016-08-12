//
//  UIViewController+AlertController.swift
//  ConverterProduct
//
//  Created by Omikron on 11.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ARRootAlertController : NSObject {
    
    static func showAlertWithParameters(title : String, message : String, buttonText : String) {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: buttonText, style: .Default, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
    static func showErrorAlertWithParameters(message : String) {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
}
