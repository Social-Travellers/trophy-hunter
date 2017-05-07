//
//  MapAnnotation.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    var item: Event
    
    init(coordinate: CLLocationCoordinate2D, item: Event) {
        self.coordinate = coordinate
        self.item = item
        self.title = item.name
        
        super.init()
    }

}
