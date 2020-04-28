//
//  HMDAKeychain.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation
import Security

#if os(iOS) || os(OSX)
import LocalAuthentication
#endif

public class HMDAKeychain {
    
    enum accessibility {
        case accessibleAlways
        case whenUnlocked
        case afterFirstUnlock
        case thisDeviceOnly
        case unlockedThisDeviceOnly
        case passcodeSetThisDeviceOnly
        case afterFirstUnlockThisDeviceOnly
        
        /*
        func coreValue() -> Any {
            
            switch self {
                
            case .accessibleAlways:
                <#code#>
                
            case .whenUnlocked:
                
                
            default:
                <#code#>
            }
            
        }
        */
        
    }
    
    var service = Bundle.main.bundleIdentifier
    
//    var accessibility
    
    public class func test() {
//        kSecAttrAccessible
//        String(kSecAttrAccessibleAlways)
    }
    
}
