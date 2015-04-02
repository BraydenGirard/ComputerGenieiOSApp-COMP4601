//
//  AdvancedViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-30.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class AdvancedViewController: UIViewController {
    
    @IBOutlet var ssdSwitch: UISwitch!
    
    @IBOutlet var memoryLabel: UILabel!
    @IBOutlet var screenLabel: UILabel!
    @IBOutlet var hddLabel: UILabel!
    @IBOutlet var screenSlider: UISlider!
    @IBOutlet var memorySlider: UISlider!
    @IBOutlet var hddSlider: UISlider!
    
    var genieRequest: GenieRequest?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Advanced Specs"
        screenLabel.text = "Unspecified"
        memoryLabel.text = "Unspecified"
        hddLabel.text = "Unspecified"
        
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 25, 18)
        
        button.setImage(UIImage(named: "back_btn"), forState: UIControlState.Normal)
        button.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "completeGenie:", name: "GenieSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failGenie:", name: "GenieFail", object: nil)

        let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(0, 0, 25, 18)
        button2.setImage(UIImage(named: "lamp_4"), forState: UIControlState.Normal)
        
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
    
    func completeGenie(notification: NSNotification) {
        //Log the user in here and give them their token from the notification
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Genie request successful")
            self.activityIndicator.stopAnimating()
            self.performSegueWithIdentifier("genie_segue", sender: notification)
        }
        
    }
    
    func failGenie(notification:NSNotification) {
        //Show an error
        NSOperationQueue.mainQueue().addOperationWithBlock {
            println("Controller: Genie request failed")
            self.activityIndicator.stopAnimating()
        }
    }

    
    @IBAction func geniePushed(sender: UIButton) {
        self.genieRequest?.print()
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendGenieRequest(self.genieRequest!, user: UserDefaultsManager.sharedInstance.getUserData())
    }
    
    @IBAction func screenChanged(sender: UISlider) {
        let value = roundf(sender.value / 25.0) * 25;
        sender.setValue(value, animated: true)
        
        if value == 0 {
            self.genieRequest?.setScreen(0)
            screenLabel.text = "Unspecified"
        } else if value == 25.0 {
            self.genieRequest?.setScreen(13)
            screenLabel.text = "13\""
        } else if value == 50.0 {
            self.genieRequest?.setScreen(15)
            screenLabel.text = "15\""
        } else if value == 75.0 {
            self.genieRequest?.setScreen(18)
            screenLabel.text = "18\""
        } else if value == 100.0 {
            self.genieRequest?.setScreen(28)
            screenLabel.text = "20\"+"
        }
    }
    @IBAction func memoryChanged(sender: UISlider) {
        let value = roundf(sender.value / 4.0) * 4;
        sender.setValue(value, animated: true)
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
        let stringValue = nf.stringFromNumber(value)
        
        if value < 4.0 {
            self.genieRequest?.setMemory(0)
            memoryLabel.text = "Unspecified"
        } else {
            self.genieRequest?.setMemory(Int(value))
            let gb = " Gb"
            memoryLabel.text = stringValue! + gb
        }
    }
    @IBAction func hddChanged(sender: UISlider) {
        var value = roundf(sender.value / 500.0) * 500;
        sender.setValue(value, animated: true)
        
        let gb = " Gb"
        let tb = " Tb"
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
        if value < 500.0 {
            self.genieRequest?.setHDD(0)
            hddLabel.text = "Unspecified"
        }
        
        if value > 500.0 {
            self.genieRequest?.setHDD(Int(value))
            value = value / 1000.0
            var stringValue = nf.stringFromNumber(value)
            hddLabel.text = stringValue! + tb
        } else if (value == 500.0) {
            self.genieRequest?.setHDD(Int(value))
            let stringValue = nf.stringFromNumber(value)
            hddLabel.text = stringValue! + gb
        }
    }
    @IBAction func ssdChanged(sender: UISwitch) {
        if sender.on {
            self.genieRequest?.setSSD(true)
        } else {
            self.genieRequest?.setSSD(false)
        }
    }
    
    func setGenieRequest(genieRequest: GenieRequest?) {
        self.genieRequest = genieRequest
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "genie_segue") {
            let destinationViewController = segue.destinationViewController as GenieViewController
            let notification = sender as NSNotification
            let userInfo:Dictionary<String, [GenieResponse]> = notification.userInfo as Dictionary<String, [GenieResponse]>
            let genieResponse = userInfo["genieresponse"]
            destinationViewController.setGenieResponse(genieResponse)
        }
    }
    
}
