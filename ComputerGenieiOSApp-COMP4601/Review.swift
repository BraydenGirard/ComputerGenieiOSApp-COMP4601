//
//  Review.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-03.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class Review: NSObject {
    
    private var productId: String!
    private var userId: String!
    private var userName: String!
    private var content: String!
    private var opinion: String!
    private var upScore: Int!
    private var downScore: Int!
    private var date: Double!
    
    private var productName: String!
    private var url: String!
    
    init(pId: String, uId: String, uName: String, content: String, opinion: String, upScore: Int, downScore: Int, date: Double, productName: String, url: String) {
        self.productId = pId
        self.userId = uId
        self.userName = uName
        self.content = content
        self.opinion = opinion
        self.upScore = upScore
        self.downScore = downScore
        self.date = date
        self.productName = productName
        self.url = url
    }
    
    func getPIDAndUIDPair() -> String {
        return self.productId + self.userId
    }
    
    func getProductId() -> String {
        return self.productId
    }
    
    func getUserId() -> String {
        return self.userId
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func getOpinion() -> String {
        return self.opinion
    }
    
    func getScore() -> Int {
        return self.upScore - self.downScore
    }
    
    func getUpScore() -> Int {
        return self.upScore
    }
    
    func getDownScore() -> Int {
        return self.downScore
    }
    
    func getDateAsDate() -> NSDate {
        return NSDate(timeIntervalSince1970: self.date)
    }
    
    func getDate() -> Double {
        return self.date
    }
    
    func getProductName() -> String {
        return self.productName
    }
    
    func getUrl() -> String {
        return self.url
    }
    
    func getNSUrl() -> NSURL {
        return NSURL(string: self.url)!
    }
}
