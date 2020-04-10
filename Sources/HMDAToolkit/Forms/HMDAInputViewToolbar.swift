//
//  HMDADateInputTableViewCell.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 20/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@objc public protocol HMDAInputViewToolbarDelegate {
    func inputViewDismissButtonTapped(_ sender: AnyObject?)
}

open class HMDAInputViewToolbar: UIToolbar {
    
    var inputViewDelegate: HMDAInputViewToolbarDelegate?
    
    open class var defaultRect: CGRect {
        return CGRect(x: 0, y: 0, width: 320, height: 44)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUIElements(nil)
    }
    
    public init(frame: CGRect, withDelegate: HMDAInputViewToolbarDelegate) {
        super.init(frame: frame)
        
        inputViewDelegate = withDelegate
        
        setupUIElements(nil)
    }
    
    convenience public init(frame: CGRect, withDelegate: HMDAInputViewToolbarDelegate, andButtonText: String) {
        self.init(frame: frame, withDelegate: withDelegate)
        
        setupUIElements(andButtonText)
    }
    
    private func setupUIElements(_ withButtonText: String?) {
        var dismissButton: UIBarButtonItem?
        
        if withButtonText == nil {
            dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                            target: inputViewDelegate,
                                            action: #selector(inputViewDelegate?.inputViewDismissButtonTapped(_:)))
        } else {
            dismissButton = UIBarButtonItem(title: withButtonText,
                                            style: UIBarButtonItem.Style.done,
                                            target: inputViewDelegate,
                                            action: #selector(inputViewDelegate?.inputViewDismissButtonTapped(_:)))
        }
        
        
        items = [dismissButton!]
    }
    
}
