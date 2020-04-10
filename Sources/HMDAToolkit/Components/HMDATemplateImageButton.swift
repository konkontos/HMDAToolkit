//
//  HMDAButton.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 06/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class HMDATemplateImageButton: HMDAButton {
    
    override internal func setScaledImage() {
        
        if originalImage == nil {
            originalImage = image(for: .normal)
        }
        
        if let scaledimage = originalImage!.scaledImageWithSize(CGSize(width: imageSizeX, height: imageSizeY)) {
            setImageAsTemplateImageForAllStates(scaledimage)
        }
        
    }
    
}
