//
//  HMDAInvertedTableViewCell.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 02/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDAInvertedTableViewCell: UITableViewCell {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
