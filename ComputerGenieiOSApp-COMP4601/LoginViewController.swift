//
//  ViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

let loginSegue = "login_segue"

class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        self.navigationItem.hidesBackButton = true;
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), PasswordRule()])
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "completeLogin:", name: "LoginSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failLogin:", name: "LoginFail", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func completeLogin(notification: NSNotification) {
        //Log the user in here and give them their token from the notification
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Login successful")
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewControllerAnimated(true)
        }
       
    }
    
    func failLogin(notification:NSNotification) {
        //Show an error
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Login failed")
            self.activityIndicator.stopAnimating()
        }
    }

    
    // MARK: ValidationDelegate Methods
    
    func validationWasSuccessful() {
        println("Validation Success!")
        
        // TODO: Send login request to server
        activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendLoginRequet(emailField.text, password: passwordField.text)
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]?, viewErrors: [UITextView:ValidationError]?) {
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

