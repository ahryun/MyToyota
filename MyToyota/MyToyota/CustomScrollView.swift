//
//  CustomScrollView.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        
        println("In function \(__FUNCTION__)")
        
        return view.isKindOfClass(UIButton.self)
    }
}
