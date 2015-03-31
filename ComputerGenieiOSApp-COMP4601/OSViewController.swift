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
    
    var genieRequest: GenieRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Operating System"
    }
    
    override func viewDidAppear(animated: Bool) {
        genieRequest?.print()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case OS.Windows.rawValue:
            self.genieRequest?.setOS("Windows")
            self.performSegueWithIdentifier("use_segue", sender: sender)
        case OS.Mac.rawValue:
            self.genieRequest?.setOS("Mac")
            self.performSegueWithIdentifier("use_segue", sender: sender)
        case OS.Chrome.rawValue:
            self.genieRequest?.setOS("Chrome")
            self.performSegueWithIdentifier("use_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
    
    func setGenieRequest(genieRequest: GenieRequest?) {
        self.genieRequest = genieRequest
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "use_segue") {
            let destinationViewController = segue.destinationViewController as UseViewController
            destinationViewController.setGenieRequest(self.genieRequest)
        }
    }
    

}
