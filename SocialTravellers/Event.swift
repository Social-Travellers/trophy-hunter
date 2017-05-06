//
//  Event.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/26/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

class Event: NSObject {
    
    var objectId: String?
    var name: String?
    var location: CLLocation?
    var level: NSNumber?
    var picture: PFFile?
    var completedBy: [User]?
    var trophy: Trophy? // Made this a relation in parse change it to an object if it is easier
    
    init(event: PFObject) {
        //Dummy Initializers, please update them according to use case
        self.objectId = event["objectId"] as? String
        self.name = event["name"] as? String
        
        if let location = event["location"] as? (CLLocationDegrees, CLLocationDegrees) {
            let lat = location.0
            let long = location.1
            self.location = CLLocation(latitude: lat, longitude: long)
        }
        
        self.level = event["level"] as? NSNumber
        self.picture = event["picture"] as? PFFile
        
        if let users = event["completedBy"] as? [[String : AnyObject]] {
            for userDictionary in users {
                let user = User(parseDictionary: userDictionary)
                self.completedBy?.append(user)
            }
        }
        
        if let trophyObj = event["trophy"] as? PFObject {
            let trophy = Trophy(trophy: trophyObj)
            self.trophy = trophy
        }
        
    }    
}
