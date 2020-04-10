//
//  HMDATransitionDropFromAbove.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 22/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionDropFromAboveAnimationEnded = NSNotification.Name("HMDATransitionDropFromAboveAnimationEnded")
}

public class HMDATransitionDropFromAbove: NSObject, UIViewControllerAnimatedTransitioning {

    public enum Presentation {
        case incoming
        case outgoing
    }
    
    public var notifyAtAnimationEnd = false
    
    public var duration = 0.5
    
    public var operation = Presentation.incoming
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if operation == .incoming {

            let incomingView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(incomingView)
            
            incomingView.frame = transitionContext.containerView.frame.applying(CGAffineTransform(translationX: 0, y: -transitionContext.containerView.bounds.height))
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {
                            
                            incomingView.frame = incomingView.frame.applying(CGAffineTransform(translationX: 0, y: transitionContext.containerView.bounds.height))
                            
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
            
        } else { // outgoing
            
            let outgoingView = transitionContext.view(forKey: .from)!
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            
                            outgoingView.frame = transitionContext.containerView.frame.applying(CGAffineTransform(translationX: 0, y: -transitionContext.containerView.bounds.height))
                            
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
            
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        if notifyAtAnimationEnd == true {
            
            NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionDropFromAboveAnimationEnded,
                                            object: nil,
                                            userInfo: [
                                                "completed":NSNumber(booleanLiteral: transitionCompleted),
                                                "operation":operation
                ])
            
        }
        
    }
    
}
