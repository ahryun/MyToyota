//
//  ToyotaListViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/7/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit
import Parse

class ToyotaListViewController: UIViewController {

    @IBOutlet weak var userIcon: UIButton!
    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var carArray = [PFObject]()
    var selectedCar: PFObject!
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In function \(__FUNCTION__)")
        
        // Do any additional setup after loading the view.
        self.navItem.titleView = UIImageView(image: UIImage(named: "title"))
        
        let myIconView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        myIconView.image = UIImage(named: "myIcon")
        self.userIcon.addSubview(myIconView)
        
        self.getAllCars()
    }

    /************************/
    /* HELPER METHOD        */
    /************************/
    func getAllCars() {
        
        println("In function \(__FUNCTION__)")
        
        var userQuery = PFUser.query()
        userQuery.getObjectInBackgroundWithId("gmUoEDCUFX", block: {
            (object: AnyObject!, err: NSError!) -> Void in
            if err == nil {
                self.user = object as PFUser
                var query = PFQuery(className: "Car")
                query.whereKey("owner", equalTo: object as PFUser)
                query.findObjectsInBackgroundWithBlock {
                    (cars: [AnyObject]!, err: NSError!) -> Void in
                    if (err == nil) {
                        self.carArray = cars as [PFObject]
                        self.carsTableView.reloadData()
                    }
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__)")
        
        if segue.identifier == "ShowMap" {
            var destController: MapViewController = segue.destinationViewController as MapViewController
            destController.getCar(vid: self.selectedCar["vid"] as String)
        }
    }
}

extension ToyotaListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        println("In function \(__FUNCTION__)")
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("In function \(__FUNCTION__)")
        
        return self.carArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        // includes 1px separator
        return 380.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("In function \(__FUNCTION__)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MyCar", forIndexPath: indexPath) as MyCarTableViewCell
        let car: PFObject = self.carArray[indexPath.row]
        if let model = car["model"] as? String {
            cell.carNameLabel.text = model.uppercaseString
        }
        if let totalMile = car["currentMiles"] as? Int {
            var numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            cell.carTotalMileLabel.text = "\(numberFormatter.stringFromNumber(totalMile)) miles"
        }
        if let carImage: PFFile = car["photo"] as? PFFile {
            cell.carImageView.file = carImage
            cell.carImageView.loadInBackground(nil)
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension ToyotaListViewController: CarsTableViewCellDelegate {
    func routeToLocation(#sender: MyCarTableViewCell!) {
        
        println("In function \(__FUNCTION__)")
        
        if let row = self.carsTableView.indexPathForCell(sender)?.row {
            self.selectedCar = self.carArray[row]
            // Open up the map view with that pin
            self.performSegueWithIdentifier("ShowMap", sender: self)
        }
    }
}




