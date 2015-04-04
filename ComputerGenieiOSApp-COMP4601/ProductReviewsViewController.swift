//
//  ProductReviewsViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-02.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ProductReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ValidationDelegate {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reviewOpinion = "like"
    
    var productId: String!
    var reviews: [Review]!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.delegate = self
        self.reviewsTableView.allowsSelection = false
        
        self.reviewTextView.delegate = self
        
        validator.registerView(reviewTextView, errorLabel: errorLabel, rules: [RequiredRule(), MaxLengthRule()])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedReviewList:", name: "FetchReviewsSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToFetchReviews:", name: "FetchReviewsFail", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedSuccessfulPost:", name: "PostReviewSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToPost:", name: "PostReviewFail", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendFetchAllReviewsRequest(self.productId, user: UserDefaultsManager.sharedInstance.getUserData())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProductId(value: String) {
        self.productId = value
    }
    
    func setViewTitle(value: String) {
        self.title = value
    }
    
    private func setErrors(){
        for (field, error) in validator.viewErrors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        }
    }
    
    private func clearErrors(){
        for (field, error) in validator.viewErrors {
            field.layer.borderWidth = 0.0
            error.errorLabel?.hidden = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func submitPushed(sender: UIButton) {
        clearErrors()
        validator.validateAll(self)
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
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var upVoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Helpful", handler:{action, indexpath in
            println("Helpful");
            //TODO: Disblae once pressed send an upvote request to server and up the score in the app by 1
            
        });
        upVoteAction.backgroundColor = UIColor(red: 0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1.0);
        
        var downVoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Not Helpful", handler:{action, indexpath in
            println("Not Helpful");
            //TODO: Disblae once pressed send an downvote request to server and down the score in the app by 1
            
        });
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
        
        var review = Review(pId: self.productId!, uId: user.getId(), uName: name, content: self.reviewTextView.text!, opinion: self.reviewOpinion, upScore: 0, downScore: 0, date: NSDate().timeIntervalSince1970)
        // TODO: Send review POST
        //NetworkManager.sharedInstance.sendLoginRequet(emailField.text, password: passwordField.text)
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]?, viewErrors: [UITextView:ValidationError]?) {
        self.setErrors()
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
    
    @IBAction func likeSelected(sender: UIButton) {
            
            self.likeButton.backgroundColor = UIColor.grayColor()
            self.likeButton.imageView?.alpha = 0.5
            self.likeButton.titleLabel?.alpha = 0.5
            
            self.dislikeButton.backgroundColor = UIColor(red: 196.0/255, green: 47.0/255.0, blue: 43.0/255.0, alpha: 1)
            self.dislikeButton.imageView?.alpha = 1
            self.dislikeButton.titleLabel?.alpha = 1
            
            self.reviewOpinion = "like"
    }
    
    @IBAction func dislikeSelected(sender: UIButton) {
            
        self.dislikeButton.backgroundColor = UIColor.grayColor()
        self.dislikeButton.imageView?.alpha = 0.5
        self.dislikeButton.titleLabel?.alpha = 0.5
            
        self.likeButton.backgroundColor = UIColor(red: 0.0, green: 204.0/255.0, blue: 0.0, alpha: 1)
        self.likeButton.imageView?.alpha = 1
        self.likeButton.titleLabel?.alpha = 1
            
        self.reviewOpinion = "dislike"
    }
    
}
