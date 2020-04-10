//
//  HMDAPulsatingButton.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 27/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDAPulsatingButton: UIButton {

    public var pulseDuration: CFTimeInterval = 2.5 {
        didSet {
            layer.removeAnimation(forKey: "pulsing")
            setupPulse()
        }
    }
    
    public var scaleFactor: CGFloat = 1.2 {
        didSet {
            layer.removeAnimation(forKey: "pulsing")
            setupPulse()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupPulse()
    }
    
    
    open func setupPulse() {
        layer.removeAnimation(forKey: "pulsing")
        
        let growAnimation = CABasicAnimation()
        growAnimation.keyPath = "transform"
        growAnimation.duration = pulseDuration / 2.0
        growAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        growAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0))
        
        let shrinkAnimation = CABasicAnimation()
        shrinkAnimation.keyPath = "transform"
        shrinkAnimation.beginTime = pulseDuration / 2.0
        shrinkAnimation.duration = pulseDuration / 2.0
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        shrinkAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0))
        shrinkAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [growAnimation, shrinkAnimation]
        animationGroup.duration = pulseDuration
        animationGroup.repeatCount = Float.greatestFiniteMagnitude
        
        layer.add(animationGroup, forKey: "pulsing")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
