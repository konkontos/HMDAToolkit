//
//  HMDAInvertedTableView.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 02/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDAInvertedTableView: UITableView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
}
