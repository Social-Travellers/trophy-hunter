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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userTagline: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var experiencePointsLabel: UILabel!
    @IBOutlet weak var trophiesCountLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var userFromCell: User!
    var transitionedFromSegue: Bool!
    
    var user: User! {
        didSet{
            nameLabel.text = "\(user.firstName!) \(user.lastName!)"
            rankLabel.text = user.rank
            userTagline.text = user.tagline
            trophiesCountLabel.text = "\(user.trophies?.count ?? 0)"
            
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
            if let coverPictureUrl = user.coverPicUrl{
                coverImageView.setImageWith((URL(string: coverPictureUrl))!)
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
        if let transitionedFromSegue = transitionedFromSegue{
            if transitionedFromSegue == true {
                closeButton.isHidden = false
            } else {
                closeButton.isHidden = true
            }
        } else{
            closeButton.isHidden = true
        }
        
    }
    
    func fetchUser(facebookId: String){
        let query = PFQuery(className:"User1")
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
                    print(backendUser.objectId!)
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
