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
    
    // MARK: - Properties
    var objectId: String?
    var location: CLLocation?
    var name: String?
    var users: [User]?
    var startTime: Date?
    var endTime: Date?
    var tagline: String?
    
    init(event: PFObject) {
        self.objectId = event["objectId"] as? String
        if let location = event["location"] as? (CLLocationDegrees, CLLocationDegrees) {
            let lat = location.0
            let long = location.1
            self.location = CLLocation(latitude: lat, longitude: long)
        }
        if let name = event["name"] as? String {
            self.name = name
        }
        if let users = event["users"] as? [[String : AnyObject]] {
            for userDictionary in users {
                let user = User(parseDictionary: userDictionary)
                self.users?.append(user)
            }
        }
        if let start = event["startTime"] as? Date {
            self.startTime = start
        }
        if let end = event["endTime"] as? Date {
            self.endTime = end
        }
        if let tag = event["tagline"] as? String {
            self.tagline = tag
        }
    }
    
}
