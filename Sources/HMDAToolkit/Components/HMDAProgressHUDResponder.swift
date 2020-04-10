//
//  HMDAProgressHUDResponder.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 08/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@objc public enum HUDTouchType: Int {
    case screen = 0
    case button = 1
}

@objc public protocol HUDResponder {
    func hudTouchOnButton(_ event: UIEvent)
    func hudTouchOnScreen(_ event: UIEvent)
}

public extension UIViewController {

    func addHUDResponse(forTouchType touchType: HUDTouchType) {
     
        guard conforms(to: HUDResponder.self) else {
            return
        }
     
        switch touchType {
     
        case .screen:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(HUDResponder.hudTouchOnScreen(_:)),
                                                   name: Notification.Name(rawValue: HMDAProgressHUD.HUDNotifications.touchOnScreen.rawValue),
                                                   object: nil)
     
        case .button:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(HUDResponder.hudTouchOnButton(_:)),
                                                   name: Notification.Name(rawValue: HMDAProgressHUD.HUDNotifications.touchOnButton.rawValue),
                                                   object: nil)
     
        }
     
    }
    
}
