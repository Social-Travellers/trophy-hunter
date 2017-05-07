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


class TrophiesMapViewController: UIViewController {
    @IBOutlet weak var trophiesMapView: MKMapView!
    @IBOutlet weak var showCameraSceneButton: UIButton!

    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    var firstLoad = true
    var allEvents: [Event] = []
    
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
        
        retrieveAllTrophiesAround(location: userLocation)
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
    
    @IBAction func showCameraSceneClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "trophiesToCameraSegue", sender: nil)
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("loggedout")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:  User.userDidLogoutNotification), object: nil)
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
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location.coordinate
        if let name = event.name {
            pointAnnotation.title = name
        }
        mapView.addAnnotation(pointAnnotation)
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
            let eventsAroundMe = try query.findObjects()
            var retrievedEvents: [Event] = []
            for eventObj in eventsAroundMe {
                let event = Event(event: eventObj)
                retrievedEvents.append(event)
                addPinToMapView(forMapView: trophiesMapView, location: event.location!, event: event)
                print("Pin added for event")
            }
            allEvents = retrievedEvents
            print("Events around me: \(eventsAroundMe.count)")
            firstLoad = false
        } catch {
            print("Error: \(error.localizedDescription)")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
}
