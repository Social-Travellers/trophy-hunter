//
//  TrophyUnlockedViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/6/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse

class TrophyUnlockedViewController: UIViewController {
    
    @IBOutlet weak var trophyImageView: UIImageView!
    
    @IBOutlet weak var trophyNameLabel: UILabel!
    @IBOutlet weak var expAcquiredLabel: UILabel!
    @IBOutlet weak var currentExpLabel: UILabel!
    @IBOutlet weak var expToNextLevelLabel: UILabel!
    @IBOutlet weak var currentRankLabel: UILabel!
    
    var completedEvent: Event!
    var trophy: Trophy!
    
    var pfUser: PFObject?
    
    var user: User! {
        didSet {
            if let userExp = user.experiencePoints{
                currentExpLabel.text = "\(userExp)"
            }
            expToNextLevelLabel.text = user.expToNextRank
            currentRankLabel.text = user.rank
            
            addUserToEvent()
        }
    }
    
    var userUpdated: Bool! {
        didSet {
            fetchUser(userId: (User.currentUser?.facebookId!)!)
        }
    }
    
    var rankTable = RankTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUser(userId: User.currentUser!.facebookId!)
        updateTrophyLabels(trophy: trophy)
        //fetchUser(userId: User.currentUser!.facebookId!)
    }
    
    
    // Update user's trophies and XP
    func updateUser(userId facebookId: String) {
        let query = PFQuery(className:"User1")
        query.limit = 1; // limit to at most 1 result
        query.whereKey("facebookId", equalTo: facebookId)
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    print(backendUser.objectId ?? "")
                    
                    // Add trophy
                    let unlockedTrophy = PFObject(withoutDataWithClassName: "Trophy", objectId: self.trophy.objectId!)
                    backendUser.addUniqueObject(unlockedTrophy, forKey: "trophies")
                    // Update XP
                    let currentXp = backendUser["experiencePoints"] as! NSNumber
                    let newXp = currentXp.intValue + self.trophy.experiencePoints!.intValue
                    backendUser["experiencePoints"] = newXp
                    backendUser.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                        if error != nil {
                            print("Error: \(error!.localizedDescription)")
                        } else {
                            print("User trophies updated")
                            print("User XP updated")
                            
                            self.userUpdated = true
                        }
                    })
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    func fetchUser(userId facebookId: String) {
        let query = PFQuery(className:"User1")
        query.limit = 1; // limit to at most 1 result
        query.includeKey("trophies")
        query.whereKey("facebookId", equalTo:facebookId)
        
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Fetched user in unlockVC")
                print("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    print(backendUser.objectId!)
                    self.pfUser = backendUser
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    func addUserToEvent() {
        if let _ = self.pfUser {
            pfUser?.fetchIfNeededInBackground(block: { (fetchedObject: PFObject?, error: Error?) in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else {
                    print("User \(fetchedObject!.objectId!) fetched to add to event")
                    let eventObject = PFObject(withoutDataWithClassName: "Event1", objectId: self.completedEvent.objectId!)
                    print("Adding user to event: \(eventObject.objectId!)")
                    eventObject.addUniqueObject(fetchedObject!, forKey: "completedBy")
                    
                    eventObject.saveInBackground(block: { (succeeded: Bool, saveError: Error?) in
                        if saveError != nil {
                            print("Save error: \(saveError!.localizedDescription)")
                        } else {
                            print("User added to event")
                        }
                    })
                }
            })
        } else {
            print("pfUser is nil")
        }
    }
    
    
    func updateTrophyLabels(trophy: Trophy){
        trophyNameLabel.text = trophy.name!
        expAcquiredLabel.text = "\(String(describing: trophy.experiencePoints!))"
        
        let userImageFile = trophy.picture!
        userImageFile.getDataInBackground {
            (imageData: Data?, error: Error?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.trophyImageView.image = image
                    print("loaded image successfully")
                }
            }
        }
    }

    
    @IBAction func dismissClicked(_ sender: UIButton) {
        // navigationController?.popViewController(animated: true)
        print("dismissClicked")
        let trophyUnlockedName = NSNotification.Name(rawValue: "TrophyUnlocked")
        NotificationCenter.default.post(name: trophyUnlockedName, object: nil)
        print("TrophyUnlocked notification posted")
    }
}
