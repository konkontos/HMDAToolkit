//
//  HMDATabBar.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 31/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable open class HMDATabBar: UITabBar {

    @IBInspectable public var height: CGFloat = 40.0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var size = super.sizeThatFits(size)
        
        if size.height > 0 {
            size.height = height
        }
        
        return size
    }
    
}
