//
//  UserProfileViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 4/29/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import AFNetworking
import FacebookCore
import Parse
import InteractiveSideMenu

class UserProfileViewController: MenuItemContentViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTagline: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var experiencePointsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var trophyIconCollectionView: UICollectionView!
    
    var userTrophies: [Trophy] = []
    var trophyImages: [UIImage] = []
    
    var userFromCell: User!
    var transitionedFromSegue: Bool!
    var firstLoad = true
    
    var user: User! {
        didSet{
            nameLabel.text = "\(user.firstName!) \(user.lastName!)"
            rankLabel.text = user.rank
            userTagline.text = user.tagline
            
            //     trophiesCountLabel.text = "\(user.trophies.count)"
            experiencePointsLabel.text = "\(user.experiencePointsString)"
            
            if let profilePictureUrl = user.profilePicUrl{
                profileImageView.setImageWith((URL(string: profilePictureUrl))!)
                //Convert square photo to circle
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
                profileImageView.clipsToBounds = true
                
                //Add border and color
                profileImageView.layer.borderWidth = 3.0
                profileImageView.layer.borderColor =  UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0).cgColor
            }
            if let coverPictureUrl = user.coverPicUrl{
                coverImageView.setImageWith((URL(string: coverPictureUrl))!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trophyIconCollectionView.dataSource = self
        trophyIconCollectionView.delegate = self
        
        if userFromCell == nil{
            print("fetching new user from parse")
            fetchUser(facebookId: (User.currentUser?.facebookId)!)
        } else{
            print("receiving user from scoreboard")
            user = userFromCell
            self.userTrophies = []
            for trophy in user.trophies {
                self.userTrophies.append(trophy)
            }
            trophyIconCollectionView.reloadData()
        }
        setupEscapeButtons()
        trophyIconCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !firstLoad {
            if userFromCell == nil{
                print("fetching new user from parse")
                fetchUser(facebookId: (User.currentUser?.facebookId)!)
            } else{
                print("receiving user from scoreboard")
                user = userFromCell
                trophyIconCollectionView.reloadData()
            }
        }
    }

    func fetchUser(facebookId: String){
        let query = PFQuery(className:Constants.ParseServer.USER)
        query.limit = 1; // limit to at most 1 result
        query.includeKey("trophies")
        query.whereKey("facebookId", equalTo:facebookId)
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                    
                    self.userTrophies = []
                    for trophy in frontendUser.trophies {
                        self.userTrophies.append(trophy)
                    }
                    self.trophyIconCollectionView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
            self.firstLoad = false
        }
    }
    
    func setupEscapeButtons(){
        if let transitionedFromSegue = transitionedFromSegue{
            if transitionedFromSegue == true {
                closeButton.isHidden = false
                menuButton.isHidden = true
            } else {
                closeButton.isHidden = true
                menuButton.isHidden = false
            }
        } else{
            closeButton.isHidden = true
            menuButton.isHidden = false
        }
    }
    
    @IBAction func onMenuButton(_ sender: Any) {
        showMenu()
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// Collection View
extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        return userTrophies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = trophyIconCollectionView.dequeueReusableCell(withReuseIdentifier: "TrophyIconCollectionViewCell", for: indexPath) as! TrophyIconCollectionViewCell
        cell.trophy = userTrophies[indexPath.row]
        print("Adding trophyIcon")
        return cell
    }
}
