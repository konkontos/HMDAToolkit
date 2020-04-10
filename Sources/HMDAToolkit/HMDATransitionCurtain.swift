//
//  HMDATransitionCurtain.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 27/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let HMDATransitionCurtainAnimationEnded = NSNotification.Name("HMDATransitionCurtainAnimationEnded")
}


public class HMDATransitionCurtain: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            
            let midpoint = outgoingView.frame.size.width / 2.0
            
            let (leftSideRect, rightSideRect) = outgoingView.frame.divided(atDistance: midpoint, from: CGRectEdge.minXEdge)
            
            let leftSideImage = outgoingView.screenshot(forRect: leftSideRect)
            let rightSideImage =  outgoingView.screenshot(forRect: rightSideRect)
            
            let leftSideImageView = UIImageView(frame: leftSideRect)
            leftSideImageView.contentMode = .center
            leftSideImageView.image = leftSideImage
            
            let rightSideImageView = UIImageView(frame: rightSideRect)
            rightSideImageView.contentMode = .center
            rightSideImageView.image = rightSideImage
            
            transitionContext.containerView.addSubview(leftSideImageView)
            transitionContext.containerView.addSubview(rightSideImageView)
            
            transitionContext.containerView.insertSubview(incomingView, belowSubview: leftSideImageView)
            incomingView.frame = outgoingView.frame
            
            switch animationType {
                
            case .normal :
                
                UIView.animate(withDuration: duration,
                               animations: {
                                
                                leftSideImageView.center = leftSideImageView.center.applying(CGAffineTransform(translationX: -midpoint, y: 0))
                                rightSideImageView.center = rightSideImageView.center.applying(CGAffineTransform(translationX: midpoint, y: 0))
                                
                }) { (completed) in
                    leftSideImageView.removeFromSuperview()
                    rightSideImageView.removeFromSuperview()
                    transitionContext.completeTransition(completed)
                    
                }
                
            case .spring:
                
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: 0.3,
                               initialSpringVelocity: 7,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: {
                                
                                leftSideImageView.center = leftSideImageView.center.applying(CGAffineTransform(translationX: -midpoint, y: 0))
                                rightSideImageView.center = rightSideImageView.center.applying(CGAffineTransform(translationX: midpoint, y: 0))
                                
                }) { (completed) in
                    leftSideImageView.removeFromSuperview()
                    rightSideImageView.removeFromSuperview()
                    transitionContext.completeTransition(completed)
                }
                
            }
            
        } else {
            
            let outgoingView = transitionContext.view(forKey: .from)!
            let incomingView = transitionContext.view(forKey: .to)!
            
            let midpoint = outgoingView.frame.size.width / 2.0
            
            let (leftSideRect, rightSideRect) = outgoingView.frame.divided(atDistance: midpoint, from: CGRectEdge.minXEdge)
            
            let leftSideImage = incomingView.screenshot(forRect: leftSideRect)
            let rightSideImage = incomingView.screenshot(forRect: rightSideRect)
            
            let leftSideImageView = UIImageView(frame: leftSideRect.applying(CGAffineTransform(translationX: -midpoint, y: 0)))
            leftSideImageView.contentMode = .center
            leftSideImageView.image = leftSideImage
            
            let rightSideImageView = UIImageView(frame: rightSideRect.applying(CGAffineTransform(translationX: midpoint, y: 0)))
            rightSideImageView.contentMode = .center
            rightSideImageView.image = rightSideImage
            
            transitionContext.containerView.addSubview(leftSideImageView)
            transitionContext.containerView.addSubview(rightSideImageView)
            
            switch animationType {
                
            case .normal:
                
                
                UIView.animate(withDuration: duration,
                               animations: {
                                
                                leftSideImageView.center = leftSideImageView.center.applying(CGAffineTransform(translationX: midpoint, y: 0))
                                rightSideImageView.center = rightSideImageView.center.applying(CGAffineTransform(translationX: -midpoint, y: 0))
                                
                }) { (completed) in
                    transitionContext.containerView.insertSubview(incomingView, belowSubview: leftSideImageView)
                    incomingView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
                    transitionContext.completeTransition(completed)
                    leftSideImageView.removeFromSuperview()
                    rightSideImageView.removeFromSuperview()
                }
                
            case .spring:
                
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: 0.3,
                               initialSpringVelocity: 7,
                               options: UIView.AnimationOptions.curveEaseOut,
                               animations: {
                                
                                leftSideImageView.center = leftSideImageView.center.applying(CGAffineTransform(translationX: midpoint, y: 0))
                                rightSideImageView.center = rightSideImageView.center.applying(CGAffineTransform(translationX: -midpoint, y: 0))
                                
                }) { (completed) in
                    
                    transitionContext.containerView.insertSubview(incomingView, belowSubview: leftSideImageView)
                    incomingView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
                    transitionContext.completeTransition(completed)
                    leftSideImageView.removeFromSuperview()
                    rightSideImageView.removeFromSuperview()
                    
                }
                
            }
            
            
            
            
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        if notifyAtAnimationEnd == true {
            
            NotificationCenter.default.post(name: NSNotification.Name.HMDATransitionCurtainAnimationEnded,
                                            object: nil,
                                            userInfo: [
                                                "completed":NSNumber(booleanLiteral: transitionCompleted),
                                                "operation":operation
                ])
            
        }
        
    }
    
}
