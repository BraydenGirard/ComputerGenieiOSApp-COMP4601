//
//  OSViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class OSViewController: UIViewController {
    enum OS: Int {
        case Windows = 1, Mac, Chrome
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Operating System"
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case OS.Windows.rawValue:
            self.performSegueWithIdentifier("use_segue", sender: sender)
        case OS.Mac.rawValue:
            self.performSegueWithIdentifier("use_segue", sender: sender)
        case OS.Chrome.rawValue:
            self.performSegueWithIdentifier("use_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
    

}
