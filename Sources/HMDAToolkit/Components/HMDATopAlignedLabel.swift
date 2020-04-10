//
//  HMDATopAlignedLabel.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 15/08/16.
//  Copyright © 2016 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class HMDATopAlignedLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawText(in rect: CGRect) {
        var drawRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        
        drawRect.origin = CGPoint(x: drawRect.origin.x, y: 0)
        
        super.drawText(in: drawRect)
    }
}
