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
        
        super.init()
        
        self.objectId = event.objectId
        self.name = event["name"] as? String
        
        if let location = event["location"] as? PFGeoPoint {
            let lat = location.latitude
            let long = location.longitude
            self.location = CLLocation(latitude: lat, longitude: long)
        }
        
        self.level = event["level"] as? NSNumber
        self.picture = event["picture"] as? PFFile
        
        if let users = event["completedBy"] as? [[String : AnyObject]] {
            for _ in users {
            }
        }
        
        let relation = event.relation(forKey: "trophy")
        self.getTrophy(query: relation.query())
        
    }
    
    func getTrophy(query: PFQuery<PFObject>){
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let trophyObj = objects?.first {
                    let trophy = Trophy(trophy: trophyObj)
                    self.trophy = trophy
                }
            }
        }
    }
}
