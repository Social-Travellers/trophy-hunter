//
//  User1Cell.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/7/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class User1Cell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var experiencePointsLabel: UILabel!
    @IBOutlet weak var trophiesCountLabel: UILabel!

    var user: User! {
        didSet {
            print("setting up user cell for \(user.firstName ?? "USER IS NIL")")
            if let firstName = user.firstName {
                if let lastName = user.lastName {
                    nameLabel.text = "\(String(describing: firstName)) \(String(describing: lastName))"
                }
            }
            trophiesCountLabel.text = "\(user.trophies.count)"
            profileImageView.setImageWith(URL(string: user.profilePicUrl!)!)
            addRoundEdges(imageView: profileImageView)
            rankLabel.text = user.rank
            experiencePointsLabel.text = "\(user.experiencePointsString)"

        }
    }

    func addRoundEdges(imageView: UIImageView) {
        //Round edges on trophy imageViews
        imageView.layer.cornerRadius = imageView.frame.size.width / 8
        imageView.clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
