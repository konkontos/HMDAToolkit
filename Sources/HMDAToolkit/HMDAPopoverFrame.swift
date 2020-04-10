//
//  HMDAPopoverFrame.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 9/4/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDAPopoverFrame: UIPopoverBackgroundView {
    
    var arrowColor: UIColor?
    
    var backgroundImage: UIImage?
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        if #available(iOS 13, *) {
            removeIOSDecorativeViews()
            layer.shadowColor = UIColor.clear.cgColor
        }
        
    }
        
    
    // MARK: Drawing
    
    func drawArrow(in rect: CGRect) {
        
        (arrowColor ?? UIColor.black).setFill()
        
        let arrow = UIBezierPath()
        
        switch arrowDir {
            
        case .up:
            let pointA = CGPoint(x: rect.midX + arrowOffset,
                                 y: HMDAPopoverFrame.arrowHeight())
            
            let pointB = CGPoint(x: rect.midX + arrowOffset + HMDAPopoverFrame.arrowBase(),
                                 y: HMDAPopoverFrame.arrowHeight())
            
            let pointC = CGPoint(x: rect.midX + arrowOffset + (HMDAPopoverFrame.arrowBase() / 2.0),
                                 y: 0)
            
            arrow.move(to: pointA)
            arrow.addLine(to: pointB)
            arrow.addLine(to: pointC)
            arrow.addLine(to: pointA)
            
            
        case .down:
            let pointA = CGPoint(x: rect.midX + arrowOffset,
                                 y: rect.height - HMDAPopoverFrame.arrowHeight() - HMDAPopoverFrame.arrowHeight() / 2.0)
            
            let pointB = CGPoint(x: rect.midX + arrowOffset + HMDAPopoverFrame.arrowBase(),
                                 y: rect.height - HMDAPopoverFrame.arrowHeight() - HMDAPopoverFrame.arrowHeight() / 2.0)
            
            let pointC = CGPoint(x: rect.midX + arrowOffset + (HMDAPopoverFrame.arrowBase() / 2.0),
                                 y: rect.height)
            
            arrow.move(to: pointA)
            arrow.addLine(to: pointB)
            arrow.addLine(to: pointC)
            arrow.addLine(to: pointA)

            
        case .left:
            let pointA = CGPoint(x: HMDAPopoverFrame.arrowHeight(),
                                 y: rect.midY + arrowOffset)
            
            let pointB = CGPoint(x: HMDAPopoverFrame.arrowHeight(),
                                 y: rect.midY + arrowOffset + HMDAPopoverFrame.arrowBase())
            
            let pointC = CGPoint(x: 0,
                                 y: rect.midY + arrowOffset + (HMDAPopoverFrame.arrowBase() / 2.0))
            
            arrow.move(to: pointA)
            arrow.addLine(to: pointB)
            arrow.addLine(to: pointC)
            arrow.addLine(to: pointA)
            
            
        case .right:
            let pointA = CGPoint(x: rect.width - HMDAPopoverFrame.arrowHeight(),
                                 y: rect.midY + arrowOffset)
            
            let pointB = CGPoint(x: rect.width - HMDAPopoverFrame.arrowHeight(),
                                 y: rect.midY + arrowOffset + HMDAPopoverFrame.arrowBase())
            
            let pointC = CGPoint(x: rect.width,
                                 y: rect.midY + arrowOffset + (HMDAPopoverFrame.arrowBase() / 2.0))
            
            arrow.move(to: pointA)
            arrow.addLine(to: pointB)
            arrow.addLine(to: pointC)
            arrow.addLine(to: pointA)
            
        default:
            break
            
        }
        
        arrow.fill()
    }
    
    override public func draw(_ rect: CGRect) {

        var adjustedRect = rect
        
        switch arrowDir {
            
        case .up:
            adjustedRect.size = CGSize(width: rect.width,
                                       height: rect.height - HMDAPopoverFrame.arrowHeight())
            
            adjustedRect = adjustedRect.offsetBy(dx: 0, dy: HMDAPopoverFrame.arrowHeight())
            
        case .down:
            adjustedRect.size = CGSize(width: rect.width,
                                       height: rect.height - HMDAPopoverFrame.arrowHeight())
            
            adjustedRect = adjustedRect.offsetBy(dx: 0, dy: -HMDAPopoverFrame.arrowHeight())
            
        case .left:
            adjustedRect.size = CGSize(width: rect.width - HMDAPopoverFrame.arrowHeight(),
                                       height: rect.height)
            
            adjustedRect = adjustedRect.offsetBy(dx: HMDAPopoverFrame.arrowHeight(), dy: 0)
            
        case .right:
            adjustedRect.size = CGSize(width: rect.width - HMDAPopoverFrame.arrowHeight(),
                                       height: rect.height)
            
            adjustedRect = adjustedRect.offsetBy(dx: -HMDAPopoverFrame.arrowHeight(), dy: 0)
            
        default:
            break
            
        }
            
        drawArrow(in: adjustedRect)
        
        backgroundImage?.draw(in: adjustedRect)
    }
    
    
    var offsetVal: CGFloat = 0
    
    override public var arrowOffset: CGFloat {
        
        get {
            return offsetVal
        }
        
        set(newValue) {
            offsetVal = newValue
            
            setNeedsLayout()
        }
        
    }
    
    class override public var wantsDefaultContentAppearance: Bool {
        false
    }
    
    var arrowDir: UIPopoverArrowDirection = .any
    
    override public var arrowDirection: UIPopoverArrowDirection {
        
        get {
            return arrowDir
        }
        
        set(newValue) {
            arrowDir = newValue
            
            setNeedsLayout()
        }
        
    }
    
    
    // MARK: UIPopoverBackgroundViewMethods
    
    static override public func contentViewInsets() -> UIEdgeInsets {
        UIEdgeInsets.zero
    }
    
    static override public func arrowBase() -> CGFloat {
        36.0
    }
    
    static override public func arrowHeight() -> CGFloat {
        24.0
    }
    
    
    // MARK: Misc
    
    @available(iOS 13,*)
    private func removeIOSDecorativeViews() {
            
            func removeSpecializedViews(in view: UIView) {
                
                for subview in view.subviews {
                    // UIDimmingView
                    // _UICutoutShadowView
                    // UIDropShadowView
                    
                    if String(describing: subview.classForCoder).starts(with: "_") {
                        subview.removeFromSuperview()
                    }
                    
    /*
                    if String(describing: subview.classForCoder).starts(with: "UIDimmingView") {
                        subview.removeFromSuperview()
                    }
    */
                    
                    if String(describing: subview.classForCoder).starts(with: "UIDropShadowView") {
                        subview.backgroundColor = UIColor.clear
                    }
                    
                }
                
            }
            
            let keyWindow = UIApplication.shared.connectedScenes.filter { (scene) -> Bool in
                scene.activationState == .foregroundActive ? true : false
            }.compactMap { (scene) -> UIWindowScene? in
                scene as? UIWindowScene
            }.first?.windows.filter({ (window) -> Bool in
                window.isKeyWindow == true ? true:false
                }).first
            
            for subview in (keyWindow?.subviews)! {
                removeSpecializedViews(in: subview)
            }
            
        }
    
}
