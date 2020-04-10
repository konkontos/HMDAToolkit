//
//  HMDACircularToggleImageButton.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 13/02/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable open class HMDACircularToggleImageButton: UIButton {

    @IBInspectable public var gradientBorderRotationAngle: CGFloat = 0 {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var useGradientBorder: Bool = false {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var gradientStartColor: UIColor = UIColor.lightGray {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    
    @IBInspectable public var gradientEndColor: UIColor = UIColor.clear {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0.5 {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var selectedBorderColor: UIColor = UIColor.red {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var borderWidth: CGFloat = 10.0 {
        
        didSet {
            imageEdgeInsets = UIEdgeInsets(top: borderWidth,
                                           left: borderWidth,
                                           bottom: borderWidth,
                                           right: borderWidth)
            
        }
        
    }
    
    // MARK: - Lifecycle
    
    override open func awakeFromNib() {
        super.awakeFromNib()
     
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowOpacity = shadowOpacity.floatValue
        
        setup(.masking)
    }
    
    
    override open func prepareForInterfaceBuilder() {
        borderWidth = 10.0
        selectedBorderColor = UIColor.white
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowOpacity = shadowOpacity.floatValue
        
        setup(.masking)
    }
    

    // MARK: - Drawing
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if !isSelected, useGradientBorder == true {
            layer.sublayerWithName(name: "gradientBorder")?.removeFromSuperlayer()
            addGradient()
        }
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        layer.cornerRadius = layer.bounds.width / 2.0
        
        layer.sublayerWithName(name: "gradientBorder")?.removeFromSuperlayer()
        
        super.draw(rect)
        
        if isSelected {
            layer.borderWidth = borderWidth
            layer.borderColor = selectedBorderColor.cgColor
        } else {
            
            if useGradientBorder {
                layer.borderWidth = 0
                
                addGradient()
            } else {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor.cgColor
            }
            
        }
        
    }

    func addGradient() {

        let gradientLayer = layer.addCircularGradientBorder(colors: [gradientStartColor, gradientEndColor], width: borderWidth)
        gradientLayer.name = "gradientBorder"
        
        if gradientBorderRotationAngle > 0 {
            gradientLayer.transform = CATransform3DMakeRotation(gradientBorderRotationAngle, 0, 0, 1)
        }
        
    }
    
    // MARK: - Masking
    
    var originalImage: UIImage? {
       return image(for: .normal)
    }
    
    private var blackMaskCGImage: CGImage? {
        
        guard let maskImage = blackMask?.cgImage else {
            return nil
        }
        
        return CGImage(maskWidth: Int(bounds.width),
                height: Int(bounds.height),
                bitsPerComponent: maskImage.bitsPerComponent,
                bitsPerPixel: maskImage.bitsPerPixel,
                bytesPerRow: maskImage.bytesPerRow,
                provider: maskImage.dataProvider!,
                decode: nil,
                shouldInterpolate: true)
        
    }
    
    private var blackMask: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        
        UIColor.white.setFill()
        UIBezierPath(rect: bounds).fill()
        
        UIColor.black.setFill()
        UIBezierPath(ovalIn: bounds).fill()
        
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return maskImage
    }
    
    
    private var maskedImage: UIImage? {
        
        guard let originalImageCG = originalImage?.cgImage else {
            return nil
        }
        
        if let maskImage = blackMaskCGImage {
            
            if let finalImage = originalImageCG.masking(maskImage) {
                let im = UIImage(cgImage: finalImage)
                return im
            } else {
                return nil
            }
            
        } else {
            return nil
        }
        
    }
    
    public enum PresentationType {
        case masking
        case nonMasking
    }
    
    public func setup(_ type: PresentationType) {
        
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        
        if type == .masking {
            setImage(maskedImage, for: .normal)
            setImage(maskedImage, for: .selected)
            setImage(maskedImage, for: .highlighted)
            setImage(maskedImage, for: .disabled)
        } else {
            setImage(originalImage, for: .normal)
            setImage(originalImage, for: .selected)
            setImage(originalImage, for: .highlighted)
            setImage(originalImage, for: .disabled)
        }
        
    }
    
}
