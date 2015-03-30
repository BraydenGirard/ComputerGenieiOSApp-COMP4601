//
//  UseViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class UseViewController: UIViewController {
    enum Use: Int {
        case School = 1, Gaming, Work, Leisure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Computer Use"
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case Use.School.rawValue:
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Gaming.rawValue:
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Work.rawValue:
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Leisure.rawValue:
            self.performSegueWithIdentifier("price_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
}
