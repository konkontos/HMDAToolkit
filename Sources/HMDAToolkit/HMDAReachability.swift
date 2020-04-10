//
//  HMDAReachability.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 02/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//
//  Thanks to: https://www.invasivecode.com/weblog/network-reachability-in-swift/

import Foundation
import SystemConfiguration

public extension NSNotification.Name {
    static let kReachabilityDidChangeNotification = NSNotification.Name(rawValue: "kReachabilityDidChangeNotification")
}

public class HMDAReachability: NSObject {
    
    public enum ReachabilityStatus {
        case notReachable
        case reachableViaWiFi
        case reachableViaWWAN
        case unknown
    }
    
    private var networkReachability: SCNetworkReachability?

    private var notifying = false
    
    // MARK: - Initialization
    
    init?(hostName: String) {
        super.init()
        
        guard let hostNameCString = (hostName as NSString).utf8String else {
            return nil
        }
        
        networkReachability = SCNetworkReachabilityCreateWithName(nil, hostNameCString)
        
        if networkReachability == nil {
            return nil
        }
        
    }
    
    init?(hostAddress: sockaddr_in) {
        super.init()
        
        withUnsafePointer(to: hostAddress) { (addressPointer) -> Void in
            
            addressPointer.withMemoryRebound(to: sockaddr.self, capacity: 1, { (sockAddrPointer) -> Void in
                networkReachability = SCNetworkReachabilityCreateWithAddress(nil, sockAddrPointer)
            })
            
        }
        
        if networkReachability == nil {
            return nil
        }
        
    }
    
    public class func networkReachabilityForInternetConnection() -> HMDAReachability? {
        var address = sockaddr_in()
        
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        
        return HMDAReachability(hostAddress: address)
    }
    
    public class func networkReachabilityForLocalWiFi() -> HMDAReachability? {
        var address = sockaddr_in()
        
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        address.sin_addr.s_addr = IN_LINKLOCALNETNUM
        
        return HMDAReachability(hostAddress: address)
    }
    
    deinit {
        stopNotifier()
        
        networkReachability = nil
    }
    
    // MARK: - Notifying
    
    public func startNotifier() -> Bool {
        
        guard notifying == false else {
            return false
        }
        
        let callbackWasSet = SCNetworkReachabilitySetCallback(networkReachability!,
                                         { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name.kReachabilityDidChangeNotification,
                                                                            object: target)
                                            
                                            },
                                         nil)
        
        if callbackWasSet {
            SCNetworkReachabilityScheduleWithRunLoop(networkReachability!,
                                                     CFRunLoopGetCurrent(),
                                                     CFRunLoopMode.defaultMode.rawValue)
        } else {
            return false
        }
        
        notifying = true
        
        return notifying
    }
    
    public func stopNotifier() {
        
        if networkReachability != nil, notifying == true {
            SCNetworkReachabilityUnscheduleFromRunLoop(networkReachability!,
                                                       CFRunLoopGetCurrent(),
                                                       CFRunLoopMode.defaultMode as! CFString)
            notifying = false
        }
        
    }
    
    // MARK: - Status Reporting
    
    private var reachabilityFlags: SCNetworkReachabilityFlags? {
        
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        
        guard networkReachability != nil else {
            return nil
        }
        
        var gotFlags = false
        
        withUnsafeMutablePointer(to: &flags) { (flagsPointer) -> Void in
            gotFlags = SCNetworkReachabilityGetFlags(networkReachability!, flagsPointer)
        }
        
        if gotFlags {
            return flags
        } else {
            return nil
        }
        
    }
    
    public var currentReachabilityStatus: ReachabilityStatus {
        
        guard reachabilityFlags != nil else {
            return .unknown
        }
        
        if reachabilityFlags!.contains(.reachable) == false {
            return .notReachable
        }
        
        if reachabilityFlags!.contains(.isWWAN) == true {
            return .reachableViaWWAN
        }
        
        if reachabilityFlags!.contains(.connectionRequired) == false {
            return .reachableViaWiFi
        }
        
        if (reachabilityFlags!.contains(.connectionOnDemand) == true || reachabilityFlags!.contains(.connectionOnTraffic) == true) && reachabilityFlags!.contains(.interventionRequired) == false {
            return .reachableViaWiFi
        }
        
        return .notReachable
    }
    
}
