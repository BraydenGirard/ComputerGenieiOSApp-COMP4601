//
//  User.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation
import CryptoSwift

let UNKNOWN = "Unknown"

class User {
    
    private var token: String
    private let id: String
    private let email: String
    private var password: String
    private var name: String
    private var birthDate: String
    private var gender: String
    private var lastLogin: String
    private var productHistory: [String] = []
    
    init(id: String, email: String, password: String, name: String) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.token = UNKNOWN
        self.birthDate = UNKNOWN
        self.gender = UNKNOWN
        self.lastLogin = UNKNOWN
        self.productHistory = []
    }
    
    init(token: String, id: String, email: String, password: String, name: String, birthdate: String, gender: String, lastLogin: String, productHistory: [String]) {
        self.token = token
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.birthDate = birthdate
        self.gender = gender
        self.lastLogin = lastLogin
        self.productHistory = productHistory
    }
    
    func getAge() -> Int {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-DD-YY"
        
        if let birthday = dateFormatter.dateFromString(birthDate) {
       
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
    
    func getToken() -> String {
        return self.token
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getEmail() -> String {
        return self.email
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
       return self.getFirstName() + " " + self.getLastName()
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
    
    func getBirthDate() -> String {
        return self.birthDate
    }
    
    func setGender(gender: String) {
        self.gender = gender
    }
    
    func getGender() -> String {
        return self.gender
    }
    
    func updateLastLogin() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.lastLogin = dateFormatter.stringFromDate(NSDate())
    }
    
    func getLastLogin() -> String {
        return self.lastLogin
    }
    
    func setProductHistory(productHistory: [String]) {
        self.productHistory = productHistory
    }
    
    func addProductHistory(productId: String) {
        self.productHistory.append(productId)
    }
    
    func getProductHistory() -> [String] {
        return self.productHistory
    }
    
    func toXMLString() -> String {
        var xmlString = "<?xml version=\"1.0\" ?>\n"
        xmlString += "<user>"
        xmlString += "<authToken>\(self.getToken())</authToken>"
        xmlString += "<id>\(self.getId())</id>"
        xmlString += "<firstname>\(self.getFirstName())</firstname>"
        xmlString += "<lastname>\(self.getLastName())</lastname>"
        xmlString += "<email>\(self.getEmail())</email>"
        xmlString += "<passwordHash>\(self.getPassword().sha512()!)</passwordHash>"
        xmlString += "<gender>\(self.getGender())</gender>"
        xmlString += "<birthday>\(self.getBirthDate())</birthday>"
        xmlString += "<lastLoginTime>\(self.getLastLogin())</lastLoginTime>"
        if(self.getProductHistory().count < 1) {
            xmlString += "<productIds></productIds>"
        }
        for productId in self.getProductHistory() {
            xmlString += "<productIds>\(productId)</productIds>"
        }
        xmlString += "</user>"
        return xmlString
    }
}