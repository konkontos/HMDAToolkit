//
//  HMDAVerticalOffsetLabel.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 06/05/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable open class HMDAVerticalOffsetLabel: UILabel {

    @IBInspectable public var verticalOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var verticalOrigin: CGFloat?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override open func drawText(in rect: CGRect) {
        var drawRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        
        let verticalOrigin = drawRect.origin.y
            
        drawRect.origin = CGPoint(x: drawRect.origin.x, y: verticalOrigin + verticalOffset)
        
        super.drawText(in: drawRect)
    }
    
}
