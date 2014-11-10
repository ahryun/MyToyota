//
//  MapViewController.swift
//  MyToyota
//
//  Created by Jasper Sone on 11/8/14.
//  Copyright (c) 2014 Papafish. All rights reserved.
//

import UIKit
import Parse
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeButton: UIButton!
    
    var mappedCar: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In function \(__FUNCTION__)")

        // Do any additional setup after loading the view.
        var model = self.mappedCar["model"] as String
        var year = self.mappedCar["year"] as String
        self.navBarItem.title = "\(model) \(year)".uppercaseString
        
        self.setUpMapPin()
    }

    @IBAction func exitButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func routeButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__)")
        
        if let mapPreference = NSUserDefaults.standardUserDefaults().objectForKey("mapPreference") as? String {
            let location: PFGeoPoint = self.mappedCar["location"] as PFGeoPoint
            if mapPreference == gMapPreference.googleMap.toRaw() {
                // Open in Google Map
                openGoogleMap(lat: location.latitude, location.longitude)
            } else if mapPreference == gMapPreference.appleMap.toRaw() {
                // Open in Apple Map
                openAppleMap(lat: location.latitude, location.longitude)
            } else {
                self.showMapPreferenceActionSheet()
            }
        } else {
            self.showMapPreferenceActionSheet()
        }
    }
    
    func showMapPreferenceActionSheet() {
        
        println("In function \(__FUNCTION__)")
        
        var actionSheet = UIActionSheet()
        actionSheet.title = "Which map do you prefer?"
        actionSheet.delegate = self
        if UIApplication.sharedApplication().canOpenURL(NSURL.URLWithString(gMapPreference.googleMapURL.toRaw())) {
            actionSheet.addButtonWithTitle(gMapPreference.googleMap.toRaw())
        }
        actionSheet.addButtonWithTitle(gMapPreference.appleMap.toRaw())
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1
        actionSheet.showFromRect(self.routeButton.superview!.frame, inView: self.view, animated: true)
    }
    
    func setUpMapPin() {
        
        println("In function \(__FUNCTION__)")
        
        let location: PFGeoPoint = self.mappedCar["location"] as PFGeoPoint
        let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let pulsingAnnotation = PulsingMapPin(coordinate: coordinates, title: "")
        let annotation = MapPin(coordinate: coordinates, title: "I'm here")
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(pulsingAnnotation)
        self.mapView.addAnnotation(annotation)
        
        let annotationPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate);
        let pointRect: MKMapRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 0.1, height: 0.1))
        weak var weakSelf = self
        self.mapView.delegate = weakSelf
        self.mapView.setVisibleMapRect(pointRect, animated: false)
    }
    
    /************************/
    /* MAP DELEGATE         */
    /************************/
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        println("In function \(__FUNCTION__)")
        
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        let anAnnotation: MapPin = annotation as MapPin
        if let annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("mapPinID") {
            annotationView.annotation = anAnnotation
            return annotationView
        } else {
            return anAnnotation.createAnnotationView()
        }
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        
        println("In function \(__FUNCTION__)")
        
        for annotatonView : AnyObject in views {
            if let anAnnotationView = annotatonView as? MKAnnotationView {
                if anAnnotationView.tag == 0 {
                    anAnnotationView.superview!.bringSubviewToFront(anAnnotationView)
                } else if anAnnotationView.tag == 1 {
                    anAnnotationView.superview!.sendSubviewToBack(anAnnotationView)
                }
            }
        }
    }
}

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        
        println("In function \(__FUNCTION__)")
        
        self.coordinate = coordinate
        self.title = title
    }
    
    func createAnnotationView() -> MKAnnotationView {
        
        println("In function \(__FUNCTION__)")
        
        let anAnnotationView: MKAnnotationView = MKAnnotationView(annotation: self, reuseIdentifier: "mapPinID")
        anAnnotationView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 60.0, height: 60.0))
        let imageView = UIImageView(frame: anAnnotationView.bounds)
        imageView.image = UIImage(named: "greenCircle")
        anAnnotationView.addSubview(imageView)
        anAnnotationView.tag = 0
        
        return anAnnotationView
    }
}

extension MapViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        println("In function \(__FUNCTION__)")
        
        let location: PFGeoPoint = self.mappedCar["location"] as PFGeoPoint
        
        if actionSheet.buttonTitleAtIndex(buttonIndex) == gMapPreference.googleMap.toRaw() {
            // Open in Google Map
            openGoogleMap(lat: location.latitude, location.longitude)
        } else if actionSheet.buttonTitleAtIndex(buttonIndex) == gMapPreference.appleMap.toRaw() {
            // Open in Apple Map
            openAppleMap(lat: location.latitude, location.longitude)
        } else {
            actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        }
    }
}

class PulsingMapPin : MapPin {
    override init(coordinate: CLLocationCoordinate2D, title: String) {
        
        println("In function \(__FUNCTION__)")
        
        super.init(coordinate: coordinate, title: title)
    }
    
    override func createAnnotationView() -> MKAnnotationView {
        
        println("In function \(__FUNCTION__)")
        
        let anAnnotationView: MKAnnotationView = MKAnnotationView(annotation: self, reuseIdentifier: "mapPinID")
        anAnnotationView.image = UIImage(named: "greenCircle")
        anAnnotationView.tag = 1
        anAnnotationView.pulse()
        
        return anAnnotationView
    }
}