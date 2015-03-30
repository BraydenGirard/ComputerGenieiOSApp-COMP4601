//
//  PriceViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController {

    enum Price: Int {
        case FiveHundred = 1, OneThousand, TwoThousand, TwoThousandUp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Price Range"
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case Price.FiveHundred.rawValue:
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.OneThousand.rawValue:
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.TwoThousand.rawValue:
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.TwoThousandUp.rawValue:
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
}
