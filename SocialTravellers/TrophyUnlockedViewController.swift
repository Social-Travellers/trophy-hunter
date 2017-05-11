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
    
    var trophy: Trophy!
    
    var user: User! {
        didSet {
            if let userExp = user.experiencePoints{
                currentExpLabel.text = "\(userExp)"
                expToNextLevelLabel.text = user.expToNextRank
                currentRankLabel.text = user.rank
            }
        }
    }
    
    var rankTable = RankTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAndUpdateExp(userId: User.currentUser!.facebookId!)
        updateTrophyLabels(trophy: trophy)
        
    }
    
    func fetchUserAndUpdateExp(userId facebookId: String) {
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
                    
                    if let currentXp = backendUser["experiencePoints"] as? NSNumber {
                        let newXp = currentXp.intValue + self.trophy.experiencePoints!.intValue
                        backendUser.add(self.trophy, forKey: "trophies")
                        
                        backendUser["experiencePoints"] = newXp
                        backendUser.saveInBackground() { (succeeded: Bool, error: Error?) in
                            if succeeded{
                            print("User XP updated")
                            let frontendUser = User(PFObject: backendUser)
                            self.user = frontendUser
                            } else {
                                print("Error: \(error?.localizedDescription))")
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClicked(_ sender: UIButton) {
        // navigationController?.popViewController(animated: true)
        print("dismissClicked")
        let trophyUnlockedName = NSNotification.Name(rawValue: "TrophyUnlocked")
        NotificationCenter.default.post(name: trophyUnlockedName, object: nil)
        print("TrophyUnlocked notification posted")
    }
}
