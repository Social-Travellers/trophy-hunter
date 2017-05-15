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
    @IBOutlet var trophyImageViews: [UIImageView]!
    @IBOutlet weak var trophyPlusLabel: UILabel!
    @IBOutlet weak var trophyDarkView: UIView!
    
    
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
            experiencePointsLabel.text = "Experience: \(user.experiencePointsString)"
            
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
        print("UserProfile: viewDidLoad")
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
            self.fetchTrophyImages()
        }
        
        setupEscapeButtons()
        addRoundEdges()
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
            }
        }
    }
    
    func addRoundEdges(){
        //Round edges on trophy imageViews
        for imageView in trophyImageViews{
            imageView.layer.cornerRadius = imageView.frame.size.width / 8
            imageView.clipsToBounds = true
        }
        
        trophyDarkView.layer.cornerRadius = trophyDarkView.frame.size.width / 8
        trophyDarkView.clipsToBounds = true
    }
    
    func fetchTrophyImages(){
        trophyImages = []
        if userTrophies.count == 0{
            trophyPlusLabel.isHidden = true
            trophyDarkView.isHidden = true
        }
            for trophy in userTrophies{
                fetchTrophyImage(trophy: trophy)
            }
    }
    
    func fetchTrophyImage(trophy:Trophy){
        if let imageFile = trophy.picture {
            imageFile.getDataInBackground(block: { [unowned self] (data: Data?, error: Error?) in
                if error != nil {
                    print("Image error: \(error!.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    if let image = image{
                        
                        self.trophyImages.append(image)
                        self.addImagesToView()
                        
                        //    self.addImageToStack(image: image)
                    }
                }
            })
        }
    }
    
    func addImagesToView(){
        
        for index in [0,1,2,3]{
            if  index > trophyImages.count{
                trophyImageViews[index].isHidden = true
                trophyImageViews[index].image = nil
                trophyPlusLabel.isHidden = true
                trophyDarkView.isHidden = true
            } else if index == trophyImages.count && index < 3 {
                trophyImageViews[index].isHidden = true
                trophyImageViews[index].image = nil
                trophyPlusLabel.isHidden = true
                trophyDarkView.isHidden = true
            } else if index == trophyImages.count-1 && index == 3 {
                trophyImageViews[index].image = trophyImages[index]
                trophyDarkView.isHidden = true
                trophyImageViews[index].isHidden = false
                trophyPlusLabel.isHidden = true
            } else if index < trophyImages.count-1 && index == 3 {
                trophyImageViews[index].image = trophyImages[index]
                trophyPlusLabel.text = "+\(trophyImages.count-3)"
                trophyDarkView.isHidden = false
                trophyImageViews[index].isHidden = false
                trophyPlusLabel.isHidden = false
            }
                
            else if index < trophyImages.count{
                trophyImageViews[index].image = trophyImages[index]
                trophyImageViews[index].isHidden = false
                trophyPlusLabel.isHidden = true
                trophyDarkView.isHidden = true
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
                    print(backendUser.objectId!)
                    
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                    
                    self.userTrophies = []
                    for trophy in frontendUser.trophies {
                        self.userTrophies.append(trophy)
                    }
                    self.fetchTrophyImages()
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
