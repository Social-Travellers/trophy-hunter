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
    @IBOutlet weak var trophiesNavigationBar: UINavigationBar!
    @IBOutlet weak var trophiesNavigationItem: UINavigationItem!

    var userTrophies: [Trophy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tealColor = UIColor(red:0.47, green:0.80, blue:0.83, alpha:1.0)
        trophiesNavigationBar.barTintColor = tealColor
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "Trophies Collection"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        trophiesNavigationItem.titleView = titleLabel
        
        trophiesCollectionView.delegate = self
        trophiesCollectionView.dataSource = self
        
        fetchUserTrophies(withId: User.currentUser!.facebookId!)
    }
    

    
    func fetchUserTrophies(withId facebookId: String) {
        let query = PFQuery(className:Constants.ParseServer.USER)
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
