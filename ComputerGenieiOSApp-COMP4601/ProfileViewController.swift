//
//  ProfileViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var profile_img: UIImageView!
    
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var downvotesLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedProfile:", name: "FetchProfileSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToFetchProfile:", name: "FetchProfileFail", object: nil)
        
        var user = UserDefaultsManager.sharedInstance.getUserData()
        NetworkManager.sharedInstance.fetchProfileForUserRequest(user)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func toggleSideMenu(sender: UIButton) {
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
    
    //MARK: - Notification Handlers
    
    func recievedProfile(notification: NSNotification) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if let userInfo : Dictionary<String,UserProfile> = notification.userInfo as? Dictionary<String,UserProfile> {
                if userInfo.count > 0 {
                    let profile = userInfo.values.array[0]
                    self.reviewsLabel?.text = profile.getTotal()
                    self.upvotesLabel?.text = profile.getUpVotes()
                    self.downvotesLabel?.text = profile.getDownVotes()
                } else {
                    self.reviewsLabel.text = "0"
                    self.upvotesLabel.text = "0"
                    self.downvotesLabel.text = "0"
                }
            }
        }
        
    }
    
    func failedToFetchProfile(notification: NSNotification) {
        
    }
}
