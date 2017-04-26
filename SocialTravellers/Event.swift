//
//  Event.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/26/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import CoreLocation

class Event: NSObject {
    
    // MARK: - Properties
    var location: CLLocation?
    var name: String?
    var users: [User]?
    var startTime: Date?
    var endTime: Date?
    var tagline: String?
    
}
