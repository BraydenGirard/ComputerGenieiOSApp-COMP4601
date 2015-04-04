//
//  File.swift
//  Pingo
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//

import Foundation
import UIKit

class ValidationError {
    let textView:UITextView?
    let textField:UITextField?
    var errorLabel:UILabel?
    let errorMessage:String
    
    init(textField:UITextField, error:String){
        self.textField = textField
        self.errorMessage = error
    }
    
    init(textView:UITextView, error:String){
        self.textView = textView
        self.errorMessage = error
    }
    
}