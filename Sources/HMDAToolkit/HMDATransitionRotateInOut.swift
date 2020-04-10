//
//  HMDATransitionRotateInOut.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 14/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionRotateInOutAnimationEnded = NSNotification.Name("HMDATransitionRotateInOutAnimationEnded")
}

public class HMDATransitionRotateInOut: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

    public enum AnimationType {
        case normal
        case spring
    }
    
    public enum Presentation {
        case incoming
        case outgoing
    }
    
    public var notifyAtAnimationEnd = false
    
    var duration = 0.3
    
    public var animationType: AnimationType = .normal
    
    public var operation = Presentation.incoming
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    weak var currentTransitionContext: UIViewControllerContextTransitioning?
    
    // CAAnimationDelegate
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if currentTransitionContext != nil {
            let incomingView = currentTransitionContext!.view(forKey: .to)!
            let outgoingView = currentTransitionContext!.view(forKey: .from)!
            
            incomingView.layer.transform = outgoingView.layer.transform
            incomingView.frame = outgoingView.frame
            
            incomingView.layer.removeAllAnimations()
            
            currentTransitionContext!.completeTransition(flag)
        }
        
        currentTransitionContext = nil
    }
    
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        currentTransitionContext = transitionContext
        
        if operation == .incoming {
            
            switch animationType {
                
            case .normal:
                let outgoingView = transitionContext.view(forKey: .from)!
                let incomingView = transitionContext.view(forKey: .to)!
                
                transitionContext.containerView.addSubview(incomingView)
                
                incomingView.layer.anchorPoint = CGPoint.zero
                incomingView.frame = outgoingView.frame
                incomingView.alpha = 0.0
                
                incomingView.layer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2.0), 0, 0, 1)
                
                incomingView.alpha = 1.0
                
                let animation = CABasicAnimation(keyPath: "transform")
                animation.toValue = NSValue(caTransform3D: CATransform3DRotate(incomingView.layer.transform, CGFloat.pi / 2.0, 0, 0, 1))
                animation.duration = duration
                animation.fillMode = .forwards
                animation.delegate = self
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animation.isRemovedOnCompletion = false
                
                incomingView.layer.add(animation, forKey: nil)
                
            case .spring:
                let outgoingView = transitionContext.view(forKey: .from)!
                let incomingView = transitionContext.view(forKey: .to)!
                
                transitionContext.containerView.addSubview(incomingView)
                
                incomingView.layer.anchorPoint = CGPoint.zero
                incomingView.frame = outgoingView.frame
                incomingView.alpha = 0.0
                
                incomingView.layer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2.0), 0, 0, 1)
                
                incomingView.alpha = 1.0
                
                let animation = CASpringAnimation(keyPath: "transform")
                animation.toValue = NSValue(caTransform3D: CATransform3DRotate(incomingView.layer.transform, CGFloat.pi / 2.0, 0, 0, 1))
                animation.fillMode = .forwards
                animation.delegate = self
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animation.isRemovedOnCompletion = false
                
                animation.damping = 10.0
                animation.mass = 1.0
                animation.stiffness = 100.0
                animation.initialVelocity = 0
                
                animation.duration = animation.settlingDuration
                
                incomingView.layer.add(animation, forKey: nil)
                
            }
            
            
        } else { // outgoing
            
            switch animationType {
                
            case .normal:
                let outgoingView = transitionContext.view(forKey: .from)!
                let incomingView = transitionContext.view(forKey: .to)!
                
                transitionContext.containerView.insertSubview(incomingView, belowSubview: outgoingView)
                
                incomingView.layer.anchorPoint = CGPoint(x: 0, y: 0)
                incomingView.frame = outgoingView.frame
                
                outgoingView.layer.anchorPoint = CGPoint.zero
                
                let animation = CABasicAnimation(keyPath: "transform")
                animation.toValue = CATransform3DRotate(incomingView.layer.transform, -(CGFloat.pi / 2.0), 0, 0, 1)
                animation.duration = duration
                animation.fillMode = .forwards
                animation.delegate = self
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animation.isRemovedOnCompletion = false
                
                outgoingView.layer.add(animation, forKey: nil)
                
            case .spring:
                let outgoingView = transitionContext.view(forKey: .from)!
                let incomingView = transitionContext.view(forKey: .to)!
                
                transitionContext.containerView.insertSubview(incomingView, belowSubview: outgoingView)
                
                incomingView.layer.anchorPoint = CGPoint(x: 0, y: 0)
                incomingView.frame = outgoingView.frame
                
                outgoingView.layer.anchorPoint = CGPoint.zero
                
                let animation = CASpringAnimation(keyPath: "transform")
                animation.toValue = CATransform3DRotate(incomingView.layer.transform, -(CGFloat.pi / 2.0), 0, 0, 1)
                animation.fillMode = .forwards
                animation.delegate = self
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                animation.isRemovedOnCompletion = false
                
                animation.damping = 10.0
                animation.mass = 1.0
                animation.stiffness = 100.0
                animation.initialVelocity = 0
                
                animation.duration = animation.settlingDuration
                
                outgoingView.layer.add(animation, forKey: nil)
                
            }
            
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        if notifyAtAnimationEnd == true {
            NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionRotateInOutAnimationEnded,
                                            object: nil,
                                            userInfo: [
                                                "completed":NSNumber(booleanLiteral: transitionCompleted),
                                                "operation":operation
                ])
        }
        
    }
    
}
