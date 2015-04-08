//
//  UserProfile.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-07.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class UserProfile: NSObject {
   
    private var upvotes: String!
    private var downvotes: String!
    private var total: String!
    
    init(upvotes: String, downvotes: String, total: String) {
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.total = total
    }
    
    func getUpVotes() -> String {
        return self.upvotes
    }
    
    func getDownVotes() -> String {
        return self.downvotes
    }
    
    func getTotal() -> String {
        return self.total
    }
}
