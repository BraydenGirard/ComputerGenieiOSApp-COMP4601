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
        xmlString += "<passwordHash>\(passwordHash!)</passwordHash>"
        if let genderFinal = gender {
            xmlString += "<gender>\(genderFinal)</gender>"
        } else {
            xmlString += "<gender xsi:nil=\"true\"/>"
        }
        if let birthdateFinal = birthdate {
            xmlString += "<birthday>\(birthdateFinal)</birthday>"
        } else {
            xmlString += "<birthday xsi:nil=\"true\"/>"
        }
        xmlString += "<lastLoginTime>\(lastLogin)</lastLoginTime>"
        xmlString += "</User>"
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        
        println(xmlString)
        println("Url: " + APPSIGNUP)
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError? = error
            
            if(err != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    let httpCode = xml.root["httpCode"].value
                    let httpMessage = xml.root["httpMessage"].value
                    let serverMessage = xml.root["serverMessage"].value!
                    let success = xml.root["success"].value
                    
                    if let successFinal = success {
                        if(successFinal == "true") {
                            newUser.setToken(serverMessage)
                            UserDefaultsManager.sharedInstance.saveUserData(newUser)
                            var dictionary: [String: AnyObject]  = [userTokenKeyConstant : serverMessage]
                            NSNotificationCenter.defaultCenter().postNotificationName("SignupSuccess", object: nil, userInfo: dictionary)
                        } else {
                            println("Network Manager: Success is equal to: \(successFinal)")
                            NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil)
                        }
                    } else
                    {
                        println("Network Manager: Failed to parse success")
                        NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil)
                    }
                }
                else {
                    println("Network Manager: Failed to parse xml")
                    NSNotificationCenter.defaultCenter().postNotificationName("SignupFail", object: nil)
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
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse  {
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    let token = xml.root["authToken"].value!
                    let id = xml.root["id"].value!
                    let firstname = xml.root["firstname"].value!
                    let lastname = xml.root["lastname"].value!
                    let gender = xml.root["gender"].value
                    let birthday = xml.root["birthday"].value
                    let lastLogin = xml.root["lastLoginTime"].value!
                    
                    if(httpResponse.statusCode == 200) {
                            UserDefaultsManager.sharedInstance.saveUserData(User(token: token, id: id, email: email, password: password, name: firstname + lastname, birthdate: birthday, gender: gender, lastLogin: lastLogin))
                        
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil)
    
                        } else {
                            println("Network Manager: Response code was not 200")
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                        }
                    } else
                    {
                        println("Network Manager: Failed to parse success")
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                    }
                }
                else {
                    println("Network Manager: Did not get response code")
                    NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                }
            
        })
        
        task.resume()
    }
    
    func sendUserRequest(id: String, token: String) {
    
        var request = NSMutableURLRequest(URL: NSURL(string: APPUSER + token + "/" + id)!)
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
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    
                    let token = xml.root["authToken"].value!
                    let id = xml.root["id"].value!
                    let firstname = xml.root["firstname"].value!
                    let lastname = xml.root["lastname"].value!
                    let gender = xml.root["gender"].value
                    let birthday = xml.root["birthday"].value
                    let lastLogin = xml.root["lastLoginTime"].value!
                    let email = xml.root["email"].value!
                    let password = xml.root["passwordHash"].value!
                    
                    if(httpResponse.statusCode == 200) {
                  
                    
                            UserDefaultsManager.sharedInstance.saveUserData(User(token: token, id: id, email: email, password: password, name: firstname + lastname, birthdate: birthday, gender: gender, lastLogin: lastLogin))
                            NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil)
                            
                    }
                    else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                    }
                }
                else {
                    println("Network Manager: Failed to parse xml")
                    NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                }
            } else {
                println("Network Manager: Failed to get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
            }
            
            
        })
        
        task.resume()
    }

    
}