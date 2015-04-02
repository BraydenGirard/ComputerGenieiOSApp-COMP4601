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
    
    /******************************************
                POST network requests
    ******************************************/
    
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
            println("Found a gender")
            xmlString += "<gender>\(genderFinal)</gender>"
        } else {
            xmlString += "<gender></gender>"
        }
        if let birthdateFinal = birthdate {
            println("Found a birthdate")
            xmlString += "<birthday>\(birthdateFinal)</birthday>"
        } else {
            xmlString += "<birthday></birthday>"
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

    func sendGenieRequest(genieRequest: GenieRequest, user: User) {
        var request = NSMutableURLRequest(URL: NSURL(string: APPGENIE + user.getToken()!)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let form = genieRequest.getForm()
        let os = genieRequest.getOS()
        let use = genieRequest.getUse()
        let price = genieRequest.getPrice()
        let screen = genieRequest.getScreen()
        let memory = genieRequest.getMemory()
        let hdd = genieRequest.getHDD()
        let ssd = genieRequest.getSSD()
        
        var xmlString = "<?xml version=\"1.0\" ?>\n"
        xmlString += "<GenieRequest>"
        xmlString += "<form>\(form)</form>"
        xmlString += "<os>\(os)</os>"
        xmlString += "<use>\(use)</use>"
        xmlString += "<price>\(price)</price>"
        if screen == 0 {
             xmlString += "<screen></screen>"
        } else {
             xmlString += "<screen>\(screen)</screen>"
        }
       
        if memory == 0 {
            xmlString += "<memory></memory>"
        } else {
            xmlString += "<memory>\(memory)</memory>"
        }
        if hdd == 0 {
            xmlString += "<hdd></hdd>"
        } else {
            xmlString += "<hdd>\(hdd)</hdd>"
        }
        xmlString += "<ssd>\(ssd)</ssd>"
        xmlString += "</GenieRequest>"
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        
        println("============================THE URL SENT==============================")
        println(APPGENIE + user.getToken()!)
        println("============================THE XML SENT==============================")
        println(xmlString)
       
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("============================THE RESPONSE RECEIVED==============================")
            println(response)
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("============================THE XML Received==============================")
            println(strData)

           
            
            var err: NSError? = error
            
            if(err != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    
                    var results: [GenieResponse]?
                    var idFinal: String?
                    var nameFinal: String?
                    var urlFinal: String?
                    var imageFinal: String?
                    var priceFinal: Float?
                    var retailerFinal: String?
                    
                    //GenieResponses
                    if let responses = xml.root["GenieResponses"]["GenieResponse"].all {
                        for response in responses {
                            if let id = response["id"].value {
                                idFinal = id
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            if let name = response["name"].value {
                                nameFinal = name
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            if let url = response["url"].value {
                                urlFinal = url
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            if let image = response["image"].value {
                                imageFinal = image
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            if let price = response["price"].value {
                                priceFinal = (price as NSString).floatValue
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            if let retailer = response["retailer"].value {
                                retailerFinal = retailer
                            } else {
                                println("Broken genie response")
                                continue
                            }
                            
                            results?.append(GenieResponse(id: idFinal!, name: nameFinal!, url: urlFinal!, image: imageFinal!, price: priceFinal!, retailer: retailerFinal!))
                        }
                    }
                    
                    if(httpResponse.statusCode == 200) {
                        //Send genie object through notification
                        var resultDict: Dictionary<String,[GenieResponse]> = ["genieresponse": results!]
                        NSNotificationCenter.defaultCenter().postNotificationName("GenieSuccess", object: nil, userInfo: resultDict)
                    } else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
                    }
                } else
                {
                    println("Network Manager: Failed to parse success")
                    NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
                }
            }
            else {
                println("Network Manager: Did not get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
            }
            
        })
        
        task.resume()
    }
    
    /******************************************
                GET network requests
    ******************************************/
    
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
                            UserDefaultsManager.sharedInstance.saveUserData(User(token: token, id: id, email: email, password: password, name: firstname + " " + lastname, birthdate: birthday, gender: gender, lastLogin: lastLogin))
                        
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