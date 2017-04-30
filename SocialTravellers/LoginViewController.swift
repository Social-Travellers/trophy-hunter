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
        
        let params = ["fields" : "email, name, first_name, last_name, picture.type(large), cover"]
        // Request permission to read e-mail, first/last name, and profile picture
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
                    print("setting User.currentUser in DidCompleteLogin")

                }
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out")
    }
    
}
