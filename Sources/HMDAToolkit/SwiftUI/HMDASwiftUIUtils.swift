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

@available(iOS 13, *)
public struct TextFieldWithEraseButton: ViewModifier {
    
    var color: Color
    
    var closure: (() -> Void)?
    
    @Binding var text: String
    
    public init(withBoundText text: Binding<String>, andColor color: Color, closure: (() -> Void)? = nil) {
        self.color = color
        self.closure = closure
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(Button(action: {
            self.text = ""
            self.closure?()
        }) {
            Image(systemName: "xmark.circle.fill").padding([.trailing], 8.0)
            },
            alignment: .trailing)
            .foregroundColor(color)
    }
    
}
