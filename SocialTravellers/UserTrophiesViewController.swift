//
//  UserTrophiesViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/11/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse

class UserTrophiesViewController: UIViewController {
    @IBOutlet weak var trophiesCollectionView: UICollectionView!

    var userTrophies: [Trophy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trophiesCollectionView.delegate = self
        trophiesCollectionView.dataSource = self
        
        fetchUserTrophies(withId: User.currentUser!.facebookId!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserTrophies(withId facebookId: String) {
        let query = PFQuery(className:"User1")
        query.limit = 1; // limit to at most 1 result
        query.whereKey("facebookId", equalTo: facebookId)
        
        query.findObjectsInBackground { [unowned self] (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                if let backendObjects = objects {
                    if let userPFObject = backendObjects.first {
                        // Got current user
                        print("Got user: \(userPFObject.objectId!)")
                        
                        let trophiesRelation = userPFObject.relation(forKey: "trophies")
                        let trophiesQuery = trophiesRelation.query()
                        
                        trophiesQuery.findObjectsInBackground(block: { (trophyObjects: [PFObject]?, trophyError: Error?) in
                            if trophyError != nil {
                                print("Error: \(trophyError!.localizedDescription)")
                            } else {
                                if let backendTrophyObjects = trophyObjects {
                                    // Got user trophies
                                    for trophyObj in backendTrophyObjects {
                                        if let trophy = Trophy(trophy: trophyObj) {
                                            self.userTrophies.append(trophy)
                                            self.trophiesCollectionView.reloadData()
                                        } else {
                                            print("Could not create trophy")
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
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
