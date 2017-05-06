//
//  Event1.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import Parse

class Event1: NSObject{
    
    var objectId: String?
    var location: CLLocation?
    var level: NSNumber?
    var picture: PFFile?
    var completedBy: [User]?
    var trophy: Trophy? // Made this a relation in parse change it to an object if it is easier

    init(event1: PFObject) {
        //Dummy Initializers, please update them according to use case
        self.objectId = event1["objectId"] as? String
        
        if let location = event1["location"] as? (CLLocationDegrees, CLLocationDegrees) {
            let lat = location.0
            let long = location.1
            self.location = CLLocation(latitude: lat, longitude: long)
        }

        self.level = event1["level"] as? NSNumber
        self.picture = event1["picture"] as? PFFile
        
        if let users = event1["completedBy"] as? [[String : AnyObject]] {
            for userDictionary in users {
                let user = User(parseDictionary: userDictionary)
                self.completedBy?.append(user)
            }
        }
        
        if let trophyObj = event1["trophy"] as? PFObject {
            let trophy = Trophy(trophy: trophyObj)
            self.trophy = trophy
        }
        
    }
}
