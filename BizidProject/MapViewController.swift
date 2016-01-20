//
//  MapViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/20.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var coreLocationManager = CLLocationManager()
    var locationsArray = [MKPointAnnotation]()
    var friendList:[Contacts] = [Contacts]()
    var myLatitude: Double = 0
    var myLongitude: Double = 0
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        friendList = [Contacts]()
        friendList = Contacts.fetchAllContactsFromCoreData()
        
        if coreLocationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")) {
            requestAuthorization()
        }
    }
    
    
    
    // MARK: - Delegates
    
    // MKMapViewDelegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let adjustedRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 4000, 4000))
//        mapView.setRegion(adjustedRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnotationView")

        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        view.canShowCallout = true
        
        let rightCalloutAccessory = UIButton.buttonWithType(.InfoDark) as! UIButton
        rightCalloutAccessory.hidden = false
        view.rightCalloutAccessoryView = rightCalloutAccessory
        
        let thumbnialView = UIImageView(image: getPortrait(annotation.title!).circle)
        thumbnialView.frame = CGRect(x: super.view.frame.origin.x, y: super.view.frame.origin.y, width: 40, height: 40)
        view.leftCalloutAccessoryView = thumbnialView
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("annotation tapped")
        println((view.annotation as! MKPointAnnotation).contactInfo)
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        performSegueWithIdentifier(kToDetailView, sender: view)
    }
    
    
    // UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    
    
    // MARK: - Event Responses
    
    @IBAction func isUpdating(sender: UISwitch) {
        
        switch sender.on {
        case true:
            
            locationsArray = [MKPointAnnotation]()
            coreLocationManager.startUpdatingLocation()
            println("lat: \(mapView.userLocation.coordinate.latitude), lon:\(mapView.userLocation.coordinate.longitude)")
            coordinate = mapView.userLocation.coordinate
            
            let myLatitude = self.myLatitude
            let myLongitude = self.myLongitude
            
            ParseHelper.fetchContactsLocation(myLatitude, myLongitude: myLongitude, completion: setFriendPlacemarks)
            
            // Update my location in Parse's FriendList
            ParseHelper.updateMyLocation(myLatitude, longitude: myLongitude, completion: { (success, error) -> Void in
                if success == false && error != nil {
                    // Show Alert Message
                }
            })
        case false:
            
            coreLocationManager.stopUpdatingLocation()
            mapView.removeAnnotations(locationsArray)
        default:break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let annotation = sender?.annotation as? MKPointAnnotation {
            let contactInfo = annotation.contactInfo
            var destination = segue.destinationViewController as? UIViewController
            if let navigationController = destination as? UINavigationController {
                destination = navigationController.visibleViewController
            }
            
            if let detailVC = destination as? DetailViewController {
                if let identifier = segue.identifier {
                    switch identifier {
                    case kToDetailView:
                        let contactInfoClass = ContactInfo()
                        contactInfoClass.contactInfoDic = annotation.contactInfo
                        detailVC.contactInfoArray = contactInfoClass.contactInfoDicToArray()
                        let portraitImage = getPortrait(annotation.title!)
                        detailVC.portrait = portraitImage
                        detailVC.contactInfoHead = annotation.contactInfoHead
                    default:break
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Getter and Setter
    
    var coordinate: CLLocationCoordinate2D {
        get { return self.coordinate }
        set {
            self.myLatitude = newValue.latitude
            self.myLongitude = newValue.longitude
        }
    }
    
    
    
    // MARK: - Other Methods
    
    // Return right thumbnail image
    func getPortrait(annotationTitle:String) -> UIImage
    {
        var thumbnail = UIImage()
        
        for friend in friendList {
            if annotationTitle == friend.contactInfoHead["fullName"] {
                thumbnail = UIImage(data: friend.portrait)!
                break
            }
        }
        return thumbnail
    }
    
    
    // Initialize map view
    func setUpMap()
    {
        // Set delegates
        coreLocationManager.delegate = self
        mapView.delegate = self
        
        // Set location manager
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Set map view
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.Standard
    }
    
    
    // Location access authorization
    func requestAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        if status == .Denied {
            
            let message = "Location access needs to be 'Always' or 'While Using'."
            UIAlertView(title: "", message: message, delegate:self, cancelButtonTitle: "Cancel", otherButtonTitles: "Setting").show()
            
        } else {
            coreLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // Set annotations on map
    func setFriendPlacemarks(contactLocations:[ContactLocation]?)
    {
        if let contactLocations = contactLocations {
            locationsArray = [MKPointAnnotation]()
            for contactLocation in contactLocations {
                var annotation = MKPointAnnotation()
                let coordinate = contactLocation.location
                let contactInfoHead = contactLocation.contactInfoHead!
                let contactInfo = contactLocation.contactInfo!
                annotation.coordinate = coordinate!
                annotation.title = contactInfoHead["fullName"]
                annotation.subtitle = contactInfoHead["company"]
                annotation.contactInfo = contactInfo
                annotation.contactInfoHead = contactInfoHead
                locationsArray.append(annotation)
                mapView.addAnnotation(annotation)
            }
            mapView.showAnnotations(locationsArray, animated: true)
        } else {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "Couldn't get friends' locations.", animated: true, hide: true, delay: 1.5)
        }
        
    }
}







