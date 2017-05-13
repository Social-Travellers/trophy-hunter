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


class TrophiesMapViewController: UIViewController, CameraViewControllerDelegate {
    @IBOutlet weak var trophiesMapView: MKMapView!
    @IBOutlet weak var showCameraSceneButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    var firstLoad = true
    var allEvents: [Event] = []
    var selectedEvent: Event?
    var selectedAnnotationView: MKPinAnnotationView?
    
    var tappedTrophy: Trophy!
    
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
  /*
    @IBAction func logoutClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("loggedout")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:  User.userDidLogoutNotification), object: nil)
    } */
    
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
    
    // MARK: - CameraVC delegate
    
    func trophyTappedOnCameraViewController(viewController controller: CameraViewController, tappedTrophy trophy: Trophy) {
        print("Protocol delegate notified")
        print("Trophy has been tapped")

        tappedTrophy = trophy
        
        // Dismiss cameraVC and present trophyUnlockedVC
        dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "TrophyUnlockedView") as? TrophyUnlockedViewController {
            vc.trophy = tappedTrophy
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Notification observers
    
    func trophyUnlocked() {
        print("Notification received")
        print("Trophy has been unlocked")
        selectedAnnotationView!.pinTintColor = UIColor.yellow
        dismiss(animated: true) { 
            let alertController = UIAlertController(title: "Trophy Unlocked", message: "You unlocked a trophy. Go get them all!", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
                annotationView = MKPinAnnotationView(annotation: mapAnnotation, reuseIdentifier: pinIdentifier)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let tappedAnnotation = view.annotation as? MapAnnotation {
            self.selectedAnnotationView = (view as! MKPinAnnotationView)
            let selectedEvent = tappedAnnotation.item
            self.selectedEvent = selectedEvent
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
                if let event = self.selectedEvent {
                    viewController.delegate = self
                    viewController.selectedEvent = event
                    print("Location: \(String(describing: event.location))")
                    print("Description: \(String(describing: event.trophy?.itemDescription))")
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
