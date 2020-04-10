//
//  HMDAResizingLayer.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 09/03/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import UIKit

public protocol HMDALayerResizing {
    var referencePosition: CGPoint? {get set}
    var referenceBounds: CGRect? {get set}
    func updateReferenceGeometry()
}


public class HMDAResizableLayer: CALayer, HMDALayerResizing {

    public var referencePosition: CGPoint?
    public var referenceBounds: CGRect?
    
    public override init() {
        super.init()
    }
    
    init(withReferencePosition pos: CGPoint, andReferenceBounds boundingRect: CGRect) {
        super.init()
        
        position = pos
        bounds = boundingRect
        
        referenceBounds = boundingRect
        referencePosition = normalizedPosition(fromPosition: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func updateReferenceGeometry() {
        referenceBounds = bounds
        referencePosition = normalizedPosition(fromPosition: position)
    }
    
    
    override public func layoutSublayers() {

        guard sublayers != nil else {
            return
        }
        
        for sublayer in sublayers! as [CALayer] {
            
            if sublayer is HMDAResizableLayer {
                if (sublayer as! HMDAResizableLayer).referenceBounds != nil, (sublayer as! HMDAResizableLayer).referencePosition != nil {
                    updateFrame(forLayer: (sublayer as! HMDAResizableLayer), inLayer: self)
                }
            }
            
            sublayer.layoutSublayers()
        }
        
    }
    
    private func updateFrame(forLayer sublayer: HMDAResizableLayer, inLayer superLayer: HMDAResizableLayer) {
        
        guard superLayer.referenceBounds != nil else {
            return
        }
        
        guard superLayer.referenceBounds!.width > 0, superLayer.referenceBounds!.height > 0 else {
            return
        }
        
        let xSizeFactor = sublayer.referenceBounds!.size.width / superLayer.referenceBounds!.width
        let ySizeFactor = sublayer.referenceBounds!.size.height / superLayer.referenceBounds!.height
        
        let newSublayerWidth = xSizeFactor * superLayer.bounds.width
        let newSublayerHeight = ySizeFactor * superLayer.bounds.height
        
        let xPosFactor = sublayer.referencePosition!.x / superLayer.referenceBounds!.width
        let yPosFactor = sublayer.referencePosition!.y / superLayer.referenceBounds!.height
        
        let newSublayerOriginX = xPosFactor * superLayer.bounds.width
        let newSublayerOriginY = yPosFactor * superLayer.bounds.height
        
        sublayer.frame = CGRect(x: newSublayerOriginX,
                                y: newSublayerOriginY,
                                width: newSublayerWidth,
                                height: newSublayerHeight)
    }
    
}
