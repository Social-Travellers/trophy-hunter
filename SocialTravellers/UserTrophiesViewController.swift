//
//  UserTrophiesViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/11/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse
import InteractiveSideMenu

class UserTrophiesViewController: MenuItemContentViewController {
    @IBOutlet weak var trophiesCollectionView: UICollectionView!

    var userTrophies: [Trophy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trophiesCollectionView.delegate = self
        trophiesCollectionView.dataSource = self
        
        fetchUserTrophies(withId: User.currentUser!.facebookId!)
    }
    

    
    func fetchUserTrophies(withId facebookId: String) {
        let query = PFQuery(className:"User1")
        query.limit = 1; // limit to at most 1 result
        query.includeKey("trophies")
        query.whereKey("facebookId", equalTo: facebookId)
        
        query.findObjectsInBackground { [unowned self] (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                if let backendObjects = objects {
                    if let userPFObject = backendObjects.first {
                        // Got current user
                        print("Got user: \(userPFObject.objectId!)")
                        
                        let frontendUser = User(PFObject: userPFObject)
                        
                        for trophy in frontendUser.trophies {
                            self.userTrophies.append(trophy)
                            self.trophiesCollectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }


    @IBAction func onMenuButton(_ sender: Any) {
        showMenu()
    }

}

extension UserTrophiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrophies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrophyCollectionCell", for: indexPath) as! TrophyCollectionViewCell
        cell.trophy = userTrophies[indexPath.row]
        return cell
    }
    
}
