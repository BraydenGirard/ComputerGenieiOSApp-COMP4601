//
//  ProductReviewsViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-02.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class MyReviewsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ENSideMenuDelegate {
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reviewOpinion = "LIKE"
    var typeOfReviews: String?
    var productId: String!
    var reviews: [Review]! = []
    
    var webVC: WebViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedReviewList:", name: "FetchReviewsSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToFetchReviews:", name: "FetchReviewsFail", object: nil)
        
        self.sideMenuController()?.sideMenu?.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        var user = UserDefaultsManager.sharedInstance.getUserData()
        if(self.typeOfReviews == "GOOD") {
            NetworkManager.sharedInstance.sendFetchAllGoodReviewsRequest(user)
            self.title = "Positive Reviews"
        } else if (self.typeOfReviews == "BAD") {
            NetworkManager.sharedInstance.sendFetchAllBadReviewsRequest(user)
            self.title = "Negative Reviews"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") as ReviewCell!
        
        var review = reviews[indexPath.row]
        cell?.setReview(review)
        cell?.setReviewCellProductMode()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as ReviewCell!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("reviews_webview_segue", sender: cell)
    }
    
    //MARK: Notification Handlers
    
    func recievedReviewList(notification: NSNotification) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.activityIndicator.stopAnimating()
            self.reviews = []
            
            if let userInfo : Dictionary<String,Review> = notification.userInfo as? Dictionary<String,Review> {
                for review in userInfo.values {
                    self.reviews.append(review)
                }
                
                self.reviewsTableView.reloadData()
            }
        }
    }
    
    func failedToFetchReviews(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Could not fetch reviews")
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "reviews_webview_segue") {
            let destinationViewController = segue.destinationViewController as WebViewController
            if let cell = sender as? ReviewCell {
                var rev = cell.getReview()
                
                destinationViewController.setNSURL(rev.getUrl())
            }
        }
    }
    
    func setTypeOfReviews(type: String) {
        self.typeOfReviews = type
    }
    
    //MARK:- Side Menu Delegate
    func sideMenuShouldOpenSideMenu() -> Bool {
        return false;
    }
}
