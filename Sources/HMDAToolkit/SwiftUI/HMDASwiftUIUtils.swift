//
//  HMDASwiftUIUtils.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 23/4/20.
//

import SwiftUI

@available(iOS 13, *)
public struct FontModifier: ViewModifier {
    
    var font: UIFont
    
    public func body(content: Content) -> some View {
        content.font(Font(font))
    }
    
}

@available(iOS 13, *)
public extension UIFont {
    
    var swiftUIModifier: FontModifier {
        return FontModifier(font: self)
    }
    
}
