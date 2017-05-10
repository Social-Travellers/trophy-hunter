//
//  ScoreboardViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/7/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class ScoreboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        configureRowHeight()
        
        fetchUserList()
    }
    
    func fetchUserList(){
        var query = PFQuery(className:"User1")
        query.limit = 10; // limit to at most 10 results
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    for backendUser in backendUsers {
                        print(backendUser.objectId)
                        let frontendUser = User(PFObject: backendUser)
                        self.users.append(frontendUser)
                        print("reloading table view")
                        self.tableView.reloadData()
                    }
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScoreboardToUser"{
            let userCell = sender as! User1Cell
            let userIndexPath = tableView.indexPath(for: userCell)
            let user = users[(userIndexPath?.row)!]
            let userProfileVC = segue.destination as! UserProfileViewController
            userProfileVC.userFromCell = user
            userProfileVC.transitionedFromSegue = true
        }
        
        
     }
    
    
    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User1Cell", for: indexPath) as! User1Cell
        
        if users.count != 0{
            let user = users[indexPath.row]
            cell.user = user
        }
        print("setting up cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add segue to send to that user's profileView
    }
}
