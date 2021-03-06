//
//  HMDAToggleButton.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 04/01/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public class HMDAToggleButton: UIButton {

    let toggleNotificationName = NSNotification.Name("kHMDARadioButtonToggled")
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    var normalImage: UIImage?
    var highlightImage: UIImage?
    var backgroundImage: UIImage?
    var highlightBackgroundImage: UIImage?
    
    var isRadioButton = false
    public var isActive = false

    var radioGroupIdentifier: String?
    var buttonID: String?
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: toggleNotificationName,
                                                  object: nil)
    }
    
    func setup() {
        
        normalImage = image(for: .normal)
        highlightImage = image(for: .highlighted)
        backgroundImage = backgroundImage(for: .normal)
        highlightBackgroundImage = backgroundImage(for: .highlighted)
        
        highlightColor = titleColor(for: .highlighted)
        normalColor = titleColor(for: .normal)
        
        setImage(normalImage, for: .highlighted)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deactivate(notification:)),
                                               name: toggleNotificationName,
                                               object: nil)
    }
    
    @objc func deactivate(notification: Notification) {
        
        let infoDict = notification.userInfo!
        
        let identifier = infoDict["radioGroup"] as! String
        let excludeID = infoDict["excludeID"] as! String
        
        if self.isRadioButton {
            
            if identifier == radioGroupIdentifier {
                
                if excludeID == buttonID {
                    
                    isActive = false
                    
                    setImage(normalImage, for: .normal)
                    setImage(normalImage, for: .highlighted)
                    setBackgroundImage(backgroundImage, for: .normal)
                    setBackgroundImage(backgroundImage, for: .highlighted)
                    
                }
                
            }
            
        }
        
    }
    
    public func setActive() {
        isActive = true
        
        if highlightImage != nil {
            setImage(highlightImage!, for: .normal)
            setImage(highlightImage!, for: .highlighted)
        } else {
            setBackgroundImage(highlightBackgroundImage, for: .normal)
            setBackgroundImage(highlightBackgroundImage, for: .highlighted)
        }
        
        setTitleColor(highlightColor, for: .normal)
        setTitleColor(highlightColor, for: .highlighted)
        
        if isRadioButton {
            
            var infoDict = [String: String]()
            
            infoDict["radioGroup"] = radioGroupIdentifier!
            infoDict["excludeID"] = buttonID!
            
            NotificationCenter.default.post(name: toggleNotificationName,
                                            object: nil,
                                            userInfo: infoDict)
        }
        
    }
    
    public func setInactive() {
        isActive = false
        
        if highlightImage != nil {
            setImage(normalImage!, for: .normal)
            setImage(normalImage!, for: .highlighted)
        } else {
            setBackgroundImage(backgroundImage, for: .normal)
            setBackgroundImage(backgroundImage, for: .highlighted)
        }
        
        setTitleColor(normalColor, for: .normal)
        setTitleColor(normalColor, for: .highlighted)
        
    }
    
    public func toggleState() {
        
        switch isActive {
            
        case false:
            setActive()
            
        case true:
            setInactive()
            
        }
        
    }
    
}
