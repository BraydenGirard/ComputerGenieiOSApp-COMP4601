//
//  UserDefaultsManager.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-29.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

let userTokenKeyConstant = "token"
let userIdKeyConstant = "id"
let userEmailKeyConstant = "email"
let userPasswordKeyConstant = "password"
let userNameKeyConstant = "name"
let userBirthdateKeyConstant = "birthdate"
let userGenderKeyConstant = "gender"
let userLastLoginKeyConstant = "lastlogin"


class UserDefaultsManager {
    
    var userDefaults: NSUserDefaults
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    //Creating Singleton instance of the class
    class var sharedInstance: UserDefaultsManager {
        struct Static {
            static var instance: UserDefaultsManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UserDefaultsManager()
        }
        
        return Static.instance!
    }
    
    //Initializer
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    /**
    Removes all key object pairs from user defaults
    */
    func clearUserDefaults() {
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
    }
    
    //Token - Save / Get
    func saveToken(token: String?) {
        userDefaults.setValue(token, forKey: userTokenKeyConstant)
    }
    
    func getToken() -> String {
        return userDefaults.valueForKey(userTokenKeyConstant)==nil ? "" : userDefaults.valueForKey(userTokenKeyConstant) as String
    }
    
    //User - Save / Get
    func saveUserData(user: User) {
        saveUserID(user.getId())
        saveToken(user.getToken())
        saveEmailID(user.getEmail())
        saveUserName(user.getName())
        savePassword(user.getPassword())
        saveBirthdate(user.getBirthDate())
        saveGender(user.getGender())
        saveLastLogin(user.getLastLogin()!)
    }
    
    func getUserData() -> User {
        return User(token: getToken(), id: getUserID(), email: getEmailID(), password: getPassword(), name: getUserName(), birthdate: getBirthdate(), gender: getGender(), lastLogin: getLastLogin())
    }
    
    //Email - Save / Get
    private func saveEmailID(emailID: String) {
        userDefaults.setValue(emailID, forKey: userEmailKeyConstant)
    }
    
    func getEmailID() -> String {
        return userDefaults.valueForKey(userEmailKeyConstant)==nil ? "" : userDefaults.valueForKey(userEmailKeyConstant) as String
    }
    
    //UserID - Save / Get
    private func saveUserID(userID: String) {
        userDefaults.setValue(userID, forKey: userIdKeyConstant)
    }
    
    func getUserID() -> String {
        return userDefaults.valueForKey(userIdKeyConstant)==nil ? "" : userDefaults.valueForKey(userIdKeyConstant) as String
    }
    
    //UserName - Save / Get
    private func saveUserName(userName: String) {
        userDefaults.setValue(userName, forKey: userNameKeyConstant)
    }
    
    func getUserName() -> String {
        return userDefaults.valueForKey(userNameKeyConstant)==nil ? "" : userDefaults.valueForKey(userNameKeyConstant) as String
    }
    
    //Password - Save / Get
    private func savePassword(password: String) {
        userDefaults.setValue(password, forKey: userPasswordKeyConstant)
    }
    
    func getPassword() -> String {
        return userDefaults.valueForKey(userPasswordKeyConstant)==nil ? "" : userDefaults.valueForKey(userPasswordKeyConstant) as String
    }
    
    //Birthdate - Save / Get
    private func saveBirthdate(birthdate: String?) {
        userDefaults.setValue(birthdate, forKey: userBirthdateKeyConstant)
    }
    
    func getBirthdate() -> String {
        return userDefaults.valueForKey(userBirthdateKeyConstant)==nil ? "" : userDefaults.valueForKey(userBirthdateKeyConstant) as String
    }
    
    //Gender - Save / Get
    private func saveGender(gender: String?) {
        userDefaults.setValue(gender, forKey: userGenderKeyConstant)
    }
    
    func getGender() -> String {
        return userDefaults.valueForKey(userGenderKeyConstant)==nil ? "" : userDefaults.valueForKey(userGenderKeyConstant) as String
    }
    
    //LastActive - Save / Get
    private func saveLastLogin(lastActive: String) {
        userDefaults.setValue(lastActive, forKey: userLastLoginKeyConstant)
    }
    
    func getLastLogin() -> String {
        return userDefaults.valueForKey(userLastLoginKeyConstant) == nil ? "" : userDefaults.valueForKey(userLastLoginKeyConstant) as String
    }
}