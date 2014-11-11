//
//  RewardViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

class RewardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func redeemRewardButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        let alert = UIAlertView()
        alert.title = "Congrats!"
        alert.message = "You just redeemed a free oil change"
        alert.cancelButtonIndex = 0
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}
