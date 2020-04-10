//
//  HMDAImageFX.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 8/4/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import UIKit
import CoreImage

public extension UIImage {
    
    func grayscaleImage(brightness: Double = 0.0) -> UIImage? {
        let context = CIContext()
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(NSNumber(floatLiteral: 0.0), forKey: kCIInputSaturationKey)
        filter?.setValue(NSNumber(floatLiteral: brightness), forKey: kCIInputBrightnessKey)
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let sourceImage = CIImage(cgImage: cgImage)
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter?.outputImage else {
            return nil
        }
        
        guard let outputImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputImage)
    }
    
}
