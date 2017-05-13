//
//  LoginViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 4/27/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Parse

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            print("Auth Token: \(accessToken.authenticationToken)")
            if let userId = accessToken.userId {
                print("User ID: \(userId)")
                
            }
        }
        
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email, .userFriends])
        loginButton.center = CGPoint(x: view.bounds.width/2.0, y: view.bounds.height/2.0 + 100)
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        // Move to the home screen
        performSegue(withIdentifier: "loginToTrophies", sender: self)

        let params = ["fields" : "id, email, name, first_name, last_name, picture.type(large), cover, about"]
        // Request data
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    let data = responseDictionary as [String: AnyObject]
                    
                    User.currentUser = User(dictionary: data)
                    if let currentUser = User.currentUser{
                        self.saveUserToBackend(user: currentUser)

                    }
                    print("setting User.currentUser in DidCompleteLogin")
                }
            }
        }
        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out")
    }
    
    //Method to save data to parse backend
    func saveUserToBackend(user:User){
        // check if user already exists
        // if user exists do not save a record but update record
        // UPDATE RECORD BY CHECKING FACEBOOK ID
        // if user DOES NOT exists create a new record
        let query = PFQuery(className:"User1")
        query.whereKey("facebookId", equalTo: user.facebookId!)
        
        // Check if user already exists
        query.findObjectsInBackground { (PFUsers:[PFObject]?, error:Error?) in
            if PFUsers == nil || PFUsers?.count == 0{
                //User not in back end, now saving user as a new entry in back end
                print("User not in back end, now saving user as a new entry in back end")
                let backendUser = PFObject(className:"User1")
                backendUser["firstName"] = user.firstName ?? "N/A"
                backendUser["lastName"] = user.lastName ?? "N/A"
                backendUser["email"] = user.email ?? "N/A"
                backendUser["profilePicUrl"] = user.profilePicUrl ?? "N/A"
                backendUser["coverPicUrl"] = user.coverPicUrl ?? "N/A"
                backendUser["facebookId"] = user.facebookId ?? "N/A"
                
               // backendUser[tropies] = user.trophies
                backendUser["experiencePoints"] = user.experiencePoints ?? 0
                
                backendUser.saveInBackground { (succeeded: Bool, error: Error?) in
                    if (succeeded) {
                        print("User Saved")
                    } else {
                        print("Error Saving User to Parse ",error.debugDescription)
                    }
                }
                
            } else {
                //user was already in back end, now updating user object in back end
                print("user was already in back end, now updating user object in back end")
                let PFUser = PFUsers?[0] //FB ID is unique, so there are only two possibilities. Array has 1 PFUser only, or array is nil
                
                //update currentUser 
                User.currentUser?.objectId = PFUser?.objectId!
                
                self.updateUserInBackend(objectId: (PFUser?.objectId!)!)
                self.fetchUserFromBackend(objectId: (User.currentUser?.objectId!)!)
            }
        }
    }
    
    //Update a User given that user's object id
    func updateUserInBackend(objectId: String) {
        let query = PFQuery(className:"User1")
        query.getObjectInBackground(withId: objectId) { (backendUser: PFObject?, error: Error?) in
            if (error != nil) {
                print(error!)
            } else if let backendUser = backendUser{
                
                if let currentUser = User.currentUser{
                    print("Updating user in back end")
                    backendUser["firstName"] = currentUser.firstName ?? "N/A"
                    backendUser["lastName"] = currentUser.lastName ?? "N/A"
                    backendUser["email"] = currentUser.email ?? "N/A"
                    backendUser["profilePicUrl"] = currentUser.profilePicUrl ?? "N/A"
                    backendUser["coverPicUrl"] = currentUser.coverPicUrl ?? "N/A"
                    backendUser["facebookId"] = currentUser.facebookId ?? "N/A"
                    
                    // backendUser[tropies] = user.trophies
                    //backendUser["experiencePoints"] = currentUser.experiencePoints ?? 0
                    
                    backendUser.saveInBackground()
                }
            }
        }
    }
    
    
    // retrieve a user from backend given a user id
    func fetchUserFromBackend(objectId: String)
    {
       
        // Create a query for appUsers
        let query = PFQuery(className:"User1")
        query.getObjectInBackground(withId: objectId) {
            (backendUser: PFObject?, error: Error?) in
            if error == nil && backendUser != nil {
                if let currentUser = User.currentUser{
                    currentUser.firstName = backendUser?["firstName"] as? String
                    currentUser.lastName = backendUser?["lastName"] as? String
                    currentUser.email = backendUser?["email"] as? String
                    currentUser.profilePicUrl = backendUser?["profilePicUrl"] as? String
                    currentUser.coverPicUrl = backendUser?["coverPicUrl"] as? String
                    currentUser.facebookId = backendUser?["facebookId"] as? String
                    
                   // currentUser.trophies = backendUser?["tropies"] as? [Trophy]
                    currentUser.experiencePoints = backendUser?["experiencePoints"] as? NSNumber
                    
                    //let user = User(PFObject: backendUser! )
                   // User.currentUser = user
                }
            } else {
                print(error.debugDescription)
            }
        }
    }
}
