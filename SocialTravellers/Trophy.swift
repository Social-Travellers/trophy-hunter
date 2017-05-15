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
    
    lazy var experiencePointsString: String = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let expPoints = self.experiencePoints{
            return formatter.string(from: expPoints)!
        }
        return "0"
    }()
    
    init(trophy: PFObject) {
//        guard let id = trophy.objectId else{ return nil}
        self.objectId = trophy.objectId
        
        self.name = trophy["name"] as? String
        
        self.picture = trophy["picture"] as? PFFile

        self.experiencePoints = trophy["experiencePoints"] as? NSNumber
        
        self.itemDescription = trophy["itemDescription"] as? String
    }
}
