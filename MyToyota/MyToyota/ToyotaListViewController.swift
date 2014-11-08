//
//  ToyotaListViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/7/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

class ToyotaListViewController: UIViewController {

    @IBOutlet weak var userIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myIconView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        myIconView.image = UIImage(named: "myIcon")
        self.userIcon.addSubview(myIconView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
