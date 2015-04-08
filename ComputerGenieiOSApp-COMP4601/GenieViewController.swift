//
//  GenieViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class GenieViewController: UITableViewController{
    
    var genieResponse: [GenieResponse] = []
    var imageCache: NSCache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache = NSCache()
        
        self.title = "Genie Recommendations"
        self.navigationItem.hidesBackButton = true;
        
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 50, 36)
        button.setTitle("Done", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "donePushed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_5"), forState: UIControlState.Normal)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItem = barButton2
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func productSelected(sender: UIButton) {
        
    }
    
    func setGenieResponse(responses: Dictionary<String, GenieResponse>) {
        
        for response in responses.values {
            self.genieResponse.append(response)
        }
        
        self.tableView.reloadData()
    }
    
    func donePushed(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.genieResponse.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("GenieResultCell") as GenieResultCell!
        
        var response = genieResponse[indexPath.row]
        cell?.setGenie(response)
        
        var image: UIImage? = self.imageCache.objectForKey(response.getId()) as? UIImage
        
        if(image != nil) {
            cell.setThumbnailImage(image!)
            
        } else {
            
            cell.setThumbnailImage(UIImage(named: "find_btn.png")!)
            var urlString = response.getImage()
            
            if urlString != "" {
                var q: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(q, {
                    var image = (UIImage(named: "find_btn.png")!)
                    
                    let url = NSURL(string: urlString)
                    if url != nil {
                        if let data = NSData(contentsOfURL: url!) {
                            image = (UIImage(data: data)!)
                        }
                    }
                    
                    self.imageCache.setObject(image, forKey: response.getId())
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.setThumbnailImage(image)
                    });
                });
            } else {
                cell.setThumbnailImage((UIImage(named: "find_btn.png")!))
            }
            
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? GenieResultCell {
            let url = cell.getGenie().getUrl()
            var user = UserDefaultsManager.sharedInstance.getUserData()
            user.addProductHistory(cell.getGenie().getId())
            UserDefaultsManager.sharedInstance.saveUserData(user)
            
            self.performSegueWithIdentifier("genie_webview_segue", sender: cell)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var reviewProductAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Review", handler:{action, indexpath in
            println("MORE•ACTION");
            self.performSegueWithIdentifier("productReviews", sender: tableView.cellForRowAtIndexPath(indexPath))
            
        });
        reviewProductAction.backgroundColor = UIColor(red: 184.0/255.0, green: 120.0/255.0, blue: 22.0/255.0, alpha: 1.0);
        
        return [reviewProductAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "productReviews") {
            let destinationViewController = segue.destinationViewController as ProductReviewsViewController
            if let cell = sender as? GenieResultCell{
                var genie = cell.getGenie()
                
                destinationViewController.setProductIdAndUrl(genie.getId(), url: genie.getUrl())
                destinationViewController.setViewTitle(genie.getName())
            }
        } else if (segue.identifier == "genie_webview_segue") {
            let destinationViewController = segue.destinationViewController as WebViewController
            if let cell = sender as? GenieResultCell{
                var genie = cell.getGenie()
                
                destinationViewController.setNSURL(genie.getUrl())
            }
        }
    }
}
