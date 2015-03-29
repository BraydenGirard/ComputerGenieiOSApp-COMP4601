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
    
    func sendSignupRequest(newUser: User) {
        var request = NSMutableURLRequest(URL: NSURL(string: APPSIGNUP)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let xmlString: String = "<?xml version=\"1.0\" ?>\n" + "<User>" +
                                "<authToken>" + 0 + "</authToken>" +
                                "<id>" + user.getId() + "</id>" +
                                "<firstname>" + user.getFirstName() + "</firstname>" +
                                "<lastname>" + user.getLastName() + "</lastname>" +
                                "<email>" + user.getEmail() + "</email>" +
                                "<passwordHash>" + user. + "</passwordHash>" +
                                "<gender>" + name + "</gender>" +
                                "<birthday>" + text + "</birthday>" +
                                "<lastLoginTime>" + text + "</lastLoginTime>" +
                                "</User>"
        
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
                
                var result: String! = ""
                
                if(httpResponse.statusCode == 200) {
                    result = "Document Created"
                } else if (httpResponse.statusCode == 204) {
                    result = "Document Creation Failed: No Content"
                } else if (httpResponse.statusCode == 406) {
                    result = "Document Creation Failed: Bad Request"
                } else if (httpResponse.statusCode == 404) {
                    result = "Document Creation Failed: Link Not Found"
                } else {
                    result = "Document Creation Failed: Internal Server Error"
                }
                
                var dictionary = Dictionary<String, String>()
                dictionary["message"] = result
                NSNotificationCenter.defaultCenter().postNotificationName("CREATE", object: nil, userInfo: dictionary)
            }
            
        })
        
        task.resume()
    }
    
    func sendLoginRequet(user: User) {
        var request = NSMutableURLRequest(URL: NSURL(string: APPLOGIN + user.getEmail() + "/" + user.getPassword())!)
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
                NSNotificationCenter.defaultCenter().postNotificationName("NETWORK-ERROR", object: nil, userInfo: dictionary)
            } else {
                var dictionary = Dictionary<String, NSData>()
                dictionary["data"] = data
                NSNotificationCenter.defaultCenter().postNotificationName("VIEW-XML", object: nil, userInfo: dictionary)
            }
            
        })
        
        task.resume()
    }

    
}