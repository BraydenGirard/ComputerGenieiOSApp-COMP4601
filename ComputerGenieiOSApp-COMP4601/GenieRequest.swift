//
//  GenieRequest.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

let unknown = "Unknown"
class GenieRequest {
    
    private var form: String
    private var os: String
    private var use: String
    private var price: Int
    private var screen: Int
    private var memory: Int
    private var hdd: Int
    private var ssd: Bool
    
    init() {
        self.form = unknown
        self.os = unknown
        self.use = unknown
        self.price = 0
        self.screen = 0
        self.memory = 0
        self.hdd = 0
        self.ssd = false
    }
    
    func setForm(form: String) {
        self.form = form
    }
    
    func getForm() -> String {
        return self.form
    }
    
    func setOS(os: String) {
        self.os = os
    }
    
    func getOS() -> String {
        return self.os
    }
    
    func setUse(use: String) {
        self.use = use
    }
    
    func getUse() -> String {
        return self.use
    }
    
    func setPrice(price: Int) {
        self.price = price
    }
    
    func getPrice() -> Int {
        return self.price
    }
    
    func setScreen(screen: Int) {
        self.screen = screen
    }
    
    func getScreen() -> Int {
        return self.screen
    }
    
    func setMemory(memory: Int) {
        self.memory = memory
    }
    
    func getMemory() -> Int {
        return self.memory
    }
    
    func setHDD(hdd: Int) {
        self.hdd = hdd
    }
    
    func getHDD() -> Int {
        return self.hdd
    }
    
    func setSSD(ssd: Bool) {
        self.ssd = ssd
    }
    
    func getSSD() -> Bool {
        return self.ssd
    }
    
    func print() {
        println("=============Genie Request=============")
        println("Form: \(self.form)")
        println("OS: \(self.os)")
        println("Use: \(self.use)")
        println("Price: \(self.price)")
        println("Screen \(self.screen)")
        println("Memory: \(self.memory)")
        println("SSD: \(self.ssd)")
        println("HDD: \(self.hdd)")
        println("=======================================")
    }
    
    func toXMLString() -> String {
        
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
        
        return xmlString
    }
}