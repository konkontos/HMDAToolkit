//
//  HMDAUtils+Graphics.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 12/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension CALayer {
    
    func normalizedPosition(fromPosition currentPosition: CGPoint) -> CGPoint {
        let xPos = currentPosition.x - (bounds.width * anchorPoint.x)
        let yPos = currentPosition.y - (bounds.height * anchorPoint.y)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func removeAllSublayers() {
        
        guard sublayers != nil else {
            return
        }
        
        for sublayer in sublayers! {
            sublayer.removeFromSuperlayer()
        }
        
    }
    
    func addCircularGradientBorder(colors: [UIColor], width: CGFloat) -> CALayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        })
        
        gradient.frame = bounds
        gradient.frame.origin.x -= width / 4.0
        gradient.frame.origin.y -= width / 4.0
        gradient.frame.size.width += width / 2.0
        gradient.frame.size.height += width / 2.0
        gradient.cornerRadius = gradient.frame.size.width / 2.0
        
        insertSublayer(gradient, at: 0)
        
        return gradient
    }
    
    func sublayerWithName(name: String) -> CALayer? {
        
        guard sublayers != nil else {
            return nil
        }
        
        for layer in sublayers! {
            
            if layer.name == name {
                return layer
            }
            
        }
        
        return nil
    }
    
    func setFlippedVertically(isFlipped: Bool, inRect rect: CGRect?) {
        
        if isFlipped {
            
            guard rect != nil else {
                return
            }
            
            self.isGeometryFlipped = true
            self.position = CGPoint(x: self.position.x, y: rect!.size.height)
        } else {
            self.isGeometryFlipped = false
            self.position = CGPoint.zero
        }
        
    }
    
}

public extension CGRect {
    
    func reduced(by points: CGFloat) -> CGRect {
        
        let newWidth = self.size.width - points
        let newHeight = self.size.height - points
        
        let newOriginX = self.origin.x + (points / 2.0)
        let newOriginY = self.origin.y + (points / 2.0)
        
        return CGRect(x: newOriginX,
                      y: newOriginY,
                      width: newWidth,
                      height: newHeight)
    }
    
}

public extension CATransform3D {
    
    static func halfSizeTransform(inRect rect: CGRect) -> CATransform3D {
        var transformHalfSize = CATransform3DIdentity
        transformHalfSize = CATransform3DTranslate(transformHalfSize, rect.size.width / 2.0, rect.size.height / 2.0, 0)
        transformHalfSize = CATransform3DScale(transformHalfSize, 0.5, 0.5, 1.0)
        transformHalfSize = CATransform3DTranslate(transformHalfSize, -rect.size.width / 2.0, -rect.size.height / 2.0, 0)
        
        return transformHalfSize
    }
    
    static func fullSizeTransform(inRect rect: CGRect) -> CATransform3D {
        var transformFullSize = CATransform3DIdentity
        transformFullSize = CATransform3DTranslate(transformFullSize, rect.size.width / 2.0, rect.size.height / 2.0, 0)
        transformFullSize = CATransform3DScale(transformFullSize, 1.0, 1.0, 1.0)
        transformFullSize = CATransform3DTranslate(transformFullSize, -rect.size.width / 2.0, -rect.size.height / 2.0, 0)
        
        return transformFullSize
    }
    
}
