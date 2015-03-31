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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Advanced Specs"
        screenLabel.text = "Unspecified"
        memoryLabel.text = "Unspecified"
        hddLabel.text = "Unspecified"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        genieRequest?.print()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func geniePushed(sender: UIButton) {
        self.genieRequest?.print()
        self.performSegueWithIdentifier("genie_segue", sender: sender)
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
        if ssdSwitch.state == UIControlState.Selected{
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
            //Do genie magic here
        }
    }
    
}
