//
//  Extensions.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 8/4/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    class func instanceFromStoryboard<T>() -> T? {
        let storyboard = UIStoryboard(name: "\(String(describing: T.self))", bundle: nil)
        return storyboard.instantiateInitialViewController() as? T
    }
    
}


public extension UINib {
    
    class func instanceFromNib<T>() -> T? {
        let nib = UINib(nibName: "\(String(describing: T.self))", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? T
    }
    
}


public extension UIView {
    
    class func instantiateFromNib() -> Self? {
        return UINib.instanceFromNib()
    }
    
    class func instantiateFromStoryboard() -> Self? {
        return UIStoryboard.instanceFromStoryboard()
    }
    
}


public extension UIViewController {
    
    class func instantiateFromNib() -> Self? {
        return UINib.instanceFromNib()
    }
    
    class func instantiateFromStoryboard() -> Self? {
        return UIStoryboard.instanceFromStoryboard()
    }
    
}
