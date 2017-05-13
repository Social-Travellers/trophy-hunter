//
//  User.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/26/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation
import Parse

let PFUserKeys = ["email","facebookId","password","firstName","lastName","profilePicUrl", "trophies", "experiencePoints"]


class User: NSObject {
    
    // MARK: - Properties
    var objectId: String? // Parse Id
    var email: String?
    var password: String? // not needed
    var firstName: String?
    var lastName: String?
    var facebookId: String?
    var fullName: String?
    var profilePicUrl: String?
    var coverPicUrl: String?
    var tagline: String?
    
    var trophies: [Trophy] = []
    var experiencePoints: NSNumber?
    lazy var rank:String = {
        let rankTable = RankTable()
        if let expPoints = self.experiencePoints{
            return rankTable.lookUpRank(experiencePoints: expPoints)
        }
        return "Noob"
    }()
    
    lazy var expToNextRank:String = {
        let rankTable = RankTable()
        if let expPoints = self.experiencePoints{
            return rankTable.expToNextRank(experiencePoints: expPoints)
        }
        return "expPoints is nil"
    }()
    
    
    var dictionary: [String: AnyObject]?
    
    static let currentUserDataKey = "currentUserData"
    static let userDidLogoutNotification = "UserDidLogout"
    
    private static var _currentUser: User?
    
    // Facebook response dictionary
    init(dictionary: [String: AnyObject]) {
        self.dictionary = dictionary
        //print(dictionary)
        let profilePictureData = (dictionary["picture"] as AnyObject).value(forKey: "data") as! [String: AnyObject]
        let coverPictureData = dictionary["cover"] as! [String: AnyObject]
        
        if let profilePicUrlString = profilePictureData["url"]{
            profilePicUrl = profilePicUrlString as? String
        }
        
        if let coverPicUrlString = coverPictureData["source"]{
            coverPicUrl = coverPicUrlString as? String
        }
        
        fullName = dictionary["name"] as? String
        firstName = dictionary["first_name"] as? String
        lastName = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        facebookId = dictionary["id"] as? String
        
    }
    
    // Parse response dictionary
    init(PFObject: PFObject) {
        super.init()
        
        // self.dictionary = PFObject
        var newDictionary = [String:AnyObject]()
        for key in PFUserKeys{
            if let value = PFObject[key] as AnyObject?{
                newDictionary[key] = value
            }
        }
        //print(self.dictionary)
        self.dictionary = newDictionary
        
        self.objectId = PFObject.objectId
        self.email = PFObject["email"] as? String
        self.password = PFObject["password"] as? String
        self.firstName = PFObject["firstName"] as? String
        self.lastName = PFObject["lastName"] as? String
        self.profilePicUrl = PFObject["profilePicUrl"] as? String
        self.coverPicUrl = PFObject["coverPicUrl"] as? String
        
        if let trophyObjects = PFObject["trophies"] as? [PFObject] {
            for trophy in trophyObjects {
                let trophy = Trophy(trophy: trophy)
                self.trophies.append(trophy)
            }
        }
//        let relation = PFObject.relation(forKey: "trophies")
//        getUser(query: relation.query())
        
        self.experiencePoints = PFObject["experiencePoints"] as? NSNumber
        self.tagline = PFObject["tagline"] as? String
    }
    
    class var currentUser: User? {
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserDataKey) as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) // as! NSDictionary
                    _currentUser = User.init(dictionary: dictionary as! [String: AnyObject])
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: currentUserDataKey)
            }
            else {
                defaults.removeObject(forKey: currentUserDataKey)
            }
            defaults.synchronize()
        }
    }
    
    func getUser(query: PFQuery<PFObject>){
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) in
            if error == nil {
                for object in objects!{
                    let trophy = Trophy(trophy: object)
                    self.trophies.append(trophy)
                }
            }
            else {
                print(error.debugDescription)
            }
        }
    }
    
}
