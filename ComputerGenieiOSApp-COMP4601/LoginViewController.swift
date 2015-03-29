//
//  ViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordErrorLabel: UILabel!
    
    let validator = Validator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), PasswordRule()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: ValidationDelegate Methods
    
    func validationWasSuccessful() {
        println("Validation Success!")
        
        // TODO: Send login request to server
        
        //self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func validationFailed(errors:[UITextField:ValidationError]) {
        println("Validation FAILED!")
        self.setErrors()
    }
    
    @IBAction func loginPushed(sender: UIButton) {
        self.clearErrors()
        validator.validateAll(self)
    }
    private func setErrors(){
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        }
    }
    
    private func clearErrors(){
        for (field, error) in validator.errors {
            field.layer.borderWidth = 0.0
            error.errorLabel?.hidden = true
        }
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
}

