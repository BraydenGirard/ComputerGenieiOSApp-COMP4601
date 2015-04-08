//
//  SharedConstants.swift
//  COMP4601A1-100846396-Client
//
//  Created by Ben Sweett on 2015-01-19.
//  Copyright (c) 2015 Ben Sweett. All rights reserved.
//

import Foundation

//current active server
let APPCURRENTSERVER: String = APPSERVERLOCAL + RESTBASE

//Server addresses
let APPSERVERLOCAL: String = "http://localhost:8080"
let APPSERVERAMAZON: String = "http://ec2-54-191-179-67.us-west-2.compute.amazonaws.com"
let APPMEGANS: String = "http://192.168.1.11:8080"

//Server REST Calls
let RESTBASE: String = "/ComputerGenie/rest/api"

//Create Account - POST /user/{authToken}
let APPSIGNUP: String = APPCURRENTSERVER + "/user/0"

//Login - GET /user/{authToken}/{email}/{password}
let APPLOGIN: String = APPCURRENTSERVER + "/user/0/"

//Find user - GET /user/{authToken}/{id}
let APPUSER: String = APPCURRENTSERVER + "/user/"

//Genie Request = POST /genierequest
let APPGENIE: String = APPCURRENTSERVER + "/genie/"

//Products & Reviews
let APPPRODUCT: String = APPCURRENTSERVER + "/product/"

//Product History
let APPHISTORY: String = APPCURRENTSERVER + "/genie/"