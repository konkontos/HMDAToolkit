//
//  HMDACoreDataUtils.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol HMDAAppDelegateMocEnabled {
    var moc: NSManagedObjectContext? {get}
}


public extension NSManagedObject {
    
    class var viewContext: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? HMDAAppDelegateMocEnabled)?.moc
    }
    
    func delete() {
        NSManagedObject.viewContext?.delete(self)
        _ = try? NSManagedObject.viewContext?.save()
    }
    
    func save() {
        _ = try? NSManagedObject.viewContext?.save()
    }
    
    class func newObject() -> Self? {
        
        guard NSManagedObject.viewContext != nil else {
            return nil
        }
        
        
        let newObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: self),
                                                            into: NSManagedObject.viewContext!)
        
        return unsafeDowncast(newObject, to: self)
    }
    
    
    class func allObjects<T:NSFetchRequestResult>() -> [T]? {
        
        guard NSManagedObject.viewContext != nil else {
            return nil
        }
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        do {
            let requestResults = try NSManagedObject.viewContext!.fetch(request)
            
            guard requestResults.count > 0 else {
                return nil
            }
            
            return requestResults
        }
        catch {
            return nil
        }
        
    }
    
}
