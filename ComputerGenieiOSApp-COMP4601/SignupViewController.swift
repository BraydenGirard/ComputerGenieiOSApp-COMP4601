//
//  SignupViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

let MALE = "M"
let FEMALE = "F"

class SignupViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordConfirmField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var nameErrorLabel: UILabel!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var dateErrorLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let validator = Validator()
    
    var maleSelected = false
    var femaleSelected = false
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Signup"
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 50, 36)
        button.setTitle("< Back", forState: UIControlState.Normal)
        button.addTarget(self, action: "backPushed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton

        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(passwordConfirmField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordField)])
        validator.registerField(nameField, errorLabel: nameErrorLabel, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(dateField, errorLabel: dateErrorLabel, rules: [DateRule()])
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "completeSignup:", name: "SignupSuccess", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "failSignup:", name: "SignupFail", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func completeSignup(notification: NSNotification) {
        //Log the user in and give them their token
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Signup successful")
            self.activityIndicator.stopAnimating()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func failSignup(notification:NSNotification) {
        //Show error
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Signup failed")
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func signupPushed(sender: UIButton) {
        self.clearErrors()
        validator.validateAll(self)
    }
    
    func backPushed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    @IBAction func malePushed(sender: UIButton) {
        if maleSelected {
            maleSelected = false
            sender.setImage(UIImage(named: "male"), forState: UIControlState.Normal)
        } else {
            maleSelected = true
            femaleSelected = false
            sender.setImage(UIImage(named: "male_selected"), forState: UIControlState.Normal)
            femaleButton.setImage(UIImage(named: "female"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func femalePushed(sender: UIButton) {
        if femaleSelected {
            femaleSelected = false
            sender.setImage(UIImage(named: "female"), forState: UIControlState.Normal)
        } else {
            femaleSelected = true
            maleSelected = false
            sender.setImage(UIImage(named: "female_selected"), forState: UIControlState.Normal)
            maleButton.setImage(UIImage(named: "male"), forState: UIControlState.Normal)
        }
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationWasSuccessful() {
        println("Validation Success!")
        var uuid = NSUUID().UUIDString
        var newUser = User(id: uuid, email: emailField.text, password: passwordField.text, name: nameField.text)
        
        if maleSelected || femaleSelected {
            if maleSelected {
                newUser.setGender(MALE)
            } else {
                newUser.setGender(FEMALE)
            }
        }
        
        if let date = selectedDate {
            newUser.setBirthDate(date)
        }
        
        activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendSignupRequest(newUser)
        
        //self.presentViewController(alert, animated: true, completion: nil)
    }
    func validationFailed(errors:[UITextField:ValidationError]) {
        println("Validation FAILED!")
        self.setErrors()
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