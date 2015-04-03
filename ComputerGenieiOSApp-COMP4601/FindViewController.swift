//
//  FindViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, ENSideMenuDelegate {
    
    enum Hardware: Int {
        case Desktop = 1, Laptop
    }
    
    var genieRequest: GenieRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find Product"
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        button.setImage(UIImage(named: "menu_button"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleSideMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
      
        self.navigationItem.leftBarButtonItem = barButton
        
        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_0"), forState: UIControlState.Normal)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItem = barButton2
    }
    
    override func viewDidAppear(animated: Bool) {
        genieRequest = GenieRequest()
        genieRequest?.print()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case Hardware.Desktop.rawValue:
            self.genieRequest?.setForm("DESKTOP")
            self.performSegueWithIdentifier("os_segue", sender: sender)
        case Hardware.Laptop.rawValue:
            
            self.genieRequest?.setForm("LAPTOP")
            self.performSegueWithIdentifier("os_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "os_segue") {
            let destinationViewController = segue.destinationViewController as OSViewController
            destinationViewController.setGenieRequest(self.genieRequest)
        }
    }
    
    func toggleSideMenu(sender: UIButton) {
        println("Button pushed")
        self.toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        println("sideMenuShouldOpenSideMenu")
        return true
    }
}
