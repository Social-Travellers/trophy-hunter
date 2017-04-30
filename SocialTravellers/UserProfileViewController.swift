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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagline: UILabel!
    
    var user: User! {
        didSet{
            profileImageView.setImageWith((URL(string: user.profilePicUrl!))!)
            userNameLabel.text = "\(user.firstName!) \(user.lastName!)"
            userTagline.text = user.tagline
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func requestCurrentUserDetails(){
        //fb magic
    }
    
    
    //Method to save data to parse backend
    func saveUserToBackend()
    {
        // check if user already exists
        // if user exists do not save a record but update record
        // UPDATE RECORD BY CHECKING FACEBOOK ID
        // if user DOES NOT exists create a new record
        
        // update user
        
        // save new user
        
        let backendUser = PFObject(className:"AppUser")
        backendUser["firstName"] = user.firstName
        backendUser["lastName"] = user.lastName
        backendUser["email"] = user.email
        backendUser["userName"] = user.userName
        backendUser["tagline"] = user.tagline
        backendUser["profilePicUrl"] = user.profilePicUrl
        backendUser["phoneNumber"] = user.phoneNumber
        backendUser["facebookId"] = user.facebookId
        
        backendUser.saveInBackground { (succeeded: Bool, error: Error?) in
            if (succeeded) {
                print("User Saved")
            } else {
                print("Error Saving User to Parse ",error.debugDescription)
            }
        }
        
    }
    
    //Update a User given a user id
    func updateUserInBackend(userId: String) {
        
        let localUser: User = User()
        
        let query = PFQuery(className:"AppUser")
        query.getObjectInBackground(withId: userId) { (user: PFObject?, error: Error?) in
            if (error != nil) {
                print(error)
            } else if let user = user{
                
                user["firstName"] = localUser.firstName
                // .... update other User attributes
                user.saveInBackground()
            }
        }
    }

    // retrieve a user from backend given a user id
    func fetchUserFromBackend(userId: String) -> User
    {
        let localUser: User = User()
        
        let query = PFQuery(className:"AppUser")
        query.getObjectInBackground(withId: userId) {
            (user: PFObject?, error: Error?) in
            if error == nil && user != nil {
                
                localUser.firstName = user?["firstName"] as! String
                
            } else {
                print(error.debugDescription)
            }
        }
        return localUser
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
