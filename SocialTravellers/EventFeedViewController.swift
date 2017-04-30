//
//  EventFeedViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 4/27/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Parse
import CoreLocation

class EventFeedViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var eventFeedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eventFeedTableView.delegate = self
        eventFeedTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveEventsAroundMe()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("loggedout")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:  User.userDidLogoutNotification), object: nil)
    }
    @IBAction func onUserButton(_ sender: Any) {
        performSegue(withIdentifier: "EventFeedToUserProfile", sender: self)
    }
    
    //Method to retrieve events from Parse backend
    func retrieveEventsAroundMe() {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        
        let userGeoPoint: PFGeoPoint = PFGeoPoint(latitude:(location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!)
        // Create a query for places
        let query = PFQuery(className:"Event")
        // Interested in locations near user.
        query.whereKey("location", nearGeoPoint:userGeoPoint)
        // Limit what could be a lot of points.
        query.limit = 20
        
        do {
            let eventsAroundMe = try query.findObjects()
            
            print("Events Around me : ",eventsAroundMe.count)
        } catch {
            print(error)
        }
        
    }
    

}

extension EventFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EventFeedToDetails", sender: self)
    }
}
