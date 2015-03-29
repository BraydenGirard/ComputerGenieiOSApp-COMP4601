//
//  DatabaseManager.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

class NetworkManager {
    
    class var sharedInstance: NetworkManager {
        struct Static {
            static var instance: NetworkManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NetworkManager()
        }
        
        return Static.instance!
    }
   
    func sendSignupRequest(newUser: User) {
        var request = NSMutableURLRequest(URL: NSURL(string: APPSIGNUP)!)
      
    
        var passwordData = (newUser.getPassword() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let passwordHash = passwordData?.sha512()
        let lastLogin = newUser.getLastLogin()
        
        let xmlString: String = "<?xml version=\"1.0\" ?>\n" + "<User>" +
                                "<authToken>" + 0 + "</authToken>" +
                                "<id>" + newUser.getId() + "</id>" +
                                "<firstname>" + newUser.getFirstName() + "</firstname>" +
                                "<lastname>" + newUser.getLastName() + "</lastname>" +
                                "<email>" + newUser.getEmail() + "</email>" +
                                "<passwordHash>" + passwordHash?.hexString + "</passwordHash>" +
                                "<gender>" + newUser.getGender() + "</gender>" +
                                "<birthday>" + newUser.getBirthDate() + "</birthday>" +
                                "<lastLoginTime>" + lastLogin + "</lastLoginTime>" +
                                "</User>"
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
       
        Alamofire.request(.POST, APPSIGNUP,  data: data, contentType: "application/xml").responseString {
            
            (request, response, string, error) in
            
            if (error != nil) {
                println( error?.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName("NetworkError", object: nil)
                
            } else {
                let xmlData = string?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                var err: NSError?
                if let xml = AEXMLDocument(xmlData: xmlData!, error: &err) {
                    
                    var httpCode = xml.root["httpCode"].value
                    var httpMessage = xml.root["httpMessage"].value
                    var serverMessage = xml.root["serverMessage"].value
                    var success = xml.root["success"].value
                    
                    if success {
                        var dictionary = Dictionary<String, String>()
                        dictionary["userToken"]
                        NSNotificationCenter.defaultCenter().postNotificationName("SignupSuccess", object: nil, userInfo: dictionary)
                    } else
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil, userInfo: nil)
                    }
                    
                   
                    
                } else {
                    //Error getting xml back
                    println("description: \(error?.localizedDescription)\ninfo: \(err?.userInfo)")
                    NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil, userInfo: nil)
                }
            }
        }
    }
    
    func sendLoginRequet(email: String, password: String) {
        
        var passwordData = (password as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let passwordHash = passwordData?.sha512()
        
        Alamofire.request(.GET, APPLOGIN + email + "/" + passwordHash?.hexString, parameters: _).responseString {
            
            (request, response, string, error) in
            
            if (error != nil) {
                    println( error?.localizedDescription)
                    NSNotificationCenter.defaultCenter().postNotificationName("NetworkError", object: nil)
                    
                } else {
                    let xmlData = string?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var err: NSError?
                    if let xml = AEXMLDocument(xmlData: xmlData!, error: &err) {
                        
                        var httpCode = xml.root["httpCode"].value
                        var httpMessage = xml.root["httpMessage"].value
                        var serverMessage = xml.root["serverMessage"].value
                        var success = xml.root["success"].value
                        
                        if success {
                            // Parse xml here
                            var dictionary = Dictionary<String, String>()
                            dictionary["userToken"]
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil, userInfo: dictionary)
                        } else
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil, userInfo: nil)
                        }
                        
                    } else {
                        //Error getting xml back
                        println("description: \(error?.localizedDescription)\ninfo: \(err?.userInfo)")
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil, userInfo: nil)
                    }
                }
        }
    }

    
}