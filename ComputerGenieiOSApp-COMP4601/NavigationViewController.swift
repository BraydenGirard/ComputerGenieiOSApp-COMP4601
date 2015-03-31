//
//  NavigationViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Brayden Girard on 2015-03-29.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class NavigationViewController: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: TableViewController(), menuPosition:.Left)
        
        //sideMenu?.menuWidth = 180.0
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
