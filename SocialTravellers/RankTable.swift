//
//  RankTable.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/8/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation

class RankTable: NSObject {

    func lookUpRank(experiencePoints: NSNumber) -> String {
        let expAsInt = Int(experiencePoints)
        
        if expAsInt != nil{
            switch expAsInt {
            case 0..<50:
                return "Noob"
            case 50..<150:
                return "Grown-up"
            case 150..<1000:
                return "Warrior"
            case 1000..<5000:
                return "Knight"
            case 5000..<Int.max:
                return "Royalty"
            default:
                return "Noob"
            }
        }
        return "Noob"
    }
}
