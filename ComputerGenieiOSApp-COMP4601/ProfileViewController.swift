//
//  ProfileViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ENSideMenuDelegate {
    

    @IBOutlet var profile_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile_img.layer.borderWidth = 3.0
        profile_img.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.title =  UserDefaultsManager.sharedInstance.getUserData().getName()
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "good_segue") {
            let destinationViewController = segue.destinationViewController as MyReviewsController
            destinationViewController.setTypeOfReviews("GOOD")
        } else if(segue.identifier == "bad_segue") {
            let destinationViewController = segue.destinationViewController as MyReviewsController
            destinationViewController.setTypeOfReviews("BAD")
        }
    }
    
    
}
