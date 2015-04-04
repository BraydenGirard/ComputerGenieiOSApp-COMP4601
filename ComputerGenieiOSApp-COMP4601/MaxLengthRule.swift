//
//  MaxLengthRule.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-03.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class MaxLengthRule: Rule {
   
    private let DEFAULT_MAX_LENGTH: Int
    
    init(){
        DEFAULT_MAX_LENGTH = 299
    }
    
    init(length:Int){
        self.DEFAULT_MAX_LENGTH = length
    }
    
    func validate(value: String) -> Bool {
        if value.utf16Count > DEFAULT_MAX_LENGTH {
            return false
        }
        return true
    }
    
    func errorMessage() -> String {
        return "Must be less than \(DEFAULT_MAX_LENGTH) characters long"
    }
    
}
