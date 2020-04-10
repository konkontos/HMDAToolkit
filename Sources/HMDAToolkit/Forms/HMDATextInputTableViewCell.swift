//
//  HMDATextInputTableViewCell.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 19/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import UIKit

open class HMDATextInputTableViewCell: HMDAInputWithPromptTableViewCell, UITextFieldDelegate, HMDAInputViewToolbarDelegate {

    open var validation = HMDATextInputValidator.type.none {
        
        didSet {
            
            switch validation {
                
            case .phone:
                textField.keyboardType = .phonePad
                
            case .email:
                textField.keyboardType = .emailAddress
                
            case .number:
                textField.keyboardType = .decimalPad
                
            default:
                textField.keyboardType = .default
            }
            
        }
        
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
    
    /// Override to provide the default value for the text field.
    open var strItem: String? {
        return nil
    }
    
    override open var editingStyle: UITableViewCell.EditingStyle {
        return .none
    }
    
    lazy open var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.isHidden = true
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = UIColor.clear
        
        textField.inputAccessoryView = HMDAInputViewToolbar(frame: HMDAInputViewToolbar.defaultRect, withDelegate: self)
        
        return textField
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupUIElements()
    }
    
    

    private func setupUIElements() {
        selectionStyle = .none
        
        textLabel?.isUserInteractionEnabled = true
        textLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textLabelTap(_:))))
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        textLabel?.text = strItem
        textField.text = textLabel?.text
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
    
        layoutSubviews()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        switch isSelected {
            
        case true:
            textLabel?.isHidden = true
            textField.isHidden = false
            textField.becomeFirstResponder()
            
        case false:
            textField.isHidden = true
            textLabel?.isHidden = false
            
        }
        
    }
    
    
    /// Override to update your backend after editing has ended.
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.text = textField.text
    }
    
    
    // MARK: - Actions
    
    @IBAction func textLabelTap(_ recognizer: UITapGestureRecognizer) {
        isSelected = !isSelected
    }
    
    // Textfield Delegate
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        detailTextLabel?.isHidden = true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        detailTextLabel?.isHidden = false
        isSelected = false
        
        if isValid == false {
            textField.text = nil
        }
        
    }
    
    @objc @IBAction public func inputViewDismissButtonTapped(_ sender: AnyObject?) {
        endEditing(true)
    }
    
    // MARK: - Misc.
    
    var isValid: Bool {
        
        var result = true
        
        switch validation {
            
        case .phone:
            result = HMDATextInputValidator.type.phone(textField.text).validate()
            
        case .email:
            result = HMDATextInputValidator.type.email(textField.text).validate()
            
        case .number:
            result = HMDATextInputValidator.type.number(textField.text).validate()
            
        default:
            break
        }
        
        return result
        
    }
    
}

