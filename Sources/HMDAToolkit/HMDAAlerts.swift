//
//  HMDAAlerts.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 20/09/2016.
//  Copyright © 2016 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func alert(withTitle: String?, message: String?, cancelText: String?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: cancelText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(withTitle: String?, message: String?, cancelText: String?, handler:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: cancelText, style: UIAlertAction.Style.cancel, handler: handler)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func alert(withTitle: String?, message: String?, cancelText: String?, userActionText: String?, userActionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: cancelText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let userAction = UIAlertAction(title: userActionText, style: UIAlertAction.Style.default, handler: userActionHandler)
        alert.addAction(userAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func alert(withTitle: String?, message: String?, cancelText: String?, cancelAction cancelActionHandler:((UIAlertAction) -> Void)?, userActionText: String?, userAction userActionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if cancelText != nil && cancelActionHandler != nil {
            let cancelAction = UIAlertAction(title: cancelText, style: UIAlertAction.Style.cancel, handler: cancelActionHandler)
            alert.addAction(cancelAction)
        }
        
        if userActionText != nil && userActionHandler != nil {
            let userAction = UIAlertAction(title: userActionText, style: UIAlertAction.Style.default, handler: userActionHandler)
            alert.addAction(userAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func alertWith(withTitle: String?, message: String?, textfieldConfig: @escaping ((UITextField) -> Void), cancelText: String?, cancelAction cancelActionHandler:((UIAlertAction) -> Void)?, userActionText: String?, userAction userActionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: textfieldConfig)
        
        if cancelText != nil && cancelActionHandler != nil {
            let cancelAction = UIAlertAction(title: cancelText, style: UIAlertAction.Style.cancel, handler: cancelActionHandler)
            alert.addAction(cancelAction)
        }
        
        if userActionText != nil && userActionHandler != nil {
            let userAction = UIAlertAction(title: userActionText, style: UIAlertAction.Style.default, handler: userActionHandler)
            alert.addAction(userAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}


