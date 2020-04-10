//
//  HMDAButton.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 06/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class HMDAButton: UIButton {
    
    internal var originalImage: UIImage?
    
    @IBInspectable public var imageSizeX: CGFloat = 54.0 {
        
        didSet {
            setScaledImage()
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var imageSizeY: CGFloat = 54.0 {
        
        didSet {
            setScaledImage()
            setNeedsDisplay()
        }
        
    }
    
    override public func prepareForInterfaceBuilder() {
        setScaledImage()
    }
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setScaledImage()
        
    }
    
    internal func setScaledImage() {
        
        if originalImage == nil {
            originalImage = image(for: .normal)
        }
        
        if let scaledimage = originalImage!.scaledImageWithSize(CGSize(width: imageSizeX, height: imageSizeY)) {
            setImageForAllStates(scaledimage)
        }
        
    }
    
}
