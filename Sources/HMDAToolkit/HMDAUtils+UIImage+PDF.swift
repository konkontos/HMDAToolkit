//
//  HMDAUtils+UIImage+PDF.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 01/07/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public extension UIImage {
    
    enum PDFImageError: Error {
        case generalError(String)
    }
    
    class func draw(pdfPage: CGPDFPage, inRect destinationRect: CGRect) throws {
        
        let context = UIGraphicsGetCurrentContext()
        
        guard context != nil else {
            throw PDFImageError.generalError("Error drawing PDF")
        }
        
        context?.saveGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        guard image != nil else {
            throw PDFImageError.generalError("Error drawing PDF")
        }
        
        // Flip the context to Quartz space
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1.0, y: -1.0)
        transform = transform.translatedBy(x: 0, y: -image!.size.height)
        
        context?.concatenate(transform)
        
        // Flip the rect, which remains in UIKit space
        let d = destinationRect.applying(transform)
        
        // Calculate a rectangle to draw to
        let pageRect = pdfPage.getBoxRect(CGPDFBox.cropBox)
        let drawingAspect = UIImage.aspectScaleFit(sourceSize: pageRect.size, destRect: d)
        let drawingRect = UIImage.rectByFittingRect(sourceRect: pageRect, destinationRect: d)
        
        // Adjust the context
        context?.translateBy(x: drawingRect.origin.x, y: drawingRect.origin.y)
        context?.scaleBy(x: drawingAspect, y: drawingAspect)
        
        // Draw the page
        context?.drawPDFPage(pdfPage)
        context?.restoreGState()
    }
    
    class func getPDFFileAspect(pdfPath: String) throws -> CGFloat {
        
        let pdfURL = URL(fileURLWithPath: pdfPath)
        
        let pdf = CGPDFDocument.init(pdfURL as CFURL)
        
        guard pdf != nil else {
            throw PDFImageError.generalError("Error loading PDF")
        }
        
        if let pdfPage = pdf?.page(at: 1) {
            let pageRect = pdfPage.getBoxRect(CGPDFBox.cropBox)
            
            return pageRect.size.width / pageRect.size.height
        } else {
            throw PDFImageError.generalError("Error getting PDF aspect ratio")
        }
        
    }
    
    class func aspectScaleFit(sourceSize: CGSize, destRect: CGRect) -> CGFloat {
        
        let destSize = destRect.size
        
        let scaleW = destSize.width / sourceSize.width
        
        let scaleH = destSize.height / sourceSize.height
        
        return fmin(scaleW, scaleH)
    }
    
    class func rectAround(center: CGPoint, size: CGSize) -> CGRect {
        
        let halfWidth = size.width / 2.0
        let halfHeight = size.height / 2.0
        
        return CGRect(x: center.x - halfWidth, y: center.y - halfHeight,
                      width: size.width, height: size.height)
    }
    
    class func rectByFittingRect(sourceRect: CGRect, destinationRect:CGRect) -> CGRect {
        
        let aspect = UIImage.aspectScaleFit(sourceSize: sourceRect.size, destRect: destinationRect)
        
        let targetSize = CGSize(width: sourceRect.size.width * aspect,
                                height: sourceRect.size.height * aspect)
        
        let center = CGPoint(x: destinationRect.midX,
                             y: destinationRect.midY)
        
        return UIImage.rectAround(center: center, size: targetSize)
    }
    
    class func imageFromPDFFile(atPath pdfPath: String, targetSize: CGSize) -> UIImage? {
        
        let pdfPathURL = URL(fileURLWithPath: pdfPath)
        
        let pdf = CGPDFDocument(pdfPathURL as CFURL)
        
        guard pdf != nil else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        let page = pdf?.page(at: 1)
        
        guard page != nil else {
            return nil
        }
        
        _ = try? UIImage.draw(pdfPage: page!, inRect: CGRect(origin: CGPoint.zero, size: targetSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    class func imageFromPDFFile(withWidth targetWidth: CGFloat, pdfPath: String) -> UIImage? {
        var aspect: CGFloat?
        
        do {
            aspect = try UIImage.getPDFFileAspect(pdfPath: pdfPath)
        } catch {
            return nil
        }
        
        return UIImage.imageFromPDFFile(atPath: pdfPath,
                                        targetSize: CGSize(width: targetWidth, height: targetWidth / aspect!))
    }
    
    class func ImageFromPDFFile(withHeight targetHeight: CGFloat, pdfPath: String) -> UIImage?  {
        var aspect: CGFloat?
        
        do {
            aspect = try UIImage.getPDFFileAspect(pdfPath: pdfPath)
        } catch {
            return nil
        }
        
        return UIImage.imageFromPDFFile(atPath: pdfPath,
                                        targetSize: CGSize(width: targetHeight * aspect!, height: targetHeight))
    }
    
}
