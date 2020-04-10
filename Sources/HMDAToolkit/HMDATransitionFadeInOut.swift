//
//  HMDATransitionFadeInOut.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 29/05/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionFadeInOutAnimationEnded = NSNotification.Name("HMDATransitionFadeInOutAnimationEnded")
}

public class HMDATransitionFadeInOut: NSObject, UIViewControllerAnimatedTransitioning {

    public enum Presentation {
        case incoming
        case outgoing
    }
    
    public var notifyAtAnimationEnd = false
    
    public var duration = 0.3
    
    public var operation = Presentation.incoming
    
    weak var currentTransitionContext: UIViewControllerContextTransitioning?
    
    // UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        currentTransitionContext = transitionContext
        
        if operation == .incoming {
            
            let incomingView = transitionContext.view(forKey: .to)!
            incomingView.alpha = 0.0
            
            transitionContext.containerView.addSubview(incomingView)
            
            if let outgoingView = transitionContext.view(forKey: .from) {
                incomingView.frame = outgoingView.frame
            }
            
            UIView.animate(withDuration: duration,
                           animations: {
                            incomingView.alpha = 1.0
            }) { (completed) in
                
                self.currentTransitionContext?.completeTransition(completed)
                
                if self.notifyAtAnimationEnd {
                    NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionFadeInOutAnimationEnded,
                                                    object: nil,
                                                    userInfo: [
                                                        "completed":NSNumber(booleanLiteral: completed),
                                                        "operation":self.operation
                        ])
                }
                
            }
            
        } else { // outgoing
            
            let outgoingView = transitionContext.view(forKey: .from)!
            let incomingView = transitionContext.view(forKey: .to)!
            
            incomingView.frame = outgoingView.frame
            
            UIView.animate(withDuration: duration,
                           animations: {
                            outgoingView.alpha = 0.0
            }) { (completed) in
                
                self.currentTransitionContext?.completeTransition(completed)
                
                if self.notifyAtAnimationEnd {
                    NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionFadeInOutAnimationEnded,
                                                    object: nil,
                                                    userInfo: [
                                                        "completed":NSNumber(booleanLiteral: completed),
                                                        "operation":self.operation
                        ])
                }
                
            }
            
        }
        
    }
    
}
