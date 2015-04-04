//
//  Validator.swift
//  Pingo
//
//  Created by Jeff Potter on 11/10/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ValidationDelegate {
    func validationWasSuccessful()
    func validationFailed(errors:[UITextField:ValidationError]?, viewErrors: [UITextView:ValidationError]?)
}

class Validator {
    // dictionary to handle complex view hierarchies like dynamic tableview cells
    var errors:[UITextField:ValidationError] = [:]
    var viewErrors: [UITextView:ValidationError] = [:]
    var validations:[UITextField:ValidationRule] = [:]
    var validationsView:[UITextView:ValidationRule] = [:]
    
    init(){}
    
    // MARK: Using Keys
    
    func registerField(textField:UITextField, rules:[Rule]) {
        validations[textField] = ValidationRule(textField: textField, rules: rules, errorLabel: nil)
    }
    
    func registerField(textField:UITextField, errorLabel:UILabel, rules:[Rule]) {
        validations[textField] = ValidationRule(textField: textField, rules:rules, errorLabel:errorLabel)
    }
    
    func registerView(textView: UITextView, rules:[Rule]) {
        validationsView[textView] = ValidationRule(textView: textView, rules: rules, errorLabel: nil)
    }
    
    func registerView(textView: UITextView, errorLabel: UILabel, rules:[Rule]) {
        validationsView[textView] = ValidationRule(textView: textView, rules: rules, errorLabel: errorLabel)
    }
    
    func validateAll(delegate:ValidationDelegate) {
        
        for field in validations.keys {
            if let currentRule:ValidationRule = validations[field] {
                if var error:ValidationError = currentRule.validateField() {
                    if (currentRule.errorLabel != nil) {
                        error.errorLabel = currentRule.errorLabel
                    }
                    errors[field] = error
                } else {
                    errors.removeValueForKey(field)
                }
            }
        }
        
        for view in validationsView.keys {
            if let currentRule:ValidationRule = validationsView[view] {
                if var error:ValidationError = currentRule.validateView() {
                    if(currentRule.errorLabel != nil) {
                        error.errorLabel = currentRule.errorLabel
                    }
                    viewErrors[view] = error
                } else {
                    viewErrors.removeValueForKey(view)
                }
            }
        }
        
        if errors.isEmpty && viewErrors.isEmpty {
            delegate.validationWasSuccessful()
        } else if viewErrors.isEmpty {
            delegate.validationFailed(errors, viewErrors: nil)
        } else {
            delegate.validationFailed(nil, viewErrors: viewErrors)
        }
    }
    
    func clearErrors(){
        self.errors = [:]
        self.viewErrors = [:]
    }
    
}