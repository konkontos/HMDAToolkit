//
//  HMDAUtils+UIImage.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/04/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit


public extension UIImage {
    
    func scaledImageWithSize(_ scaledSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: scaledSize.width, height: scaledSize.height))
        self.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func aspectCentered(inRect rect: CGRect) -> UIImage {
        
        if rect.width == rect.height {
            return self
        }
        
        
        if rect.width > rect.height {
            let imageSize = CGSize(width: rect.width, height: rect.width)
            UIGraphicsBeginImageContext(imageSize)
            
            var drawRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            drawRect.origin.y -= ((rect.width - rect.height) / 4.0)
            
            self.draw(in: drawRect)
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return scaledImage ?? UIImage()
        }
        
        
        if rect.height > rect.width {
            let imageSize = CGSize(width: rect.height, height: rect.height)
            UIGraphicsBeginImageContext(imageSize)
            
            var drawRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            drawRect.origin.x -= ((rect.height - rect.width) / 4.0)
            
            self.draw(in: drawRect)
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return scaledImage ?? UIImage()
        }
        
        return UIImage()
        
    }
    
    class func blankImage(with backgroundColor: UIColor = UIColor.white, and blankImageSize: CGSize = CGSize(width: 64, height: 64)) -> UIImage? {
        UIGraphicsBeginImageContext(blankImageSize)
        let rect = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: blankImageSize))
        backgroundColor.setFill()
        rect.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


