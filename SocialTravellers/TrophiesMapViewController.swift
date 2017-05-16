//
//  TrophiesMapViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse
import FacebookLogin
import InteractiveSideMenu
import ChameleonFramework
import RKDropdownAlert


class TrophiesMapViewController: MenuItemContentViewController {
    @IBOutlet weak var trophiesMapView: MKMapView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    var firstLoad = true
    var allEvents: [Event] = []
    var selectedEvent: Event?
    var selectedAnnotationView: MKAnnotationView?
    
    var tappedTrophy: Trophy!
    var trophyImage:UIImage = #imageLiteral(resourceName: "TealPin")
    var unlockedTrophyImage:UIImage = #imageLiteral(resourceName: "GrayPin")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trophiesMapView.delegate = self
        trophiesMapView.showsUserLocation = true
        
        startStandardUpdates()
        
        if let lastLocation = locationManager.location {
            userLocation = lastLocation
        } else {
            userLocation = CLLocation(latitude: 37.340790, longitude: -121.897886)
        }
        
        setMapViewRegion(forMapView: trophiesMapView, location: userLocation)
        
        trophiesMapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        retrieveAllTrophiesAround(location: userLocation)
        
        let trophyUnlockedName = NSNotification.Name(rawValue: "TrophyUnlocked")
        NotificationCenter.default.addObserver(self, selector: #selector(trophyUnlocked), name: trophyUnlockedName, object: nil)
    }
    
    @IBAction func onMenuButton(_ sender: Any) {
        showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !firstLoad {
            retrieveAllTrophiesAround(location: userLocation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MapView helper methods
    func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func setMapViewRegion(forMapView mapView: MKMapView, location: CLLocation) {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func addPinToMapView(forMapView mapView: MKMapView, location: CLLocation, event: Event) {
        let mapAnnotation = MapAnnotation(coordinate: location.coordinate, item: event)
        
        mapView.addAnnotation(mapAnnotation)
    }
    
    // MARK: - Backend helper methods
    func retrieveAllTrophiesAround(location: CLLocation) {
        let lat = location.coordinate.latitude as Double
        let long = location.coordinate.longitude as Double
        
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        // Create a query for places
        let query = PFQuery(className:"Event1")
        // Interested in locations near user.
        query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 50.0)
        // Limit what could be a lot of points.
        query.limit = 20
        
        do {
            query.findObjectsInBackground {
                (eventsAroundMe: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    var retrievedEvents: [Event] = []
                    for eventObj in eventsAroundMe! {
                        let event = Event(event: eventObj)
                        retrievedEvents.append(event)
                        if let location = event.location {
                            self.addPinToMapView(forMapView: self.trophiesMapView, location: location, event: event)
                            print("Pin added for event")
                        } else {
                            print("Could not add pin for event")
                        }
                    }
                    self.allEvents = retrievedEvents
                    print("Events around me: \(eventsAroundMe?.count ?? 0)")
                    self.firstLoad = false
                }
            }
        }
    }
    
    // MARK: - Notification observers
    
    func trophyUnlocked() {
        print("Notification received")
        print("Trophy has been unlocked")
        selectedAnnotationView?.image = unlockedTrophyImage
        dismiss(animated: true) {
            RKDropdownAlert.title("Trophy Unlocked", message: "You unlocked a trophy. Go get them all!", backgroundColor: Constants.Color.THEMECOLOR, textColor: FlatWhite(), time: 3)
        }
    }
    
    @IBAction func centerMapButtonTapped(_ sender: Any) {
        debugPrint("buttonTapped")
        trophiesMapView.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 0.002, 0.002)
    }
}

extension TrophiesMapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Location manager delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
    // MARK: - MapView delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let mapAnnotation = annotation as? MapAnnotation {
            let pinIdentifier = "Trophy"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: mapAnnotation, reuseIdentifier: pinIdentifier)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView?.image = trophyImage
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let tappedAnnotation = view.annotation as? MapAnnotation {
            self.selectedAnnotationView = view
            let selectedEvent = tappedAnnotation.item
            self.selectedEvent = selectedEvent
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
                if let event = self.selectedEvent {
                    viewController.selectedEvent = event
                    print("Location: \(String(describing: event.location))")
                    print("Description: \(String(describing: event.trophy?.itemDescription))")
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
