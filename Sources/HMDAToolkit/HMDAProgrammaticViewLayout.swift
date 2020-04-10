//
//  HMDAProgrammaticViewLayout.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 30/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public protocol HMDAProgrammaticViewSetup {
    
    /**
    Called when View is loaded
     */
    func constructView()
    
    /**
    Called when View is loaded and Trait Collection Changes
     */
    func constructLayout()
    
    func destructView()
}

public extension HMDAProgrammaticViewSetup {
    
    func destructView() {
        
        if self is UIViewController {
            for subview in (self as! UIViewController).view.subviews {
                subview.removeFromSuperview()
            }
            
            (self as! UIViewController).view.layoutIfNeeded()
        }
        
    }
    
}

public class HMDAProgrammaticViewController: UIViewController {
    
    static var layoutAnimationDuration: TimeInterval = 1.0
    
    override public func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        if self is HMDAProgrammaticViewSetup {
            (self as! HMDAProgrammaticViewSetup).constructView()
            (self as! HMDAProgrammaticViewSetup).constructLayout()
        }
        
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if self is HMDAProgrammaticViewSetup {
            (self as! HMDAProgrammaticViewSetup).constructLayout()
        }
        
    }
    
}


public extension UIView {
    
    class func new<T: UIView>(addedTo parentView: UIView? = nil, tagged tag: Int? = nil, usesAutoLayout autoLayout: Bool) -> T {
        let newView = T()
        
        if autoLayout {
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if tag != nil {
            newView.tag = tag!
        }
        
        if parentView != nil {
            parentView!.addSubview(newView)
        }
        
        return newView
    }
    
    class func manufacture<T: UIView>(putIn view: UIView, tagged tag: Int, usesAutoLayout: Bool, blueprint: (T) -> Void) -> T {
        let new: T = T.new(addedTo: view, tagged: tag, usesAutoLayout: usesAutoLayout)
        
        blueprint(new)
        
        return new
    }
    
    func remakeConstraints(parentView view: UIView, constraints: [NSLayoutConstraint]) {
        removeAffectingConstraints(parentView: view)
        NSLayoutConstraint.activate(constraints)
    }
    
    func removeOwnedConstraints() {
        
        for constraint in constraints {
            
            if String(describing: constraint.classForCoder).starts(with: String(describing: NSLayoutConstraint.self)) {
                removeConstraint(constraint)
            }
            
        }
        
    }
    
    func removeConstraints(inSuperView parentView: UIView) {
        
        for constraint in parentView.constraints {
            
            if constraint.firstItem is UIView {
                
                if (constraint.firstItem as? UIView) == self {
                    parentView.removeConstraint(constraint)
                    continue
                }
                
            }
            
            if constraint.secondItem is UIView {
                
                if (constraint.secondItem as? UIView) == self {
                    parentView.removeConstraint(constraint)
                }
                
            }
            
        }
        
    }
    
    func removeAffectingConstraints(parentView: UIView? = nil) {
        removeOwnedConstraints()
        
        if parentView != nil {
            removeConstraints(inSuperView: parentView!)
        }
        
    }
    
}
