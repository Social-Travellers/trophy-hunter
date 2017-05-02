//
//  EventCreateViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 4/27/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class EventCreateViewController: UIViewController {
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Intuit building 20 -> 37.429171, -122.097773
        let defaultLatitude: CLLocationDegrees = 37.429171
        let defaultLongitude: CLLocationDegrees = -122.097773
        let defaultLocation = CLLocation(latitude: defaultLatitude, longitude: defaultLongitude)
        userLocation = defaultLocation
        
        startStandardUpdates()
        
        if let location = userLocation {
            setMapLocation(location: location)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEventClicked(_ sender: UIButton) {
        print("create event tapped")
        guard let location = userLocation else {
            print("Could not get user location")
            return
        }
        
        let lat = location.coordinate.latitude as Double
        let long = location.coordinate.longitude as Double
        
        // Create event
        let event = PFObject(className:"Event")
        event["name"] = eventNameTextField.text
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        event["location"] = geoPoint
        event["tagline"] = eventDescriptionTextField.text
        // Get current user
        if let user = User.currentUser {
            // Create an user
            let currentUser = PFObject(className: "AppUser")
            currentUser["firstName"] = user.firstName ?? NSNull()
            currentUser["lastName"] = user.lastName ?? NSNull()
            currentUser["email"] = user.email ?? NSNull()
           // currentUser["userName"] = user.userName ?? NSNull()
            currentUser["tagline"] = user.tagline ?? NSNull()
            currentUser["profilePicUrl"] = user.profilePicUrl ?? NSNull()
           // currentUser["phoneNumber"] = user.phoneNumber ?? NSNull()
            currentUser["facebookId"] = user.facebookId ?? NSNull()
            
            // Create a relation between event and the user creating the event
            event.add(currentUser, forKey: "users")
            // Create event and save user
            event.saveInBackground { [unowned self] (success: Bool, error: Error?) in
                if let error = error {
                    print("Error creating event: \(error.localizedDescription)")
                } else {
                    print("Event created")
                    currentUser.saveInBackground { (success: Bool, error: Error?) in
                        if let error = error {
                            print("Error saving user: \(error.localizedDescription)")
                        } else {
                            print("Current user assigned to event")
                            // Go back to event feed
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            
        }
    }
    
    func startStandardUpdates() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        userLocation = location
        print("Latitude: ", userLocation?.coordinate.latitude ?? 0.0)
        print("Longitude: ", userLocation?.coordinate.longitude ?? 0.0)
    }
    
    func setMapLocation(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
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

extension EventCreateViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        userLocation = location
        if let location = location {
            setMapLocation(location: location)
        }
    }
    
}
