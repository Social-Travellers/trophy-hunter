//
//  User.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/26/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation

class User: NSObject {
    
    // MARK: - Properties
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var userName: String?  // is this still needed?
    var profilePicUrl: String?
    var phoneNumber: String?
    var tagline: String?
    var events: [Event]?
}
