//
//  GenieViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class GenieViewController: UITableViewController{
    
    var genieResponse: [GenieResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setGenieResponse(genieResponse: [GenieResponse]?) {
        self.genieResponse = genieResponse
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ImageCell") as? ImageCell
        var response = genieResponse![indexPath.row]
        
        cell?.textLabel?.text = response.getName()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
    }

}
