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

<<<<<<< HEAD

=======
>>>>>>> 13df61d5a446c427c76df6d63b92bc89ac9f7bef
class EventCreateViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var eventNameTextView: UITextView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEventClicked(_ sender: UIButton) {
        print("create event tapped")
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        print("Latitude: ",location?.coordinate.latitude)
        print("Longitude: ",location?.coordinate.longitude)
        
        let event = PFObject(className:"Event")
        event["name"] = eventNameTextView.text
        let geoPoint = PFGeoPoint(latitude:(location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!)
        event["location"] = geoPoint
        event["tagline"] = eventDescriptionTextView.text
        
        event.saveInBackground { (succeeded: Bool, error: Error?) in
            if (succeeded) {
                print("Event Saved")
            } else {
                print("Error Saving event ",error.debugDescription)
            }
        }
<<<<<<< HEAD

        navigationController?.popViewController(animated: true)
    }
    

=======
        navigationController?.popViewController(animated: true)
    }
    
>>>>>>> 13df61d5a446c427c76df6d63b92bc89ac9f7bef
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
