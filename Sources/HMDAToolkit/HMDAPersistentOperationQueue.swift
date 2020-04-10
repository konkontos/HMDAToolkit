//
//  HMDAPersistentOperationQueue.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 02/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation

@available (iOS 11.0, *)
public class HMDAPersistentOperationQueue: OperationQueue, HMDAPersistentOperationObserver {

    private typealias OperationDict = [String: Any]
    
    override public init() {
        super.init()
        
        registerForHMDAPersistentOperationNotifications()
        
        maxConcurrentOperationCount = 1
        
        unfreezeFromStorage()
    }
    
    deinit {
        unregisterForHMDAPersistentOperationNotifications()
        
        freezeToStorage()
    }
    
    override public var maxConcurrentOperationCount: Int {
        
        didSet {
            
            if maxConcurrentOperationCount > 1 {
                self.maxConcurrentOperationCount = 1
            }
            
        }
        
    }
    
    var persistenceURL: URL {
        return FileManager.applicationCachesDocumentsFolder().appendingPathComponent("____HMDAPersistentOperationQueue__.plist", isDirectory: false)
    }
    
    // MARK: - Notifications Observer
    
    func registerForHMDAPersistentOperationNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hmdaPersistentOperationDidFinish(_:)),
                                               name: NSNotification.Name.kHMDAPersistentOperationDidFinish,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hmdaPersistentOperationDidFail(_:)),
                                               name: NSNotification.Name.kHMDAPersistentOperationDidFail,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hmdaPersistentOperationDidStart(_:)),
                                               name: NSNotification.Name.kHMDAPersistentOperationDidStart,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hmdaPersistentOperationDidReceiveInvalidStatusCode(_:)),
                                               name: NSNotification.Name.kHMDAPersistentOperationDidReceiveInvalidStatusCode,
                                               object: nil)
    }
    
    func unregisterForHMDAPersistentOperationNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.kHMDAPersistentOperationDidFinish,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.kHMDAPersistentOperationDidFail,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.kHMDAPersistentOperationDidStart,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.kHMDAPersistentOperationDidReceiveInvalidStatusCode,
                                                  object: nil)
    }
    
    public func hmdaPersistentOperationDidReceiveInvalidStatusCode(_ notification: NSNotification) {
        OSLogDebug("HMDA POPQUEUE: OP INVALID HTTP CODE (\(notification.userInfo!["statusCode"] as! Int))")
    }
    
    public func hmdaPersistentOperationDidFail(_ notification: NSNotification) {
        OSLogDebug("HMDA POPQUEUE: OP DID FAIL: HTTP CODE (\(notification.userInfo!["statusCode"] as! Int))")
        OSLogDebug("HMDA POPQUEUE: Queued operations: \(operations.count)")
        
        freezeToStorage()
    }
    
    public func hmdaPersistentOperationDidFinish(_ notification: NSNotification) {
        OSLogDebug("HMDA POPQUEUE: OP DID FINISH: HTTP CODE (\(notification.userInfo!["statusCode"] as! Int))")
        OSLogDebug("HMDA POPQUEUE: Queued operations: \(operations.count)")
        
        freezeToStorage()
    }
    
    public func hmdaPersistentOperationDidStart(_ notification: NSNotification) {

    }
    
    // MARK: - Freeze / Unfreeze from persistent storage
    
    public func unfreezeFromStorage() {
        
        if let operationsArchive = NSDictionary(contentsOf: persistenceURL) as? OperationDict {
            
            let operationsArray = (operationsArchive["operations"] as! [OperationDict]).sorted { (op1, op2) -> Bool in
                
                let stamp1 = op1["creationStamp"] as! Date
                let stamp2 = op2["creationStamp"] as! Date
                
                return stamp1 > stamp2
            }
            
            if operationsArray.count > 0 {
                OSLogDebug("HMDA POPQUEUE: \(operationsArray.count) operation(s) retrieved from storage.")
            }
            
            for operationDict in operationsArray {
                let operation = NSKeyedUnarchiver.unarchiveObject(with: operationDict["archiveData"] as! Data) as! HMDAPersistentOperation
                
                addOperation(operation)
            }
            
        }
        
    }
    
    public func freezeToStorage() {
        var operationsArchive = OperationDict()
        
        operationsArchive["operations"] = [OperationDict]()
        
        var operationsArray = operationsArchive["operations"] as! [OperationDict]
        
        if operations.count > 0 {
            OSLogDebug("HMDA POPQUEUE: Freezing \(operations.count) operation(s) to storage.")
        }
        
        for operation in operations as! [HMDAPersistentOperation] {
            
            let operationArchive = NSKeyedArchiver.archivedData(withRootObject: operation)
            
            var opDict = OperationDict()
            
            opDict["creationStamp"] = operation.creationStamp!
            opDict["archiveData"] = operationArchive
            
            operationsArray.append(opDict)
        }
        
        operationsArchive["operations"] = operationsArray
        
        _ = try? (operationsArchive as NSDictionary).write(to: persistenceURL)
        
    }
    
}

