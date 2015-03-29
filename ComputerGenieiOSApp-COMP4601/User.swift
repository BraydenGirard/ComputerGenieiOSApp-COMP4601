//
//  User.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class User {
    
    private let id: String
    private let email: String
    private var password: String
    private var name: String
    private var birthDate: String?
    private var gender: String?
    
    init(id: String, email: String, password: String, name: String) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
    }
    
    func getAge() -> Int {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        if let birthday = dateFormatter.dateFromString(birthDate!) {
       
            var now = NSDate()
            var calendar : NSCalendar = NSCalendar.currentCalendar()
        
            let ageComponents = calendar.components(.CalendarUnitYear,
                fromDate: birthday,
                toDate: now,
                options: nil)
        
            return ageComponents.year
        }
        
        return 0
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getEmail() -> String {
        return self.getEmail()
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func getPassword() -> String {
        return self.password
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func getFirstName() -> String {
        var nameArray:[String] = split(self.name) { $0 == " " }
        var firstName = ""
        
        if(nameArray.count > 0) {
            firstName = nameArray[0]
        }
        
        return firstName
    }
    
    func getLastName() -> String {
        var nameArray:[String] = split(self.name) { $0 == " " }
        var lastName = ""
        for var i=0; i<nameArray.count; i++ {
            if i > 0 {
                lastName += nameArray[i]
            }
        }
        
        return lastName
    }
    
    func setBirthDate(birthDate: String) {
        self.birthDate = birthDate
    }
    
    func getBirthDate() -> String? {
        return self.birthDate
    }
    
    func setGender(gender: String) {
        self.gender = gender
    }
    
    func getGender() -> String? {
        return self.gender
    }
}