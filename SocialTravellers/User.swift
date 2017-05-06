//
//  User.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/26/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import Foundation

class User: NSObject {
    
//    // MARK: - Properties
//    var objectId: String? // Parse Id
//    var email: String?
//    var password: String?
//    var firstName: String?
//    var lastName: String?
//    var facebookId: String?
//    var fullName: String?
//    var profilePicUrl: String?
//    var coverPicUrl: String?
//    var tagline: String?
//    var events: [Event]?
//    
//    var dictionary: [String: AnyObject]?
//    
//    static let currentUserDataKey = "currentUserData"
//    static let userDidLogoutNotification = "UserDidLogout"
//    
//    private static var _currentUser: User?
//    
//    // Facebook response dictionary
//    init(dictionary: [String: AnyObject]) {
//        self.dictionary = dictionary
//        //print(dictionary)
//        let profilePictureData = (dictionary["picture"] as AnyObject).value(forKey: "data") as! [String: AnyObject]
//        let coverPictureData = dictionary["cover"] as! [String: AnyObject]
//        
//        if let profilePicUrlString = profilePictureData["url"]{
//            profilePicUrl = profilePicUrlString as? String
//        }
//        
//        if let coverPicUrlString = coverPictureData["source"]{
//            coverPicUrl = coverPicUrlString as? String
//        }
//        
//        fullName = dictionary["name"] as? String
//        firstName = dictionary["first_name"] as? String
//        lastName = dictionary["last_name"] as? String
//        email = dictionary["email"] as? String
//        facebookId = dictionary["id"] as? String
//        tagline = dictionary["about"] as? String
//        
//    }
//    
//    // Parse response dictionary
//    init(parseDictionary: [String : AnyObject]) {
//        self.objectId = parseDictionary["objectId"] as? String
//        self.email = parseDictionary["email"] as? String
//        self.password = parseDictionary["password"] as? String
//        self.firstName = parseDictionary["firstName"] as? String
//        self.lastName = parseDictionary["lastName"] as? String
//        self.profilePicUrl = parseDictionary["profilePicUrl"] as? String
//        self.tagline = parseDictionary["tagline"] as? String
//    }
//    
//    class var currentUser: User? {
//        get{
//            if _currentUser == nil {
//                let defaults = UserDefaults.standard
//                let userData = defaults.object(forKey: currentUserDataKey) as? Data
//                if let userData = userData {
//                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) // as! NSDictionary
//                    _currentUser = User.init(dictionary: dictionary as! [String: AnyObject])
//                }
//            }
//            return _currentUser
//        }
//        set(user){
//            _currentUser = user
//            
//            let defaults = UserDefaults.standard
//            if let user = user {
//                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
//                defaults.set(data, forKey: currentUserDataKey)
//            }
//            else {
//                defaults.removeObject(forKey: currentUserDataKey)
//            }
//            
//            defaults.synchronize()
//        }
//    }
}
