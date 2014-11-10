//
//  GenericFunctions.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/************************/
/* MAP                  */
/************************/
func openGoogleMap(#lat: Double, lng: Double) {
    
    println("In function \(__FUNCTION__)")
    
    let mapString: String = "comgooglemaps://?daddr=\(lat),\(lng)&zoom=14&views=traffic&directionsmode=driving"
    UIApplication.sharedApplication().openURL(NSURL.URLWithString(mapString))
}

func openAppleMap(#lat: Double, lng: Double) {
    
    println("In function \(__FUNCTION__)")
    
    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    let placemark: MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
    let mapItem: MKMapItem = MKMapItem(placemark: placemark)
    let launchOptions: Dictionary = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    MKMapItem.openMapsWithItems([mapItem], launchOptions: launchOptions)
}