//
//  Utils.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-28.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Utils {
    class var sharedInstance: Utils {
        struct Static {
            static var instance: Utils?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Utils()
        }
        
        return Static.instance!
    }
    
    func getHash(string: String) -> String {
        
    }
}