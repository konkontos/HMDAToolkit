//
//  HMDAFatProgressView.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 04/07/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable open class HMDAFatProgressView: UIProgressView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = barRounding
        layer.masksToBounds = true
    }
    
    @IBInspectable public var barHeight: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var barRounding: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = barRounding
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: barHeight)
    }
    
}
