//
//  HMDATextUtils.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 13/4/20.
//

import UIKit
import CoreText

public extension Data {

    func font() -> UIFont? {
        UIFont.font(from: self)
    }
    
}

public extension UIFont {
    
    func addingToPointSize(constant: CGFloat) -> UIFont? {
        self.withSize(self.pointSize + constant)
    }
    
    class func font(from fontData: Data) -> UIFont? {
        
        guard let fontCFData = fontData as CFData? else {
            return nil
        }
        
        guard let dataProvider = CGDataProvider(data: fontCFData) else {
            return nil
        }
        
        guard let cgFont = CGFont(dataProvider) else {
            return nil
        }
        
        var error: Unmanaged<CFError>?
        
        let success = CTFontManagerRegisterGraphicsFont(cgFont, &error)
        
        guard success == true else {
            return nil
        }
        
        guard let fontName = cgFont.postScriptName as String? else {
            return nil
        }
                
        let customFont = UIFont(name: fontName, size: UIFont.systemFontSize)
        
        return customFont
    }
    
    func resized(to size: CGFloat) -> UIFont? {
        UIFont(name: self.fontName, size: size)
    }
    
    class func font(fromAssetNamed assetName: String, textStyle: UIFont.TextStyle) -> UIFont {
        
        let requiredPointSized = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        
        let defaultFont = UIFont.systemFont(ofSize: requiredPointSized)
        
        guard let fontData = NSDataAsset(name: NSDataAssetName(assetName))?.data else {
            return defaultFont
        }
        
        guard let customFont = UIFont.font(from: fontData) else {
            return defaultFont
        }
        
        return customFont.resized(to: requiredPointSized) ?? defaultFont
    }
    
}

public extension UIFont.TextStyle {
    
    func font(fromAssetNamed assetName: String) -> UIFont {
        UIFont.font(fromAssetNamed: assetName, textStyle: self)
    }
    
}
