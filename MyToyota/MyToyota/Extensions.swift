//
//  Extensions.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import Foundation
import QuartzCore
import CoreImage
import UIKit

extension UIView {
    func pulse() {
        self.layer.removeAnimationForKey("pulsingAnimation")
        var pulsingAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsingAnimation.fromValue = NSNumber(float: 1.0)
        pulsingAnimation.toValue = NSNumber(float: 2.0)
        
        var alphaAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = NSNumber(float: 0.5)
        alphaAnimation.toValue = NSNumber(float: 0.0)
        
        var group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 2.0
        group.repeatCount = Float.infinity
        group.removedOnCompletion = false
        group.animations = [pulsingAnimation, alphaAnimation]
        
        self.layer.addAnimation(group, forKey: "pulsingAnimation")
    }
}

extension UIImageView {
    func maskInCircle() {
        let circle: UIBezierPath = UIBezierPath(ovalInRect: self.bounds)
        var shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = circle.CGPath
        shapeLayer.frame = self.bounds;
        self.layer.mask = shapeLayer;
    }
}