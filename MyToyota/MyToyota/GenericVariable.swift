//
//  GenericVariable.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import Foundation
import UIKit

/* Colors */
let gDarkColor          = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
let gGrayColor          = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
let gRedColor           = UIColor(red: 249/255, green: 61/255, blue: 74/255, alpha: 1)
let gGreenColor         = UIColor(red: 31/255, green: 181/255, blue: 102/255, alpha: 1)
let gBlueColor          = UIColor(red: 13/255, green: 147/255, blue: 255/255, alpha: 1)
let gPurpleColor        = UIColor(red: 111/255, green: 63/255, blue: 119/255, alpha: 1)
let gYellowColor        = UIColor(red: 255/255, green: 197/255, blue: 37/255, alpha: 1)
let gLightYellowColor   = UIColor(red: 255/255, green: 251/255, blue: 245/255, alpha: 1)
let gLightRedColor      = UIColor(red: 252/255, green: 245/255, blue: 245/255, alpha: 1)
let gLightBlueColor     = UIColor(red: 249/255, green: 245/255, blue: 252/255, alpha: 1)
let gLightGreenColor    = UIColor(red: 245/255, green: 252/255, blue: 245/255, alpha: 1)
let gLightGrayColor     = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
let gLightPurpleColor   = UIColor(red: 252/255, green: 243/255, blue: 255/255, alpha: 1)

/* Fonts */
let gLargeFont  = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
let gMediumFont = UIFont(name: "HelveticaNeue-Thin", size: 24.0)
let gSmallFont = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
let gSmallRegularFont = UIFont(name: "HelveticaNeue", size: 17.0)
let gSmallBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
let gTinyFont = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
let gTinyBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 12.0)

enum gMapPreference: String {
    case googleMapURL               = "comgooglemaps://"
    case googleMap                  = "Open in Google Map"
    case appleMap                   = "Open in Apple Map"
}