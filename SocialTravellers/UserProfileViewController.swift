//
//  UserProfileViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 4/29/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import AFNetworking
import FacebookCore
import Parse

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagline: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var experiencePointsLabel: UILabel!
    @IBOutlet weak var trophiesCountLabel: UILabel!
    
    var userFromCell: User!
    
    var user: User! {
        didSet{
          //  profileImageView.setImageWith((URL(string: user.profilePicUrl!))!)
            
            userNameLabel.text = "\(user.firstName!) \(user.lastName!)"
            rankLabel.text = user.rank
            if let exp = user.experiencePoints{
                experiencePointsLabel.text = "\(exp)"
            }
            
            if let profilePictureUrl = user.profilePicUrl{
                profileImageView.setImageWith((URL(string: profilePictureUrl))!)
                //Convert square photo to circle
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
                profileImageView.clipsToBounds = true
                
                //Add border and color
                profileImageView.layer.borderWidth = 3.0
                profileImageView.layer.borderColor =  UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0).cgColor
            }
            print(user.coverPicUrl)
            if let coverPictureUrl = user.coverPicUrl{
                coverImageView.setImageWith((URL(string: coverPictureUrl))!)
            }
            userNameLabel.text = user.fullName
            // userTagline.text = user.tagline Need to ask extra permissions for this. Should we?
        }
    }
    
    func fetchUser(facebookId: String){
        var query = PFQuery(className:"User1")
        query.limit = 1; // limit to at most 1 result
        query.whereKey("facebookId", equalTo:facebookId)
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    print(backendUser.objectId)
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userFromCell == nil{
            print("fetching new user from parse")
        fetchUser(facebookId: (User.currentUser?.facebookId)!)
        } else{
            print("receiving user from scoreboard")
            user = userFromCell
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func requestCurrentUserDetails(){
        user = User.currentUser
    }
    
    
    /*
     // Create a query for places
     let query = PFQuery(className:"Event")
     // Interested in locations near user.
     query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: 100.0)
     // Limit what could be a lot of points.
     query.limit = 20
     
     do {
     let eventsAroundMe = try query.findObjects()
     var retrievedEvents: [Event] = []
     for eventObject in eventsAroundMe {
     let event = Event(event: eventObject)
     retrievedEvents.append(event)
     }
     events = retrievedEvents
     print("Events Around me : ", eventsAroundMe.count)
     firstLoad = false
     } catch {
     print(error)
     }*/
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
