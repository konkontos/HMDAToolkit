//
//  HMDANonOrphanLabel.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 16/04/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public class HMDANonOrphanLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // TODO: needs more testing for case of wrapping to more than 1 line
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var drawRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        let originalText = text
        
        text = text?.formattedForNonOrphanWrapping
        drawRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        if drawRect.size.height > font.lineHeight + 0.5 {
            return drawRect
        } else {
            text = originalText
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        
    }
    
}
