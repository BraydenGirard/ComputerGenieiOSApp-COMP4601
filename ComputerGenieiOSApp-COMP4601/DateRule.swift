//
//  DateRule.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class DateRule: Rule {
    var REGEX : String
    
    init(){
        self.REGEX = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s*(\\d{1,2}(st|nd|rd|th)?+)?[,]\\s*\\d{4}"
    }
    
    init(regex:String){
        REGEX = regex
    }
    
    func validate(value: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", self.REGEX)
        if test.evaluateWithObject(value) {
            return true
        }
        return false
    }
    
    func errorMessage() -> String {
        return "Must be a valid date mm/dd/yy"
    }
}