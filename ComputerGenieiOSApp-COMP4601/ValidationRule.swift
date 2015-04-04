//
//  ValidationRule.swift
//  Pingo
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//

import Foundation
import UIKit

class ValidationRule {
    var textView:UITextView?
    var textField:UITextField?
    var errorLabel:UILabel?
    var rules:[Rule] = []
    
    init(textField: UITextField, rules:[Rule], errorLabel:UILabel?){
        self.textField = textField
        self.errorLabel = errorLabel
        self.rules = rules
    }
    
    init(textView: UITextView, rules:[Rule], errorLabel:UILabel?){
        self.textView = textView
        self.rules = rules
        self.errorLabel = errorLabel
    }
    
    func validateField() -> ValidationError? {
        for rule in rules {
            if textField != nil {
                var isValid:Bool = rule.validate(textField!.text)
                if !isValid {
                    return ValidationError(textField: self.textField!, error: rule.errorMessage())
                }
            }
        }
        return nil
    }
    
    func validateView() -> ValidationError? {
        for rule in rules {
            if textView != nil {
                var isValid:Bool = rule.validate(textView!.text)
                if !isValid {
                    return ValidationError(textField: self.textField!, error: rule.errorMessage())
                }
            }
        }
        
        return nil
    }
    
}