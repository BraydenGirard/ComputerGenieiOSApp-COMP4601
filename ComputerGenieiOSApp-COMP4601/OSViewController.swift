//
//  OSViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class OSViewController: UIViewController, ENSideMenuDelegate {
    enum OS: Int {
        case Windows = 1, Mac, Chrome
    }
    
    var genieRequest: GenieRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Operating System"
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        
        button.setImage(UIImage(named: "back_btn"), forState: UIControlState.Normal)
        button.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_1"), forState: UIControlState.Normal)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItem = barButton2
         self.sideMenuController()?.sideMenu?.delegate = self
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
            self.genieRequest?.setOS("Win")
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
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return false;
    }

}
