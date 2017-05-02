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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        // Move to the home screen
        performSegue(withIdentifier: "LoginToEventFeed", sender: self)
        
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
                        print("tagline = \(currentUser.tagline)")
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
        let query = PFQuery(className:"AppUser")
        query.whereKey("facebookId", equalTo: user.facebookId!)
        
        // Check if user already exists
        query.findObjectsInBackground { (PFUsers:[PFObject]?, error:Error?) in
            if PFUsers == nil || PFUsers?.count == 0{
                //User not in back end, now saving user as a new entry in back end
                print("User not in back end, now saving user as a new entry in back end")
                let backendUser = PFObject(className:"AppUser")
                backendUser["firstName"] = user.firstName ?? "N/A"
                backendUser["lastName"] = user.lastName ?? "N/A"
                backendUser["email"] = user.email ?? "N/A"
                backendUser["tagline"] = user.tagline ?? "N/A" //Requires app submission to FB for review
                backendUser["profilePicUrl"] = user.profilePicUrl ?? "N/A"
                backendUser["coverPicUrl"] = user.coverPicUrl ?? "N/A"
                backendUser["facebookId"] = user.facebookId ?? "N/A"
                
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
                self.updateUserInBackend(objectId: PFUser?.objectId! as! String)
            }
        }
        
        
        
    }
    
    //Update a User given that user's object id
    func updateUserInBackend(objectId: String) {
        let query = PFQuery(className:"AppUser")
        query.getObjectInBackground(withId: objectId) { (backendUser: PFObject?, error: Error?) in
            if (error != nil) {
                print(error)
            } else if let backendUser = backendUser{
                
                if let currentUser = User.currentUser{
                    print("Updating user in back end")
                    backendUser["firstName"] = currentUser.firstName ?? "N/A"
                    backendUser["lastName"] = currentUser.lastName ?? "N/A"
                    backendUser["email"] = currentUser.email ?? "N/A"
                    backendUser["tagline"] = currentUser.tagline ?? "N/A" //Requires app submission to FB for review
                    backendUser["profilePicUrl"] = currentUser.profilePicUrl ?? "N/A"
                    backendUser["coverPicUrl"] = currentUser.coverPicUrl ?? "N/A"
                    backendUser["facebookId"] = currentUser.facebookId ?? "N/A"
                    
                    backendUser.saveInBackground()
                }
            }
        }
    }
    
    
    // retrieve a user from backend given a user id
    func fetchUserFromBackend(objectId: String)
    {
        //        let localUser: User = User()
        // Create a query for appUsers
        let query = PFQuery(className:"AppUser")
        query.getObjectInBackground(withId: objectId) {
            (backendUser: PFObject?, error: Error?) in
            if error == nil && backendUser != nil {
                if let currentUser = User.currentUser{
                    currentUser.firstName = backendUser?["firstName"] as? String
                    currentUser.lastName = backendUser?["lastName"] as? String
                    currentUser.email = backendUser?["email"] as? String
                    currentUser.tagline = backendUser?["tagline"] as? String //Requires app submission to FB for review
                    currentUser.profilePicUrl = backendUser?["profilePicUrl"] as? String
                    currentUser.coverPicUrl = backendUser?["coverPicUrl"] as? String
                    currentUser.facebookId = backendUser?["facebookId"] as? String
                }
            } else {
                print(error.debugDescription)
            }
        }
    }
}
