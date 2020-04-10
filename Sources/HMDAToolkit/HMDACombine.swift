//
//  HMDACombine.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import Foundation
import Combine
import UIKit

@available(iOS 13, *)
public protocol CombineSubscriber {
    
    var combineSubscriptions: Set<AnyCancellable>? {get set}
    
}


