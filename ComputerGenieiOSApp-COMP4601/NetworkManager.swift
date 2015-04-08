//
//  DatabaseManager.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

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
    
    //MARK: - POST Requests
    
    func sendSignupRequest(newUser: User) {
        var request = NSMutableURLRequest(URL: NSURL(string: APPSIGNUP)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let xmlString = newUser.toXMLString(true)
        
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
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPGENIE + tokenString!)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let xmlString = genieRequest.toXMLString()
        
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
                    
                    var results = XmlParser.parseGenieResponses(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        //Send genie object through notification
                        NSNotificationCenter.defaultCenter().postNotificationName("GenieSuccess", object: nil, userInfo: results)
                    } else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
                    }
                }
            }
            else {
                println("Network Manager: Did not get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
            }
            
        })
        
        task.resume()
    }
    
    func sendReviewRequest(user: User, review: Review) {
        let tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPPRODUCT + tokenString! + "/review")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let xmlString = review.toXMLString()
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        
        println(xmlString)
        println("Url: " + APPPRODUCT + user.getToken()! + "/review")
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
                            NSNotificationCenter.defaultCenter().postNotificationName("PostReviewSuccess", object: nil)
                        } else {
                            println("Network Manager: Success is equal to: \(successFinal)")
                            NSNotificationCenter.defaultCenter().postNotificationName("PostReviewFail", object: nil)
                        }
                    } else
                    {
                        println("Network Manager: Failed to parse success")
                        NSNotificationCenter.defaultCenter().postNotificationName("PostReviewFail", object: nil)
                    }
                }
                else {
                    println("Network Manager: Failed to parse xml")
                    NSNotificationCenter.defaultCenter().postNotificationName("PostReviewFail", object: nil)
                }
                
            }
            
        })
        
        task.resume()
    }
    
    func sendHistoryRequest(user: User) {
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPHISTORY + tokenString! + "/history")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var xmlString = user.toXMLString(false)
        
        let data : NSData = (xmlString).dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        
        println("============================THE URL SENT==============================")
        println(APPHISTORY + tokenString! + "/history")
        println("============================THE XML SENT==============================")
        println(xmlString)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("============================THE XML Received==============================")
            println(strData)
            
            var err: NSError? = error
            
            if(err != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName("GenieFail", object: nil)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    
                    var results = XmlParser.parseGenieResponses(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        NSNotificationCenter.defaultCenter().postNotificationName("HistorySuccess", object: nil, userInfo: results)
                    } else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("HistoryFail", object: nil)
                    }
                }
            } else {
                println("Network Manager: Did not get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("HistoryFail", object: nil)
            }
            
        })
        
        task.resume()
    }
    
    //MARK: - GET Requests
    
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
                    
                    let loggedInUser = XmlParser.parseUser(xml, password: email, email: password)
                    
                    if(httpResponse.statusCode == 200) {
                        UserDefaultsManager.sharedInstance.saveUserData(loggedInUser)
                        
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
    
                    let user = XmlParser.parseUser(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        UserDefaultsManager.sharedInstance.saveUserData(user)
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccess", object: nil)
                        
                    } else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginFail", object: nil)
                    }
                } else {
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
    
    func sendAllProductsRequest(user: User) {
        
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPPRODUCT + tokenString!)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let data : NSData = ("").dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println(response)
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(strData)
            
            var err: NSError? = error
            
            if(err != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName("AllProductsFail", object: nil)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    
                    var results = XmlParser.parseGenieResponses(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        //Send genie object through notification
                        NSNotificationCenter.defaultCenter().postNotificationName("AllProductsSuccess", object: nil, userInfo: results)
                    } else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("AllProductsFail", object: nil)
                    }
                } else {
                    println("Network Manager: Failed to parse success")
                    NSNotificationCenter.defaultCenter().postNotificationName("AllProductsFail", object: nil)
                }
            } else {
                println("Network Manager: Did not get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("AllProductsFail", object: nil)
            }
        })
        
        task.resume()
    }
    
    func sendFetchAllReviewsRequest(productId: String, user: User) {
        
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPPRODUCT + tokenString! + "/reviews/" + productId)!)
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
                NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    
                    var results = XmlParser.parseReviews(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsSuccess", object: nil, userInfo: results)
                    }
                    else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
                    }
                }
            } else {
                println("Network Manager: Failed to get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
            }
        })
        
        task.resume()
    }
    
    func sendFetchAllReviewsForUserWithOpinionRequest(user: User, positive: Bool) {
        
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        var request: NSMutableURLRequest
        if(positive) {
            request = NSMutableURLRequest(URL: NSURL(string: APPPRODUCT + tokenString! + "/reviews/positive")!)
        } else {
            request = NSMutableURLRequest(URL: NSURL(string: APPPRODUCT + tokenString! + "/reviews/negative")!)
        }
        
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let data : NSData = ("").dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError? = error
            
            if(err != nil) {
                var dictionary = Dictionary<String, String>()
                dictionary["error"] = err!.localizedDescription
                NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                   
                    var results = XmlParser.parseReviews(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsSuccess", object: nil, userInfo: results)
                    }
                    else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
                    }
                }
            } else {
                println("Network Manager: Failed to get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("FetchReviewsFail", object: nil)
            }
            
        })
        
        task.resume()
    }
    
    func fetchProfileForUserRequest(user: User) {
        var tokenString = user.getToken()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: APPUSER + tokenString! + "/profile")!)
      
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let data : NSData = ("").dataUsingEncoding(NSUTF8StringEncoding)!;
        let length: NSString = NSString(format: "%d", data.length)
        
        var err: NSError?
        request.HTTPBody = data
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(length, forHTTPHeaderField: "Content-Length")
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError? = error
            
            if(err != nil) {
                var dictionary = Dictionary<String, String>()
                dictionary["error"] = err!.localizedDescription
                NSNotificationCenter.defaultCenter().postNotificationName("FetchProfileFail", object: nil)
                
            } else if let httpResponse: NSHTTPURLResponse! = response as? NSHTTPURLResponse {
                if let xml = AEXMLDocument(xmlData: data!, error: &err) {
                    var results = XmlParser.parseUserProfile(xml)
                    
                    if(httpResponse.statusCode == 200) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchProfileSuccess", object: nil, userInfo: results)
                    }
                    else {
                        println("Network Manager: Response code was not 200")
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchProfileFail", object: nil)
                    }
                }
            } else {
                println("Network Manager: Failed to get response code")
                NSNotificationCenter.defaultCenter().postNotificationName("FetchProfileFail", object: nil)
            }
            
        })
        
        task.resume()
        
    }
    
}