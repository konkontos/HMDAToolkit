//
//  HMDAProgressHUD
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 11/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class HMDAProgressHUD: UIButton {

    public enum HUDDisplayAnimation {
        case animated(TimeInterval)
        case none
    }
    
    public enum HUDDisplayType {
        case smokey
        case transparent
    }
    
    public enum HUDAnimationType {
        case none
        case pulsating(HUDAnimationConfig)
        case ring(HUDAnimationConfig)
    }
    
    private class HUDInteractionBackdrop: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            NotificationCenter.default.post(name: NSNotification.Name(HUDNotifications.touchOnScreen.rawValue), object: self)
        }
        
    }

    @IBInspectable public var taskProgress: Float = 0 {
        
        didSet {

            if taskProgress < 0 {
                taskProgress = 0
            }
            
            if taskProgress > 1 {
                taskProgress = 1
            }
            
            endAngle = CGFloat((taskProgress * 360.0)) + startAngle
            
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable public var hudProgress: Float = 0.0 {
        
        didSet {
            if hudProgress < 0 {
                
                hudProgress = 0
            }
            
            if hudProgress > 1 {
                hudProgress = 1
            }
            
            setNeedsDisplay()
        }
        
    }
    
    override public var description: String {
        return "\(super.description) | progress = \(taskProgress * 100)%%"
    }
    
    private var startAngle: CGFloat = -90
    private var endAngle: CGFloat = -90
    
    private var hudAnimationType = HUDAnimationType.pulsating
    
    private class var hudButtonFactory: HMDAProgressHUD {
        
        let button = HMDAProgressHUD()
        
        button.buttonColor = UIColor.black
        button.hudProgressColor = UIColor.white
        button.titleLabel?.text = nil
        button.tag = Int.max
        button.translatesAutoresizingMaskIntoConstraints = false
        button.taskProgressBackdropColor = UIColor.clear
        
        return button
    }

    override public func prepareForInterfaceBuilder() {
        setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        NotificationCenter.default.post(name: NSNotification.Name(HUDNotifications.touchOnButton.rawValue), object: self)
    }
    
    override public func draw(_ rect: CGRect) {
        // Drawing code
        
        super.draw(rect)
        
        let buttonPath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                      radius: (rect.width / 2.0) - taskProgressLineWidth,
                                      startAngle: 0,
                                      endAngle: CGFloat(360.degreesToRadians),
                                      clockwise: true)
        
        let taskPath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                        radius: (rect.width / 2.0) - taskProgressLineWidth,
                                        startAngle: CGFloat(startAngle).degreesToRadians,
                                        endAngle: CGFloat(endAngle).degreesToRadians,
                                        clockwise: true)
        
        func drawButton() {
            let circlePathLayer = CAShapeLayer()
            circlePathLayer.path = buttonPath.cgPath
            circlePathLayer.strokeColor = UIColor.clear.cgColor
            circlePathLayer.backgroundColor = UIColor.clear.cgColor
            circlePathLayer.fillColor = buttonColor.cgColor
            circlePathLayer.name = "buttonLayer"
            
            layer.sublayerWithName(name: "buttonLayer")?.removeFromSuperlayer()
            layer.insertSublayer(circlePathLayer, at: 0)
            
            if animateTap {
                let scaleAnimation = CABasicAnimation(keyPath: "transform")
                
                scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3D.halfSizeTransform(inRect: rect))
                scaleAnimation.toValue = NSValue(caTransform3D: CATransform3D.fullSizeTransform(inRect: rect))
                scaleAnimation.duration = CFTimeInterval(buttonTapAnimationDuration)
                
                let animationGroup = CAAnimationGroup()
                animationGroup.fillMode = .forwards
                animationGroup.isRemovedOnCompletion = true
                animationGroup.duration = buttonTapAnimationDuration
                
                animationGroup.animations = [scaleAnimation]
                
                circlePathLayer.add(animationGroup, forKey: "buttonAnimation")
            }
            
        }
        
        func drawAnimatedTaskPath() {
            let taskPathLayer = CAShapeLayer()
            taskPathLayer.path = taskPath.cgPath
            taskPathLayer.lineWidth = taskProgressLineWidth
            taskPathLayer.strokeColor = taskProgressColor.cgColor
            taskPathLayer.backgroundColor = UIColor.clear.cgColor
            taskPathLayer.fillColor = UIColor.clear.cgColor
            taskPathLayer.name = "taskLayer"
            
            let taskPathBackdropLayer = CAShapeLayer()
            taskPathBackdropLayer.path = buttonPath.cgPath
            taskPathBackdropLayer.lineWidth = taskProgressLineWidth
            taskPathBackdropLayer.strokeColor = taskProgressBackdropColor.cgColor
            taskPathBackdropLayer.backgroundColor = UIColor.clear.cgColor
            taskPathBackdropLayer.fillColor = UIColor.clear.cgColor
            taskPathBackdropLayer.name = "taskBackdropLayer"
            
            layer.sublayerWithName(name: "taskLayer")?.removeFromSuperlayer()
            layer.sublayerWithName(name: "taskBackdropLayer")?.removeFromSuperlayer()
            
            layer.addSublayer(taskPathBackdropLayer)
            layer.addSublayer(taskPathLayer)
            
            if animateProgress {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = CFTimeInterval(taskProgressAnimationDuration)
                
                taskPathLayer.add(animation, forKey: "taskAnimation")
            }
            
        }
        
        func drawLoadingProgress() {
            
            guard hudProgress > 0 else {
                layer.sublayerWithName(name: "loadingProgress")?.removeFromSuperlayer()
                return
            }
            
            var fillRect = rect
            let fillHeight = rect.size.height * CGFloat(hudProgress)
            fillRect.size.height = fillHeight
            
            let fillPath = UIBezierPath(rect: fillRect)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = buttonPath.cgPath
            maskLayer.strokeColor = UIColor.clear.cgColor
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.fillColor = UIColor.black.cgColor
            
            let fillLayer = CAShapeLayer()
            fillLayer.path = fillPath.cgPath
            fillLayer.fillColor = hudProgressColor.cgColor
            fillLayer.strokeColor = UIColor.clear.cgColor
            fillLayer.backgroundColor = UIColor.clear.cgColor
            fillLayer.mask = maskLayer
            fillLayer.name = "loadingProgress"
            fillLayer.setFlippedVertically(isFlipped: true, inRect: rect)
            
            layer.sublayerWithName(name: "loadingProgress")?.removeFromSuperlayer()
            layer.insertSublayer(fillLayer, below: titleLabel?.layer)
        }
        
        drawButton()
        
        drawAnimatedTaskPath()
        
        drawLoadingProgress()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
    }
    
    private class func addHUDToScreen(animated: HUDDisplayAnimation, type: HUDDisplayType) -> HMDAProgressHUD? {
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return nil
        }
        
        // transparent full screen, interactive backdrop view
        let hudBackdrop = HUDInteractionBackdrop(frame: CGRect.zero)
        hudBackdrop.backgroundColor = UIColor.clear
        hudBackdrop.isOpaque = true
        hudBackdrop.tag = Int.max - 1
        hudBackdrop.translatesAutoresizingMaskIntoConstraints = false
        hudBackdrop.isUserInteractionEnabled = true
        
        // HUD button
        let hudButton = HMDAProgressHUD.hudButtonFactory
        
        switch animated {
            
        case .animated:
            hudBackdrop.alpha = 0.0
            hudButton.alpha = 0.0
            
        default:
            break
        }
        
        if type == .smokey {
            var color = UIColor.darkGray
            color = color.withAlphaComponent(0.7)
            hudBackdrop.backgroundColor = color
        }
        
        keyWindow!.insertSubview(view: hudBackdrop, at: .top)
        keyWindow!.addConstraints(NSLayoutConstraint.fullScreenConstraints(forView: hudBackdrop))
        
        keyWindow?.insertSubview(view: hudButton, at: .top)
        hudButton.center(inView: keyWindow!)
        
        switch animated {
            
        case .animated(let interval):
            
            NotificationCenter.default.post(name: NSNotification.Name(HUDNotifications.hudWillShow.rawValue), object: self)
            
            UIView.animate(withDuration: interval) {
                hudBackdrop.alpha = 1.0
                hudButton.alpha = 1.0
            }
            
        default:
            break
        }
        
        return hudButton
    }
    
    // MARK: - Public HUD API
    
    public static var defaultHUDSize = CGSize(width: 96, height: 96)
    
    @IBInspectable public var taskProgressAnimationDuration: Double = 1.0
    @IBInspectable public var buttonTapAnimationDuration: Double = 0.2
    
    @IBInspectable public var taskProgressLineWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable public var hudProgressColor: UIColor = UIColor.white
    
    @IBInspectable public var buttonColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var taskProgressColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var taskProgressBackdropColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    public struct HUDAnimationConfig {
        public var outerRingsWidth: CGFloat
        public var innerRingsWidth: CGFloat
        
        public var interRingSpace: CGFloat
        
        public var outerRingLeftSideColor: UIColor
        public var outerRingRightSideColor: UIColor
        
        public var innerRingLeftSideColor: UIColor
        public var innerRingRightSideColor: UIColor
        
        public var animationDuration: TimeInterval
        
        public static var defaultConfig = HUDAnimationConfig(outerRingsWidth: 5,
                                                             innerRingsWidth: 5,
                                                             interRingSpace: 5,
                                                             outerRingLeftSideColor: UIColor.white,
                                                             outerRingRightSideColor: UIColor.black,
                                                             innerRingLeftSideColor: UIColor.black,
                                                             innerRingRightSideColor: UIColor.white,
                                                             animationDuration: 0.7)
    }
    
    public enum HUDNotifications: String {
        case touchOnScreen = "HMDAProgressHUDDidTapOnScreen"
        case touchOnButton = "HMDAProgressHUDDidTapButton"
        case hudWillShow = "HMDAProgressHUDWillShow"
        case hudDidHide = "HMDAProgressHUDDidHide"
    }
    
    public var animateProgress: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var animateTap: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public static var HUDButton: HMDAProgressHUD? {
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return nil
        }
        
        return (keyWindow!.viewWithTag(Int.max) as? HMDAProgressHUD)
    }
    
    public class func setHUDTaskProgress(to progress: Float) {
        
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return
        }
        
        (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD).taskProgress = progress
    }
    
    public class func setHUDProgress(to progress: Float) {
        
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return
        }
        
        (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD).hudProgress = progress
    }
    
    public class func setHUDAnimation(to animationType: HUDAnimationType) {
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return
        }
        
        func removeRingsAnimation() {
            let button = (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD)
            button.layer.sublayerWithName(name: "progressLayerA")?.removeFromSuperlayer()
            button.layer.sublayerWithName(name: "progressLayerB")?.removeFromSuperlayer()
            button.layer.sublayerWithName(name: "progressLayerAA")?.removeFromSuperlayer()
            button.layer.sublayerWithName(name: "progressLayerBB")?.removeFromSuperlayer()
            button.layer.removeAllAnimations()
            
            button.setNeedsDisplay()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            switch animationType {
                
            case .pulsating (let animationConfig):
                
                removeRingsAnimation()
                
                UIView.animate(withDuration: animationConfig.animationDuration,
                               delay: 0,
                               options: [.curveEaseInOut, .autoreverse, .beginFromCurrentState, .repeat],
                               animations: {
                                
                                (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD).transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                                
                },
                               completion: nil)
                
            case .ring (let animationConfig):
                let button = (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD)
                let rect = button.bounds
                
                let progressPathA = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                                 radius: (rect.width / 2.0) - animationConfig.outerRingsWidth,
                                                 startAngle: CGFloat(-90).degreesToRadians,
                                                 endAngle: CGFloat(90).degreesToRadians,
                                                 clockwise: true)
                
                let progressPathB = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                                 radius: (rect.width / 2.0) - animationConfig.outerRingsWidth,
                                                 startAngle: CGFloat(90).degreesToRadians,
                                                 endAngle: CGFloat(270).degreesToRadians,
                                                 clockwise: true)
                
                let progressPathAA = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                                  radius: (rect.width / 2.0) - (animationConfig.innerRingsWidth + (animationConfig.interRingSpace * 2.0)),
                                                  startAngle: CGFloat(-90).degreesToRadians,
                                                  endAngle: CGFloat(-270).degreesToRadians,
                                                  clockwise: false)
                
                let progressPathBB = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                                  radius: (rect.width / 2.0) - (animationConfig.innerRingsWidth + (animationConfig.interRingSpace * 2.0)),
                                                  startAngle: CGFloat(90).degreesToRadians,
                                                  endAngle: CGFloat(270).degreesToRadians,
                                                  clockwise: false)
                
                let progressPathLayerA = CAShapeLayer()
                progressPathLayerA.path = progressPathA.cgPath
                progressPathLayerA.lineWidth = animationConfig.outerRingsWidth
                progressPathLayerA.strokeColor = animationConfig.outerRingRightSideColor.cgColor
                progressPathLayerA.backgroundColor = UIColor.clear.cgColor
                progressPathLayerA.fillColor = UIColor.clear.cgColor
                progressPathLayerA.name = "progressLayerA"
                
                let progressPathLayerB = CAShapeLayer()
                progressPathLayerB.path = progressPathB.cgPath
                progressPathLayerB.lineWidth = animationConfig.outerRingsWidth
                progressPathLayerB.strokeColor = animationConfig.outerRingLeftSideColor.cgColor
                progressPathLayerB.backgroundColor = UIColor.clear.cgColor
                progressPathLayerB.fillColor = UIColor.clear.cgColor
                progressPathLayerB.name = "progressLayerB"
                
                let progressPathLayerAA = CAShapeLayer()
                progressPathLayerAA.path = progressPathAA.cgPath
                progressPathLayerAA.lineWidth = animationConfig.innerRingsWidth
                progressPathLayerAA.strokeColor = animationConfig.innerRingLeftSideColor.cgColor
                progressPathLayerAA.backgroundColor = UIColor.clear.cgColor
                progressPathLayerAA.fillColor = UIColor.clear.cgColor
                progressPathLayerAA.name = "progressLayerAA"
                
                let progressPathLayerBB = CAShapeLayer()
                progressPathLayerBB.path = progressPathBB.cgPath
                progressPathLayerBB.lineWidth = animationConfig.innerRingsWidth
                progressPathLayerBB.strokeColor = animationConfig.innerRingRightSideColor.cgColor
                progressPathLayerBB.backgroundColor = UIColor.clear.cgColor
                progressPathLayerBB.fillColor = UIColor.clear.cgColor
                progressPathLayerBB.name = "progressLayerBB"
                
                let animationFill = CABasicAnimation(keyPath: "strokeEnd")
                animationFill.fromValue = 0
                animationFill.toValue = 1
                animationFill.duration = CFTimeInterval(animationConfig.animationDuration)
                animationFill.repeatCount = Float.greatestFiniteMagnitude
                animationFill.beginTime = 0.0
                animationFill.timeOffset = 0.0
                animationFill.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                animationFill.autoreverses = true
                
                button.layer.sublayerWithName(name: "progressLayerA")?.removeFromSuperlayer()
                button.layer.insertSublayer(progressPathLayerA, below: button.titleLabel?.layer)
                
                button.layer.sublayerWithName(name: "progressLayerB")?.removeFromSuperlayer()
                button.layer.insertSublayer(progressPathLayerB, below: button.titleLabel?.layer)
                
                button.layer.sublayerWithName(name: "progressLayerAA")?.removeFromSuperlayer()
                button.layer.insertSublayer(progressPathLayerAA, below: button.titleLabel?.layer)
                
                button.layer.sublayerWithName(name: "progressLayerBB")?.removeFromSuperlayer()
                button.layer.insertSublayer(progressPathLayerBB, below: button.titleLabel?.layer)
                
                progressPathLayerA.add(animationFill, forKey: "progressAnimationA")
                progressPathLayerB.add(animationFill, forKey: "progressAnimationB")
                
                progressPathLayerAA.add(animationFill, forKey: "progressAnimationAA")
                progressPathLayerBB.add(animationFill, forKey: "progressAnimationBB")
                
            case .none:
                removeRingsAnimation()
                
                (keyWindow!.viewWithTag(Int.max) as! HMDAProgressHUD).transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
        }
        
        
        
    }
    
    public class func showHUD() {
        
        if let hudButton = addHUDToScreen(animated: .none, type: .transparent) {
            hudButton.addConstraints(forWidth: defaultHUDSize.width, andHeight: defaultHUDSize.height)
            
            HMDAProgressHUD.setHUDAnimation(to: .ring(HMDAProgressHUD.HUDAnimationConfig.defaultConfig))
        }
        
    }
    
    public class func showHUD(withDelay timeInterval: TimeInterval) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            showHUD()
        }
        
    }
    
    public class func showHUD(withSize size: CGSize) {
        
        if let hudButton = addHUDToScreen(animated: .none, type: .transparent) {
            hudButton.addConstraints(forWidth: size.width, andHeight: size.height)
        }
        
        HMDAProgressHUD.setHUDAnimation(to: .ring(HMDAProgressHUD.HUDAnimationConfig.defaultConfig))
    }
    
    public class func showHUD(withDelay timeInterval: TimeInterval, withSize size: CGSize) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            showHUD(withSize: size)
        }
        
    }
    
    public class func showHUD(withSize size: CGSize, animated: HUDDisplayAnimation, type: HUDDisplayType) {
        
        if let hudButton = addHUDToScreen(animated: animated, type: type) {
            hudButton.addConstraints(forWidth: size.width, andHeight: size.height)
        }
        
        HMDAProgressHUD.setHUDAnimation(to: .ring(HMDAProgressHUD.HUDAnimationConfig.defaultConfig))
    }
    
    public class func showHUD(withDelay timeInterval: TimeInterval, withSize size: CGSize, animated: HUDDisplayAnimation, type: HUDDisplayType) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            showHUD(withSize: size, animated: animated, type: type)
        }
        
    }
    
    public class func dismissHUD(animated: HUDDisplayAnimation) {
        
        let keyWindow = UIApplication.shared.keyWindow
        
        guard keyWindow != nil else {
            return
        }
        
        switch animated {
            
        case .none:
            keyWindow!.viewWithTag(Int.max)?.removeFromSuperview()
            keyWindow!.viewWithTag(Int.max - 1)?.removeFromSuperview()
            
        case .animated(let interval):
            
            UIView.animate(withDuration: interval, animations: {
                keyWindow!.viewWithTag(Int.max)?.alpha = 0.0
                keyWindow!.viewWithTag(Int.max - 1)?.alpha = 0.0
            }) { (completed) in
                
                if completed {
                    
                    keyWindow!.viewWithTag(Int.max)?.removeFromSuperview()
                    keyWindow!.viewWithTag(Int.max - 1)?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(HUDNotifications.hudDidHide.rawValue), object: self)
                }
                
            }
            
        }
        
    }
    
}

