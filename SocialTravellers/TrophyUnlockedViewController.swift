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

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trophyImageView: UIImageView!
//    @IBOutlet weak var footerView: UIView!

    @IBOutlet weak var trophyNameLabel: UILabel!
    @IBOutlet weak var expAcquiredLabel: UILabel!
    @IBOutlet weak var currentExpLabel: UILabel!
    @IBOutlet weak var expToNextLevelLabel: UILabel!
    @IBOutlet weak var currentRankLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

    var completedEvent: Event!
    var trophy: Trophy!

    var pfUser: PFObject?

    var user: User! {
        didSet {

            currentExpLabel.text = user.experiencePointsString
            if user.expToNextRank == "N/A" {
                expToNextLevelLabel.text = "You're at the top!"
            } else {
                expToNextLevelLabel.text = user.expToNextRank
            }
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

        navigationController?.navigationBar.barTintColor = Constants.Color.THEMECOLOR
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "Trophy Unlocked"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        navigationItem.titleView = titleLabel

        // Rounded corners
        contentView.layer.cornerRadius = 3
        contentView.clipsToBounds = true
        trophyImageView.layer.cornerRadius = 3
        trophyImageView.clipsToBounds = true

        // Drop shadow
        let shadowPath = UIBezierPath(rect: contentView.bounds)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowPath = shadowPath.cgPath

//        let buttonShadowPath = UIBezierPath(rect: footerView.bounds)
//        footerView.layer.masksToBounds = false
//        footerView.layer.shadowColor = UIColor.darkGray.cgColor
//        footerView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        footerView.layer.shadowOpacity = 0.4
//        footerView.layer.shadowRadius = 15.0
//        footerView.layer.shadowPath = buttonShadowPath.cgPath

        updateUser(userId: User.currentUser!.facebookId!)
        updateTrophyLabels(trophy: trophy)
    }


    // Update user's trophies and XP
    func updateUser(userId facebookId: String) {
        let query = PFQuery(className: Constants.ParseServer.USER)
        query.limit = 1;
        // limit to at most 1 result
        query.whereKey("facebookId", equalTo: facebookId)
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in

            if error == nil {
                // The find succeeded.
                debugPrint("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    debugPrint(backendUser.objectId ?? "")

                    // Add trophy
                    let unlockedTrophy = PFObject(withoutDataWithClassName: "Trophy", objectId: self.trophy.objectId!)
                    backendUser.addUniqueObject(unlockedTrophy, forKey: "trophies")
                    // Update XP
                    let currentXp = backendUser["experiencePoints"] as! NSNumber
                    let newXp = currentXp.intValue + self.trophy.experiencePoints!.intValue
                    backendUser["experiencePoints"] = newXp
                    backendUser.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                        if error != nil {
                            debugPrint("Error: \(error!.localizedDescription)")
                        } else {
                            debugPrint("User trophies updated")
                            debugPrint("User XP updated")

                            self.userUpdated = true
                        }
                    })
                }
            } else {
                // Log details of the failure
                debugPrint("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }

    func fetchUser(userId facebookId: String) {
        let query = PFQuery(className: Constants.ParseServer.USER)
        query.limit = 1;
        // limit to at most 1 result
        query.includeKey("trophies")
        query.whereKey("facebookId", equalTo: facebookId)

        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in

            if error == nil {
                // The find succeeded.
                debugPrint("Fetched user in unlockVC")
                debugPrint("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    let backendUser = backendUsers[0]
                    debugPrint(backendUser.objectId!)
                    self.pfUser = backendUser
                    let frontendUser = User(PFObject: backendUser)
                    self.user = frontendUser
                }
            } else {
                // Log details of the failure
                debugPrint("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }

    func addUserToEvent() {
        if let _ = self.pfUser {
            pfUser?.fetchIfNeededInBackground(block: { (fetchedObject: PFObject?, error: Error?) in
                if error != nil {
                    debugPrint("Error: \(error!.localizedDescription)")
                } else {
                    debugPrint("User \(fetchedObject!.objectId!) fetched to add to event")
                    let eventObject = PFObject(withoutDataWithClassName: "Event1", objectId: self.completedEvent.objectId!)
                    debugPrint("Adding user to event: \(eventObject.objectId!)")
                    eventObject.addUniqueObject(fetchedObject!, forKey: "completedBy")

                    eventObject.saveInBackground(block: { (succeeded: Bool, saveError: Error?) in
                        if saveError != nil {
                            debugPrint("Save error: \(saveError!.localizedDescription)")
                        } else {
                            debugPrint("User added to event")
                        }
                    })
                }
            })
        } else {
            debugPrint("pfUser is nil")
        }
    }


    func updateTrophyLabels(trophy: Trophy) {
        trophyNameLabel.text = trophy.name!
        expAcquiredLabel.text = trophy.experiencePointsString

        let userImageFile = trophy.picture!
        userImageFile.getDataInBackground {
            (imageData: Data?, error: Error?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    self.trophyImageView.image = image
                    debugPrint("loaded image successfully")
                }
            }
        }
    }


    @IBAction func dismissClicked(_ sender: UIButton) {
        // navigationController?.popViewController(animated: true)
        debugPrint("dismissClicked")
        let trophyUnlockedName = NSNotification.Name(rawValue: "TrophyUnlocked")
        NotificationCenter.default.post(name: trophyUnlockedName, object: nil)
        debugPrint("TrophyUnlocked notification posted")
    }
}
