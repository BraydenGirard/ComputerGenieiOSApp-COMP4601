//
//  XmlParser.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-07.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class XmlParser: NSObject {
    
    class func parseUser(xml: AEXMLDocument, password: String?=nil, email: String?=nil) -> User {
        
        let token = xml.root["authToken"].value!
        let id = xml.root["id"].value!
        let firstname = xml.root["firstname"].value!
        let lastname = xml.root["lastname"].value!
        let gender = xml.root["gender"].value
        let birthday = xml.root["birthday"].value
        let lastLogin = xml.root["lastLoginTime"].value!
        
        var productHistory: [String]?
        if let productIds = xml.root["productIds"].all {
            for pid in productIds {
                if let id = pid.value {
                    productHistory?.append(id)
                }
            }
        }
        
        var passwordFinal: String!
        var emailFinal: String!
        
        if let pass = password {
           passwordFinal = pass
        } else {
            passwordFinal = xml.root["passwordHash"].value!
        }
        
        if let em = email {
            emailFinal = em
        } else {
            emailFinal = xml.root["email"].value!
        }
        
        var result = User(token: token, id: id, email: emailFinal, password: passwordFinal, name: firstname + " " + lastname, birthdate: birthday, gender: gender, lastLogin: lastLogin, productHistory: productHistory)
        
        return result
    }
    
    class func parseReviews(xml: AEXMLDocument) -> Dictionary<String, Review> {
        
        var results: Dictionary<String, Review> = Dictionary<String, Review>()
        var pIdFinal: String?
        var uIdFinal: String?
        var uNFinal: String?
        var contentFinal: String?
        var opinionFinal: String?
        var upscoreFinal: Int?
        var downscoreFinal: Int?
        var dateFinal: Double?
        var proFinal: String?
        var urlFinal: String?
        
        if let reviews = xml.root["review"].all {
            
            for review in reviews {
                if let id = review["productId"].value {
                    pIdFinal = id
                } else {
                    println("Broken review")
                    continue
                }
                if let userId = review["userId"].value {
                    uIdFinal = userId
                } else {
                    println("Broken review")
                    continue
                }
                if let name = review["userName"].value {
                    uNFinal = name
                } else {
                    println("Broken review")
                    continue
                }
                if let content = review["content"].value {
                    contentFinal = content
                } else {
                    println("Broken review")
                    continue
                }
                if let opinion = review["opinion"].value {
                    opinionFinal = opinion
                } else {
                    println("Broken review")
                    continue
                }
                if let upscore = review["upScore"].value {
                    upscoreFinal = Int((upscore as NSString).intValue)
                } else {
                    println("Broken review")
                    continue
                }
                if let downscore = review["downScore"].value {
                    downscoreFinal = Int((downscore as NSString).intValue)
                } else {
                    println("Broken review")
                    continue
                }
                if let date = review["date"].value {
                    dateFinal = (date as NSString).doubleValue
                } else {
                    println("Broken review")
                    continue
                }
                if let productName = review["productName"].value {
                    proFinal = productName
                } else {
                    println("Broken review")
                    continue
                }
                if let url = review["url"].value {
                    urlFinal = url
                } else {
                    println("Broken review")
                    continue
                }
                
                var theReview = Review(pId: pIdFinal!, uId: uIdFinal!, uName: uNFinal!, content: contentFinal!, opinion: opinionFinal!, upScore: upscoreFinal!, downScore: downscoreFinal!, date: dateFinal!, productName: proFinal!, url: urlFinal!)
                results[theReview.getPIDAndUIDPair()] = theReview
            }
            
        }
        return results
    }
    
    class func parseGenieResponses(xml: AEXMLDocument) -> Dictionary<String, GenieResponse> {
        var results: Dictionary<String, GenieResponse> = Dictionary<String, GenieResponse>()
        var idFinal: String?
        var nameFinal: String?
        var urlFinal: String?
        var imageFinal: String?
        var priceFinal: Float?
        var retailerFinal: String?
        
        //GenieResponses
        if let responses = xml.root["GenieResponse"].all {
            println("Insied xml")
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
                
                var theResponse = GenieResponse(id: idFinal!, name: nameFinal!, url: urlFinal!, image: imageFinal!, price: priceFinal!, retailer: retailerFinal!)
                results[theResponse.getId()] = theResponse
            }
        }
        
        return results
    }
    
    class func parseUserProfile(xml: AEXMLDocument) -> Dictionary<String, UserProfile> {
        var results: Dictionary<String, UserProfile> = Dictionary<String, UserProfile>()
        
        let userId = xml.root["userId"].value
        let upvotes = xml.root["upvotes"].value
        let downvotes = xml.root["downvotes"].value
        let total = xml.root["total"].value
        
        results[userId!] = UserProfile(upvotes: upvotes!, downvotes: downvotes!, total: total!)
        
        return results
    }
}

