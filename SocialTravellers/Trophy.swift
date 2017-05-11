//
//  Trophy.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import Parse
import SceneKit

class Trophy: NSObject{
    
    var objectId: String?
    var name: String?
    var picture: PFFile? //adding a file as we dont want to save it elsewhere and fetch it by url
    var experiencePoints: NSNumber?
    var itemDescription: String?
    var itemNode: SCNNode?
    
    init?(trophy: PFObject) {
        guard let id = trophy.objectId as? String else{ return nil}
        self.objectId = id
        
        self.name = trophy["name"] as? String
        
        self.picture = trophy["picture"] as? PFFile

        self.experiencePoints = trophy["experiencePoints"] as? NSNumber
        
        self.itemDescription = trophy["itemDescription"] as? String
    }
}
