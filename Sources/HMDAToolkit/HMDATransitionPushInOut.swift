//
//  HMDATransitionPushInOut.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 15/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionPushInOutAnimationEnded = NSNotification.Name("HMDATransitionPushInOutAnimationEnded")
}

public class HMDATransitionPushInOut: NSObject, UIViewControllerAnimatedTransitioning {

    public enum AnimationType {
        case normal
        case spring
    }
    
    public enum Presentation {
        case incoming
        case outgoing
    }
    
    public var notifyAtAnimationEnd = false
    
    public var duration = 0.3
    public var springDamping: CGFloat = 0.7
    
    public var animationType: AnimationType = .normal {
        
        didSet {
            
            if animationType == .spring {
                duration = 1.0
            } else {
                duration = 0.3
            }
            
        }
        
    }
    
    public var operation = Presentation.incoming
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if operation == .incoming {
            
            let outgoingView = transitionContext.view(forKey: .from)!
            let incomingView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(incomingView)
            incomingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: outgoingView.bounds.width, y: 0))
            
            switch animationType {
                
            case .normal :
                
                UIView.animate(withDuration: duration,
                               animations: {
                              
                                outgoingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: -outgoingView.bounds.width, y: 0))
                                incomingView.frame = incomingView.frame.applying(CGAffineTransform(translationX: -outgoingView.bounds.width, y: 0))
                                
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
                
            case .spring:
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: springDamping,
                               initialSpringVelocity: 0,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: {
                                
                                outgoingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: -outgoingView.bounds.width, y: 0))
                                incomingView.frame = incomingView.frame.applying(CGAffineTransform(translationX: -outgoingView.bounds.width, y: 0))
                                
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
                
            }
            
        } else { // outgoing
            
            let outgoingView = transitionContext.view(forKey: .from)!
            let incomingView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(incomingView)
            incomingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: -outgoingView.bounds.width, y: 0))
            
            switch animationType {
                
            case .normal :
                
                UIView.animate(withDuration: duration,
                               animations: {
                                
                                outgoingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: outgoingView.bounds.width, y: 0))
                                incomingView.frame = incomingView.frame.applying(CGAffineTransform(translationX: outgoingView.bounds.width, y: 0))
                                
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
                
            case .spring:
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: springDamping,
                               initialSpringVelocity: 0,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: {
                                
                                outgoingView.frame = outgoingView.frame.applying(CGAffineTransform(translationX: outgoingView.bounds.width, y: 0))
                                incomingView.frame = incomingView.frame.applying(CGAffineTransform(translationX: outgoingView.bounds.width, y: 0))
                                
                }) { (completed) in
                    transitionContext.completeTransition(completed)
                }
                
            }
            
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        if notifyAtAnimationEnd == true {
            
            NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionPushInOutAnimationEnded,
                                            object: nil,
                                            userInfo: [
                                                "completed":NSNumber(booleanLiteral: transitionCompleted),
                                                "operation":operation
                ])
            
        }
        
    }
    
}
