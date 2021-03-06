//
//  RankTable.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/8/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation

let ranks = ["Noob":50, "Grown-up":150, "Warrior":1000, "Royalty":5000]
let noobExp = 50
let grownUpExp = 150
let warriorExp = 1000
let knightExp = 5000



class RankTable: NSObject {

    func expToNextRank(experiencePoints: NSNumber) -> String{
        let expAsInt = Int(experiencePoints)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
            switch expAsInt {
            case 0..<noobExp:
                let expToNextRank = noobExp-expAsInt
                let exp = NSNumber(value: expToNextRank)
                return formatter.string(from: exp)!
            case 50..<grownUpExp:
                let expToNextRank = grownUpExp-expAsInt
                let exp = NSNumber(value: expToNextRank)
                return formatter.string(from: exp)!
            case 150..<warriorExp:
                let expToNextRank = warriorExp-expAsInt
                let exp = NSNumber(value: expToNextRank)
                return formatter.string(from: exp)!
            case 1000..<knightExp:
                let expToNextRank = knightExp-expAsInt
                let exp = NSNumber(value: expToNextRank)
                return formatter.string(from: exp)!
            case 5000..<Int.max:
                return "N/A"
            default:
                let expToNextRank = noobExp-expAsInt
                let exp = NSNumber(value: expToNextRank)
                return formatter.string(from: exp)!
            }
    }
    
    func lookUpRank(experiencePoints: NSNumber) -> String {
        let expAsInt = Int(experiencePoints)
        
            switch expAsInt {
            case 0..<noobExp:
                return "Noob"
            case 50..<grownUpExp:
                return "Grown-up"
            case 150..<warriorExp:
                return "Warrior"
            case 1000..<knightExp:
                return "Knight"
            case 5000..<Int.max:
                return "Royalty"
            default:
                return "Noob"
            }
    }
}
