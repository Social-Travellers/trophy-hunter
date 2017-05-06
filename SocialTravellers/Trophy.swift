//
//  Trophy.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import Parse

class Trophy: NSObject{
    
    var objectId: String?
    var name: String?
    var picture: PFFile? //adding a file as we dont want to save it elsewhere and fetch it by url
    var experiencePoints: NSNumber?
    
    init(trophy: PFObject) {
        self.objectId = trophy["objectId"] as? String
        self.name = trophy["name"] as? String
        
        self.picture = trophy["picture"] as? PFFile

        self.experiencePoints = trophy["experiencePoints"] as? NSNumber
    }
}
