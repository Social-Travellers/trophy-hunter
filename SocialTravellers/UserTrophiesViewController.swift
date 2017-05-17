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
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trophiesCollectionView.delegate = self
        trophiesCollectionView.dataSource = self
        
        setupNavigationBar()
        fetchUserTrophies(withId: User.currentUser!.facebookId!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !firstLoad {
            fetchUserTrophies(withId: User.currentUser!.facebookId!)
            self.trophiesCollectionView.reloadData()
        }
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
                        }
                        self.trophiesCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func onMenuButton(_ sender: Any) {
        showMenu()
    }
    
    func setupNavigationBar(){
        trophiesNavigationBar.barTintColor = Constants.Color.THEMECOLOR
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "Trophies"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        trophiesNavigationItem.titleView = titleLabel
    }
}

extension UserTrophiesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrophies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrophyCollectionCell", for: indexPath) as! TrophyCollectionViewCell
        cell.trophy = userTrophies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
}
