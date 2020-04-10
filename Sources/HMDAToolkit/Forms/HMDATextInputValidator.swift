//
//  HMDATextInputValidator.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 21/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation

public class HMDATextInputValidator {
    
    public enum type {
        case none
        case phone(String?)
        case email(String?)
        case number(String?)
        
        public func validate() -> Bool {
            
            switch self {
                
            case .number(let textValue):
                return HMDATextInputValidator.validateNumber(text: textValue)
                
            case .phone(let textValue):
                return HMDATextInputValidator.validatePhone(text: textValue)
                
            case .email(let textValue):
                return HMDATextInputValidator.validateEmail(text: textValue)
                
            default:
                return true
            }
            
        }
        
    }
    
    fileprivate class func validatePhone(text: String?) -> Bool {
        
        guard text != nil else {
            return true
        }
        
        let trimmedStr = text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue) else {
            return false
        }
        
        let matches = detector.matches(in: trimmedStr,
                                       options: NSRegularExpression.MatchingOptions.reportCompletion,
                                       range: NSMakeRange(0, trimmedStr.count))
        
        guard matches.count > 0 else {
            return false
        }
        
        return true
    }
    
    fileprivate class func validateEmail(text: String?) -> Bool {
        
        guard text != nil else {
            return true
        }
        
        let trimmedStr = text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let matches = detector.matches(in: trimmedStr,
                                       options: NSRegularExpression.MatchingOptions.reportCompletion,
                                       range: NSMakeRange(0, trimmedStr.count))
        
        guard matches.count > 0 else {
            return false
        }
        
        if matches[0].url!.absoluteString.contains("mailto:") {
            return true
        } else {
            return false
        }
        
    }
    
    fileprivate class func validateNumber(text: String?) -> Bool {
        
        guard text != nil else {
            return true
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        
        if let _ = formatter.number(from: text!) {
            return true
        } else {
            return false
        }
        
    }
    
}
