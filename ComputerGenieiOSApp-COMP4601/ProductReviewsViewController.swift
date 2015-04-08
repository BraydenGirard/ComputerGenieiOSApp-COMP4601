//
//  ProductReviewsViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-02.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ProductReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ENSideMenuDelegate {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reviewOpinion = "LIKE"
    
    var productId: String!
    var productUrl: String!
    var reviews: [Review]! = []
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        self.navigationItem.hidesBackButton = false
        
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.delegate = self
        self.reviewTextView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedReviewList:", name: "FetchReviewsSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToFetchReviews:", name: "FetchReviewsFail", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedSuccessfulPost:", name: "PostReviewSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToPost:", name: "PostReviewFail", object: nil)
        
        self.sideMenuController()?.sideMenu?.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        self.user = UserDefaultsManager.sharedInstance.getUserData()
        reloadFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProductIdAndUrl(id: String, url: String) {
        self.productId = id
        self.productUrl = url
    }
    
    func setViewTitle(value: String) {
        self.title = value.capitalizedString
    }
    
    func reloadFromServer() {
        NetworkManager.sharedInstance.sendFetchAllReviewsRequest(self.productId, user: self.user)
    }
    
    private func setError(error: String){
            errorLabel.text = error
            errorLabel.hidden = false
    }
    
    private func clearError(){
        
            errorLabel.layer.borderWidth = 0.0
            errorLabel.hidden = true
    }
    
    // MARK: Actions
    
    @IBAction func submitPushed(sender: UIButton) {
        clearError()
        
        let text = reviewTextView.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        if(text.utf16Count > 300) {
            setError("Review is too long!")
        } else if(text.utf16Count < 1) {
            setError("Review is empty!")
        } else {
            validationWasSuccessful()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") as ReviewCell!
        
        var review = reviews[indexPath.row]
        cell?.setReview(review)
        
        var myUID = user.getId()
        for voter in review.getVoters() {
            if voter == myUID {
                cell.setReviewVoted()
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        //Prevent user from rating thier own review and rating a review they have already rated
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ReviewCell {
            var review = cell.getReview()
            var myUID = user.getId()
            if(review.getUserId() == myUID) {
                return false
            }

            for voter in review.getVoters() {
                if voter == myUID {
                    cell.setReviewVoted()
                    return false
                }
            }
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // empty required to allow editing
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var upVoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Like", handler:{action, indexpath in

            //TODO: Disable button after press?
            // Need a way of tracking which things a user has upvoted or downvoted? ie like reddit?
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ReviewCell {
                var review: Review = cell.getReview()
                review.upVote()
                review.addVoter(self.user.getId())
                cell.setReview(review)
                NetworkManager.sharedInstance.sendReviewVoteRequest(self.user, review: review, isUpVote: true)
                tableView.setEditing(false, animated: true)
            }
        })
        upVoteAction.backgroundColor = UIColor(red: 0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1.0);
        
        var downVoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Dislike", handler:{action, indexpath in
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ReviewCell {
                var review: Review = cell.getReview()
                review.downVote()
                review.addVoter(self.user.getId())
                cell.setReview(review)
                NetworkManager.sharedInstance.sendReviewVoteRequest(self.user, review: review, isUpVote: false)
                tableView.setEditing(false, animated: true)
            }
        })
        downVoteAction.backgroundColor = UIColor(red: 196.0/255.0, green: 47.0/255.0, blue: 43.0/255.0, alpha: 1.0);
        
        return [upVoteAction, downVoteAction]
    }
    
    //MARK: Validator Delegate
    
    func validationWasSuccessful() {
        activityIndicator.startAnimating()
        
        var user =  UserDefaultsManager.sharedInstance.getUserData()
        var name = user.getFirstName()
        name += " "
        name += user.getLastName()
        
        var review = Review(pId: self.productId!, uId: user.getId(), uName: name, content: self.reviewTextView.text!, opinion: self.reviewOpinion, upScore: 0, downScore: 0, date: NSDate().timeIntervalSince1970, productName: self.title!.lowercaseString, url: self.productUrl, voters: [])
        
        NetworkManager.sharedInstance.sendReviewRequest(user, review: review)
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
    
    func failedToPost(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Could not post review")
            self.activityIndicator.stopAnimating()
        }
    }
    
    func recievedSuccessfulPost(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Review posted successfully")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func likeSelected(sender: UIButton) {
            
            self.likeButton.backgroundColor = UIColor.grayColor()
            self.likeButton.imageView?.alpha = 0.5
            self.likeButton.titleLabel?.alpha = 0.5
            
            self.dislikeButton.backgroundColor = UIColor(red: 196.0/255, green: 47.0/255.0, blue: 43.0/255.0, alpha: 1)
            self.dislikeButton.imageView?.alpha = 1
            self.dislikeButton.titleLabel?.alpha = 1
            
            self.reviewOpinion = "LIKE"
    }
    
    @IBAction func dislikeSelected(sender: UIButton) {
            
        self.dislikeButton.backgroundColor = UIColor.grayColor()
        self.dislikeButton.imageView?.alpha = 0.5
        self.dislikeButton.titleLabel?.alpha = 0.5
            
        self.likeButton.backgroundColor = UIColor(red: 0.0, green: 204.0/255.0, blue: 0.0, alpha: 1)
        self.likeButton.imageView?.alpha = 1
        self.likeButton.titleLabel?.alpha = 1
            
        self.reviewOpinion = "DISLIKE"
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK:- Side Menu Delegate
    func sideMenuShouldOpenSideMenu() -> Bool {
        return false;
    }
}
