//
//  ProductsViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController, ENSideMenuDelegate {
    
    var genieResponse: [GenieResponse] = []
    var imageCache: NSCache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache = NSCache()
        
        self.title = "My Reviews"
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        button.setImage(UIImage(named: "menu_button"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleSideMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)

        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievedProductList:", name: "AllProductsSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedToFetchProductList:", name: "AllProductsFail", object: nil)
        
        NetworkManager.sharedInstance.sendAllProductsRequest(UserDefaultsManager.sharedInstance.getUserData())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("GenieResultCell") as GenieResultCell
        
        var response = genieResponse[indexPath.row]
        cell.setGenie(response)
        
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? GenieResultCell {
            let url = cell.getGenie().getUrl()
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
    }
    
    func recievedProductList(notification: NSNotification) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.genieResponse = []
            
            if let userInfo : Dictionary<String,GenieResponse> = notification.userInfo as? Dictionary<String,GenieResponse> {
                for response in userInfo.values {
                    self.genieResponse.append(response)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func failedToFetchProductList(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Could not fetch products")
        }
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
}
