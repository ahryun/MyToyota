//
//  MyAccountViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit
import Parse

class MyAccountViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var userIcon: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var circularProgress: KYCircularProgress!
    var user: PFUser!
    var progress: UInt8 = 0
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In function \(__FUNCTION__)")
        
        // Do any additional setup after loading the view.
        let myIconView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        myIconView.image = UIImage(named: "myIcon")
        self.userIcon.addSubview(myIconView)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 730)
        
        let query = PFUser.query()
        query.getObjectInBackgroundWithId("gmUoEDCUFX", block: {
            (object: AnyObject!, err: NSError!) -> Void in
            self.user = object as PFUser
            self.setupMileageDiagram()
            self.setupMileageBreakdown()
            self.setupRewardsSection()
            self.setTripTable()
        })
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupMileageDiagram() {
        
        println("In function \(__FUNCTION__)")
        
        let fullWidth = self.view.frame.width
        let userName = self.user["name"] as String
        let mileageView: UIView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: fullWidth, height: 270.0)))
        // Main Label
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 20.0, width: fullWidth, height: 20.0))
        mainLabel.text = "\(userName)'s Toyota Miles"
        mainLabel.textColor = gDarkColor
        mainLabel.textAlignment = NSTextAlignment.Center
        mainLabel.font = gSmallFont
        mileageView.addSubview(mainLabel)
        
        // Sub Label
        let subLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 40.0, width: fullWidth, height: 14.0))
        subLabel.text = "earn rewards for every mile"
        subLabel.textColor = gGrayColor
        subLabel.textAlignment = NSTextAlignment.Center
        subLabel.font = gTinyFont
        mileageView.addSubview(subLabel)
        
        self.circularProgress = KYCircularProgress(frame: CGRect(x: 30.0, y: 30.0, width: 260.0, height: 260.0))
        self.circularProgress.colors = [circularProgress.colorHex(0x3893ba).CGColor!, circularProgress.colorHex(0x9839b7).CGColor!]
        let center = (CGFloat(130.0), CGFloat(130.0))
        self.circularProgress.path = UIBezierPath(arcCenter: CGPointMake(center.0, center.1), radius: CGFloat(self.circularProgress.frame.size.width/3.0), startAngle: CGFloat(-M_PI * 0.5), endAngle: CGFloat(M_PI * 1.8), clockwise: false)
        self.circularProgress.lineWidth = 2.0
        
        let topLabel = UILabel(frame: CGRectMake(70.0, 120.0, 180.0, 30.0))
        topLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        topLabel.textAlignment = .Center
        topLabel.textColor = self.circularProgress.colorHex(0xaaaaaa)
        topLabel.backgroundColor = UIColor.clearColor()
        topLabel.text = "You've earned"
        mileageView.addSubview(topLabel)
        
        let textLabel = UILabel(frame: CGRectMake(70.0, 120.0, 180.0, 80.0))
        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        textLabel.textAlignment = .Center
        textLabel.textColor = self.circularProgress.colorHex(0x666666)
        textLabel.backgroundColor = UIColor.clearColor()
        mileageView.addSubview(textLabel)
        
        let bottomLabel = UILabel(frame: CGRectMake(70.0, 170.0, 180.0, 30.0))
        bottomLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        bottomLabel.textAlignment = .Center
        bottomLabel.textColor = self.circularProgress.colorHex(0xaaaaaa)
        bottomLabel.backgroundColor = UIColor.clearColor()
        bottomLabel.text = "Toyota Miles"
        mileageView.addSubview(bottomLabel)
        
        self.circularProgress.progressChangedBlock({ (progress: Double, circular: KYCircularProgress) in
            println("progress: \(progress)")
            var numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            let milePoints = self.user["milePoints"] as NSNumber
            textLabel.text = "\(numberFormatter.stringFromNumber(Int(progress * milePoints)))"
        })
        
        mileageView.addSubview(self.circularProgress)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
        self.scrollView.addSubview(mileageView)
    }
    
    func setupMileageBreakdown() {
        
        println("In function \(__FUNCTION__)")
        
        let fullWidth = self.view.frame.width
        var breakDownView = UIImageView(frame: CGRect(x: 0, y: 270.0, width: fullWidth, height: 80.0))
        breakDownView.image = UIImage(named: "goalBreakDown")
        
        self.scrollView.addSubview(breakDownView)
    }
    
    func setupRewardsSection() {
        
        println("In function \(__FUNCTION__)")
        
        let widthWithMargin = (self.scrollView.frame.width - (25.0 * 2))
        var rewardView = UIImageView(frame: CGRect(x: 25.0, y: 350.0, width: widthWithMargin, height: 200.0))
        rewardView.userInteractionEnabled = true
        // Main Label
        let mainLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 20.0, width: widthWithMargin, height: 20.0))
        mainLabel.text = "REWARDS"
        mainLabel.textColor = gDarkColor
        mainLabel.textAlignment = NSTextAlignment.Center
        mainLabel.font = gSmallFont
        rewardView.addSubview(mainLabel)
        
        rewardView.addSubview(self.createEachReward(image: UIImage(named: "reward"), miles: 4000, width: (widthWithMargin / 3), xPosition: 0, disabled: false))
        rewardView.addSubview(self.createEachReward(image: UIImage(named: "reward1"), miles: 8000, width: (widthWithMargin / 3), xPosition: (widthWithMargin / 3), disabled: true))
        rewardView.addSubview(self.createEachReward(image: UIImage(named: "reward2"), miles: 12000, width: (widthWithMargin / 3), xPosition: (widthWithMargin / 3) * 2, disabled: true))
        
        self.scrollView.addSubview(rewardView)
    }
    
    func createEachReward(#image: UIImage, miles: Int, width: CGFloat, xPosition: CGFloat, disabled: Bool) -> UIView {
        
        println("In function \(__FUNCTION__)")
        
        let containerView = UIView(frame: CGRect(x: xPosition, y: 40.0, width: width, height: 160.0))
        containerView.userInteractionEnabled = true
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        let mileageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30.0))
        mileageLabel.text = "\(numberFormatter.stringFromNumber(miles)) miles"
        mileageLabel.textColor = gGrayColor
        mileageLabel.textAlignment = NSTextAlignment.Center
        mileageLabel.font = gTinyFont
        containerView.addSubview(mileageLabel)
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 40, width: 60, height: 60))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.maskInCircle()
        containerView.addSubview(imageView)
        
        let redeemButton = UIButton(frame: CGRect(x: 5, y: 120, width: 80, height: 30))
        redeemButton.titleLabel?.font = gSmallFont
        redeemButton.backgroundColor = gYellowColor
        redeemButton.setTitle("Redeem", forState: .Normal)
        redeemButton.userInteractionEnabled = true
        redeemButton.addTarget(self, action: "goToRedeemPage:", forControlEvents: UIControlEvents.TouchUpInside)
        if disabled {
            redeemButton.enabled = false
            imageView.alpha = 0.5
            redeemButton.alpha = 0.5
        }
        containerView.addSubview(redeemButton)
        
        return containerView
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        println("In function \(__FUNCTION__)")
//        
//        return true
//    }
    
    func setTripTable() {
        
        println("In function \(__FUNCTION__)")
        
        let fullWidth = self.view.frame.width
        var breakDownView = UIImageView(frame: CGRect(x: 0, y: 550.0, width: fullWidth, height: 180.0))
        breakDownView.image = UIImage(named: "tripTable")
        
        self.scrollView.addSubview(breakDownView)
    }

    func updateProgress() {
        
        println("In function \(__FUNCTION__)")
        
        self.progress = self.progress &+ 1
        let normalizedProgress = Double(self.progress) / 255.0
        self.circularProgress.progress = normalizedProgress
        if normalizedProgress >= 1.0 {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func goToRedeemPage(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.performSegueWithIdentifier("Reward Page", sender: self)
    }

}
