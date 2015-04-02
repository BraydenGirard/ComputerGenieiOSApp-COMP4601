//
//  UseViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class UseViewController: UIViewController {
    enum Use: Int {
        case School = 1, Gaming, Work, Leisure
    }
    
    var genieRequest: GenieRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Computer Use"
        
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        
        button.setImage(UIImage(named: "back_btn"), forState: UIControlState.Normal)
        button.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_2"), forState: UIControlState.Normal)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItem = barButton2
    }
    
    override func viewDidAppear(animated: Bool) {
        genieRequest?.print()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func buttonPushed(sender: UIButton) {
        switch sender.tag {
        case Use.School.rawValue:
            self.genieRequest?.setUse("School")
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Gaming.rawValue:
            self.genieRequest?.setUse("Gaming")
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Work.rawValue:
            self.genieRequest?.setUse("Work")
            self.performSegueWithIdentifier("price_segue", sender: sender)
        case Use.Leisure.rawValue:
            self.genieRequest?.setUse("Leisure")
            self.performSegueWithIdentifier("price_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
    
    func setGenieRequest(genieRequest: GenieRequest?) {
        self.genieRequest = genieRequest
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "price_segue") {
            let destinationViewController = segue.destinationViewController as PriceViewController
            destinationViewController.setGenieRequest(self.genieRequest)
        }
    }
}
