//
//  GenieResponse.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-31.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class GenieResponse {
    
    private let name: String
    private let url: String
    private let image: String
    private let price: Float
    private let retailer: String
    
    init(name: String, url: String, image: String, price: Float, retailer: String) {
        self.name = name
        self.url = url
        self.image = image
        self.price = price
        self.retailer = retailer
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getUrl() -> String {
        return self.url
    }
    
    func getImage() -> String {
        return self.name
    }
    
    func getPrice() -> Float {
        return self.price
    }
    
    func getRetailer() -> String {
        return self.retailer
    }
}