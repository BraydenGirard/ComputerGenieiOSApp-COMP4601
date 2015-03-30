//
//  MainController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-29.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var firstLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLoad = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let token = defaults.stringForKey(userTokenKeyConstant)
        {
            //Setup view
        } else {
            println("Calling login segue")
            self.performSegueWithIdentifier(loginSegue, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func logoutPushed(sender: UIButton) {
        UserDefaultsManager.sharedInstance.clearUserDefaults()
        self.performSegueWithIdentifier(loginSegue, sender: self)
    }
    
    
    
}