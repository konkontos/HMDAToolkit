//
//  HMDADateInputTableViewCell.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 19/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDADateInputTableViewCell: HMDAInputWithPromptTableViewCell, UITextFieldDelegate, HMDAInputViewToolbarDelegate {

    /// Override to provide the default value for the text field.
    open var strItem: String? {
        return nil
    }
    
    override open var editingStyle: UITableViewCell.EditingStyle {
        return .none
    }
    
    var inputAccessoryDoneButtonText: String? {
        
        didSet {
            
            if inputAccessoryDoneButtonText == nil {
                textField.inputAccessoryView = HMDAInputViewToolbar(frame: HMDAInputViewToolbar.defaultRect, withDelegate: self)
            } else {
                textField.inputAccessoryView = HMDAInputViewToolbar(frame: HMDAInputViewToolbar.defaultRect, withDelegate: self,
                                                                andButtonText: inputAccessoryDoneButtonText!)
            }
            
        }
        
    }
    
    lazy open var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.date = Date()
        picker.datePickerMode = .date
        
        picker.locale = Locale.autoupdatingCurrent
        picker.timeZone = TimeZone.autoupdatingCurrent
        picker.calendar = Calendar.autoupdatingCurrent
        
        return picker
    }()
    
    lazy open var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = UIColor.clear
        
        textField.inputView = datePicker
        textField.inputAccessoryView = HMDAInputViewToolbar(frame: HMDAInputViewToolbar.defaultRect, withDelegate: self)
        
        return textField
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupUIElements()
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
    }
    
    
    private func setupUIElements() {
        selectionStyle = .none
        
        textLabel?.isHidden = true
        
        textLabel?.text = "[some unseen text]"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -16.0).isActive = true
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layoutSubviews()
    }
    
    
    /// Override to update your backend after editing has ended.
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if (textField.text?.count)! < 1 {
            textField.text = strItem
        }
        
    }
    
    // MARK: - Actions
    @objc @IBAction public func inputViewDismissButtonTapped(_ sender: AnyObject?) {
        textField.endEditing(true)
    }

}

