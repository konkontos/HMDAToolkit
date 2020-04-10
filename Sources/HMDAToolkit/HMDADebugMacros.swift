//
//  HMDADebugNewMacros.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 28/06/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation
import os


public enum OSLogPromptCharacter: String {
    case debug = "📢"
    case error = "❗️"
    case info = "🔵"
}

#if DEBUG

public func OSLogDebug(_ argStr: String) {
    os_log("📢 DEBUG: %@", log: OSLog.default, type: .debug, argStr)
}

public func OSLogError(_ argStr: String) {
    os_log("❗️ ERROR: %@", log: OSLog.default, type: .default, argStr)
}

public func OSLogInfo(_ argStr: String) {
    os_log("🔵 INFO: %@", log: OSLog.default, type: .info, argStr)
}

public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "📢 DEBUG: %@", log: OSLog.default, type: .debug, args)
    } else {
        os_log(format ?? "📢 DEBUG: %@", log: logger!, type: .debug, args)
    }
    
}

public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "❗️ ERROR: %@", log: OSLog.default, type: .default, args)
    } else {
        os_log(format ?? "❗️ ERROR: %@", log: logger!, type: .default, args)
    }
    
}

public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "🔵 INFO: %@", log: OSLog.default, type: .info, args)
    } else {
        os_log(format ?? "🔵 INFO: %@", log: logger!, type: .info, args)
    }
    
}

#elseif DEBUG_ERROR

public func OSLogError(_ argStr: String) {
    os_log("❗️ ERROR: %@", log: OSLog.default, type: .default, argStr)
}

public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "❗️ ERROR: %@", log: OSLog.default, type: .default, args)
    } else {
        os_log(format ?? "❗️ ERROR: %@", log: logger!, type: .default, args)
    }
    
}

public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

#elseif DEBUG_INFO

public func OSLogInfo(_ argStr: String) {
    os_log("🔵 INFO: %@", log: OSLog.default, type: .info, argStr)
}

public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "🔵 INFO: %@", log: OSLog.default, type: .info, args)
    } else {
        os_log(format ?? "🔵 INFO: %@", log: logger!, type: .info, args)
    }
    
}

#else

public func OSLogDebug(_ argStr: String) {
    
}

public func OSLogError(_ argStr: String) {
    
}

public func OSLogInfo(_ argStr: String) {
    
}

public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

#endif
