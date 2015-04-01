//
//  SettingsViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        button.setImage(UIImage(named: "menu_button"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleSideMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    @IBAction func logoutPushed(sender: UIButton) {
        println("User logging out")
        UserDefaultsManager.sharedInstance.clearUserDefaults()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)

        var homeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        
        self.presentViewController(homeViewController, animated: true, completion: {})
    }
}
