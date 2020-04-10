//
//  HMDAInputWithPromptTableViewCell.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 19/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDAInputWithPromptTableViewCell: UITableViewCell {

    /// Override to provide your own prompt
    open var prompt: String {
        return "[Prompt Label Text]"
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUIElements()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
    }
    
    
    private func setupUIElements() {
        detailTextLabel?.textColor = UIColor.orange
        detailTextLabel?.text = prompt
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
