//
//  PriceViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController {

    enum Price: Int {
        case FiveHundred = 1, OneThousand, TwoThousand, TwoThousandUp
    }
    
    var genieRequest: GenieRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Price Range"
        
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        
        button.setImage(UIImage(named: "back_btn"), forState: UIControlState.Normal)
        button.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_3"), forState: UIControlState.Normal)
        
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
        case Price.FiveHundred.rawValue:
            self.genieRequest?.setPrice(500)
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.OneThousand.rawValue:
             self.genieRequest?.setPrice(1000)
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.TwoThousand.rawValue:
             self.genieRequest?.setPrice(2000)
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        case Price.TwoThousandUp.rawValue:
             self.genieRequest?.setPrice(5000)
            self.performSegueWithIdentifier("advanced_segue", sender: sender)
        default:
            println("Error occured with button tag")
        }
    }
    
    func setGenieRequest(genieRequest: GenieRequest?) {
        self.genieRequest = genieRequest
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "advanced_segue") {
            let destinationViewController = segue.destinationViewController as AdvancedViewController
            destinationViewController.setGenieRequest(self.genieRequest)
        }
    }
}
