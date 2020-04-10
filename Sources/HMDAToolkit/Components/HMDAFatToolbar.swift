//
//  HMDAFatToolbar.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 28/08/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
open class HMDAFatToolbar: UIToolbar {
    
    @IBInspectable open var barHeight: CGFloat = 20.0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var barItemMargin: CGFloat = 8.0
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: barHeight)
    }
    
}
