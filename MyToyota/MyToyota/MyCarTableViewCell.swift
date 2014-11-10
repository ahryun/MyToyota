//
//  MyCarTableViewCell.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit
import ParseUI

class MyCarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImageView: PFImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carTotalMileLabel: UILabel!
    @IBOutlet weak var findMyToyotaButton: UIButton!
    weak var delegate: CarsTableViewCellDelegate?
    
    @IBAction func findMyToyotaButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.delegate?.routeToLocation(sender: self)
    }
}

@objc protocol CarsTableViewCellDelegate {
    func routeToLocation(#sender: MyCarTableViewCell!)
}
