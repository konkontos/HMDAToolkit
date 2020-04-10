//
//  HMDAKnobProgressView.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 25/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable public class HMDAKnobProgressView: UIView {

    public enum AnimationType {
        case animated(TimeInterval)
        case none
    }
    
    public var animation = AnimationType.none
    
    @IBInspectable public var displayPercentage: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var displayKnob: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var percentageTextColor: UIColor = UIColor.white
    
    @IBInspectable public var percentageTextFont: UIFont = UIFont.systemFont(ofSize: 10.0)
    
    @IBInspectable public var barMargin: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progress: Float = 0 {
        didSet {
            
            if progress < 0 {
                progress = 0
            }
            
            if progress > 1 {
                progress = 1
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var knobColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var barTint: UIColor = UIColor.yellow {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progressTint: UIColor = UIColor.orange {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        // Draw Border
        let drawRect = CGRect(x: rect.origin.x,
                              y: rect.size.height / 2.0 - ((rect.size.height - barMargin) / 2.0),
                              width: rect.size.width,
                              height: rect.size.height - barMargin)
        
        let barOutline = UIBezierPath(roundedRect: drawRect, cornerRadius: cornerRadius)
        barOutline.lineWidth = borderWidth
        borderColor.setStroke()
        barOutline.stroke()
        
        // Draw fill
        
        let fillRect = CGRect(x: rect.origin.x + 1.0,
                              y: rect.size.height / 2.0 - ((rect.size.height - barMargin) / 2.0),
                              width: rect.size.width - cornerRadius / 4.0,
                              height: rect.size.height - barMargin - 1.0)
        
        let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: cornerRadius)
        
        barTint.setFill()
        fillPath.fill()
        
        // Calculate Knob
        
        var knobRectX = (CGFloat(progress) * rect.size.width)
        
        if progress > 0 && progress < 1 {
            knobRectX = knobRectX - rect.size.height / 2.0
        }
        
        if progress == 1 {
            knobRectX = knobRectX - rect.size.height
        }
        
        // Draw Progress Bar
        
        progressTint.setFill()
        
        if progress > 0 {
            var barRectWidth: CGFloat = 0
            
            if displayKnob == true {
                barRectWidth = knobRectX + rect.size.height / 2.0
            } else {
                knobRectX = (CGFloat(progress) * rect.size.width)
                barRectWidth = knobRectX + rect.size.height / 2.0
            }
            
            let barRect = CGRect(x: 1,
                                 y: rect.size.height / 2.0 - ((rect.size.height - barMargin) / 2.0),
                                 width: barRectWidth,
                                 height: rect.size.height - barMargin)
            
            let barPath = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)
            
            switch animation {
                
            case .none:
                barPath.fill()
                
            case .animated(let duration):
                layer.sublayerWithName(name: "barProgressLayer")?.removeFromSuperlayer()
                
                let barPathLayer = CAShapeLayer()
                barPathLayer.path = barPath.cgPath
                barPathLayer.fillColor = progressTint.cgColor
                barPathLayer.name = "barProgressLayer"
                barPathLayer.strokeColor = UIColor.clear.cgColor
                
                barPathLayer.anchorPoint = CGPoint(x: 1, y: 0)
                
                let barFillAnimation = CABasicAnimation(keyPath: "bounds.size.width")
                barFillAnimation.duration = duration
                barFillAnimation.fromValue = NSNumber(value: Float(barRectWidth))
                barFillAnimation.toValue = NSNumber(value: Float(0))
                barFillAnimation.isRemovedOnCompletion = false
                barFillAnimation.fillMode = .both
                
                layer.addSublayer(barPathLayer)
                
                barPathLayer.add(barFillAnimation, forKey: "boundsAnimation")
            }
            
        }
        
        // Draw Knob
        let knobRect = CGRect(x: knobRectX,
                              y: 0,
                              width: rect.size.height,
                              height: rect.size.height)
        
        if displayKnob == true {
            let knobPath = UIBezierPath(ovalIn: knobRect)
            knobColor.setFill()
            knobPath.fill()
        }
        
        // Draw percentage
        
        if displayPercentage == true {

            
            let fontHeight = percentageTextFont.capHeight + percentageTextFont.ascender + percentageTextFont.descender
            
            let originY = knobRect.size.height / 2.0 - (fontHeight / 2.0)
            
            let textRect = CGRect(x: knobRect.origin.x,
                                  y: originY,
                                  width: knobRect.size.width,
                                  height: fontHeight)
            
            
            let percentageStr = NSString(string: "\(String(Int((progress * 100).rounded(.up))))%")
            
            let para = NSMutableParagraphStyle()
            para.alignment = NSTextAlignment.center
            
            percentageStr.draw(in: textRect,
                               withAttributes: [
                                NSAttributedString.Key.foregroundColor: percentageTextColor,
                                NSAttributedString.Key.font: percentageTextFont,
                                NSAttributedString.Key.paragraphStyle:para
                                                ])
            
        }
        
    }
 
}
