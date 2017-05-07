//
//  ARItem.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

struct ARItem {
    let itemDescription: String
    let location: CLLocation
    var itemNode: SCNNode?
}
