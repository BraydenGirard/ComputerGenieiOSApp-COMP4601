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
        
        self.title = "Genie's Recommendation"
        self.navigationItem.hidesBackButton = true;
        
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 50, 36)
        button.setTitle("Done", forState: UIControlState.Normal)
        button.addTarget(self, action: "donePushed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        switch (indexPath.row) {
        case 0:
            cell?.textLabel?.text = "Home"
            break
        case 1:
            cell?.textLabel?.text = "Profile"
            break
        case 2:
            cell?.textLabel?.text = "Find Product"
            break
        case 3:
            cell?.textLabel?.text = "Your Products"
            break
        case 4:
            cell?.textLabel?.text = "Settings"
            break
        default:
            cell?.textLabel?.text = "Home"
            break
        }
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
    }

}
