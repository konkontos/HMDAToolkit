//
//  HMDATransitionZAxis.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 15/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

// TODO: !!! INCOMPLETE | WORK-IN-PROGRESS !!!

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionZAxisAnimationEnded = NSNotification.Name("HMDATransitionZAxisAnimationEnded")
}

public class HMDATransitionZAxis: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

    public enum Presentation {
        case incoming
        case outgoing
    }
    
    public var notifyAtAnimationEnd = false
    
    var duration = 0.3
    
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
            
            let outgoingView = transitionContext.view(forKey: .from)!
            let incomingView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(incomingView)
            
//            incomingView.layer.anchorPoint = CGPoint.zero
            incomingView.frame = outgoingView.frame
//            incomingView.alpha = 0.0
            
            incomingView.layer.transform = CATransform3DMakeTranslation(0, 0, 184)
            
//            incomingView.alpha = 1.0
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))
            animation.duration = duration
            animation.fillMode = .forwards
            animation.delegate = self
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.isRemovedOnCompletion = false
            
            incomingView.layer.add(animation, forKey: nil)
            
        } else { // outgoing
            
            
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        if notifyAtAnimationEnd == true {
            NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionZAxisAnimationEnded,
                                            object: nil,
                                            userInfo: [
                                                "completed":NSNumber(booleanLiteral: transitionCompleted),
                                                "operation":operation
                ])
        }
        
    }
    
}
