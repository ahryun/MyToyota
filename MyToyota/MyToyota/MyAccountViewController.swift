//
//  MyAccountViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var userIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In function \(__FUNCTION__)")
        
        // Do any additional setup after loading the view.
        let myIconView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        myIconView.image = UIImage(named: "myIcon")
        self.userIcon.addSubview(myIconView)
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
