//
//  HMDAGradientView.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 29/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
open class HMDAGradientView: UIView {

    @IBInspectable var startingColor: UIColor?
    @IBInspectable var endingColor: UIColor?
    
    var startingPoint = CGPoint(x: 0.5, y: 1)
    var endingPoint = CGPoint(x: 0.5, y: 0)
    
    var gradientType = CAGradientLayerType.axial
    
    var gradientLocations: [NSNumber]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
    private func setup() {
        layer.sublayerWithName(name: "gradient")?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.bounds = bounds
        gradientLayer.name = "gradient"
        
        gradientLayer.colors = [startingColor?.cgColor ?? UIColor.black.cgColor, endingColor?.cgColor ?? UIColor.white.cgColor]
        
        gradientLayer.startPoint = startingPoint
        gradientLayer.endPoint = endingPoint
        
        gradientLayer.type = gradientType
        
        gradientLayer.locations = gradientLocations
        
        layer.addSublayer(gradientLayer)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

/*
    override func draw(_ rect: CGRect) {
        // Drawing code
     
    }
*/

    

}
