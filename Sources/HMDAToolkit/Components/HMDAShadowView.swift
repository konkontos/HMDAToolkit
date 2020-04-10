//
//  HMDAShadowView.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 21/09/2017.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class HMDAShadowView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10.0
        layer.shadowColor = UIColor.black.cgColor
    }

}
