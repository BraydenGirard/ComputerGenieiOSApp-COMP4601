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
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let id = newUser.getId()
        let firstname = newUser.getFirstName()
        let lastname = newUser.getLastName()
        let email = newUser.getEmail()
        let password = newUser.getPassword()
        let passwordHash = password.sha512()
        let gender = newUser.getGender()
        let birthdate = newUser.getBirthDate()
        let lastLogin = newUser.getLastLogin()
        
        var xmlString = "<?xml version=\"1.0\" ?>\n"
        xmlString += "<User>"
        xmlString += "<authToken>0</authToken>"
        xmlString += "<id>\(id)</id>"
        xmlString += "<firstname>\(firstname)</firstname>"
        xmlString += "<lastname>\(lastname)</lastname>"
        xmlString += "<email>\(email)</email>"
        xmlString += "<passwordHash>\(passwordHash)</passwordHash>"
        xmlString += "<gender>\(gender)</gender>"
        xmlString += "<birthday>\(birthdate)</birthday>"
        xmlString += "<lastLoginTime>\(lastLogin)</lastLoginTime>"
        xmlString += "</User>"
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError? = error
            
            if(err != nil) {
                var dictionary = Dictionary<String, String>()
                dictionary["error"] = err!.localizedDescription
                NSNotificationCenter.defaultCenter().postNotificationName("NETWORK-ERROR", object: nil, userInfo: dictionary)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    let httpCode = xml.root["httpCode"].value
                    let httpMessage = xml.root["httpMessage"].value
                    let serverMessage = xml.root["serverMessage"].value!
                    let success = xml.root["success"].value
                    
                    if let successFinal = success {
                        if(successFinal == "true") {
                            var dictionary: [String: AnyObject]  = ["token" : serverMessage]
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil, userInfo: dictionary)
                        } else {
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                        }
                    } else
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                    }
                }
                else {
                    NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                }

            }
            
        })
        
        task.resume()
    }
    
    func sendLoginRequet(email: String, password: String) {
        
        let passwordHash = password.sha512()
        var request = NSMutableURLRequest(URL: NSURL(string: APPLOGIN + email + "/" + passwordHash!)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let data : NSData = ("").dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Accept")
        
        println("sent")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError? = error
            
            if(err != nil) {
                var dictionary = Dictionary<String, String>()
                dictionary["error"] = err!.localizedDescription
                NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
            } else {
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    let httpCode = xml.root["httpCode"].value
                    let httpMessage = xml.root["httpMessage"].value
                    let serverMessage = xml.root["serverMessage"].value!
                    let success = xml.root["success"].value
                    
                    if let successFinal = success {
                        if(successFinal == "true") {
                            var dictionary: [String: AnyObject]  = ["token" : serverMessage]
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil, userInfo: dictionary)
    
                        } else {
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                        }
                    } else
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                    }
                }
                else {
                    NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                }
            }
            
        })
        
        task.resume()
    }

    
}