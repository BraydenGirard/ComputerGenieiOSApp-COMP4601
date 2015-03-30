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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "Advanced Specifications"
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func geniePushed(sender: UIButton) {
        
    }
    
    @IBAction func screenChanged(sender: UISlider) {
        if sender.value == 0 {
            screenLabel.text = "Unspecified"
        } else if sender.value == 1 {
            screenLabel.text = "13\""
        } else if sender.value == 2 {
            screenLabel.text = "15\""
        } else if sender.value == 3 {
            screenLabel.text = "18\""
        } else if sender.value == 4 {
            screenLabel.text = "20\"+"
        }
    }
    @IBAction func memoryChanged(sender: UISlider) {
        let value = roundf(sender.value / 4.0) * 4;
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
        let stringValue = nf.stringFromNumber(value)
        
        if value < 4.0 {
            memoryLabel.text = "Unspecified"
        } else {
            memoryLabel.text = stringValue
        }
    }
    @IBAction func hddChanged(sender: UISlider) {
        var value = roundf(sender.value / 500.0) * 500;
        
        if value > 500.0 {
            value = value / 1000.0
        }
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
       
        let stringValue = nf.stringFromNumber(value)
        
        if value < 500.0 {
            hddLabel.text = "Unspecified"
        } else {
            hddLabel.text = stringValue
        }
    }
    @IBAction func ssdChanged(sender: UISwitch) {
        if ssdSwitch.state == UIControlState.Selected{
            println("Switch state selected")
        } else {
            
        }
    }
    
}
