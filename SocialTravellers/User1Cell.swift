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
    
    var user: User! {
        didSet {
            print("setting up user cell for \(user.firstName)")
            if let firstName = user.firstName{
                if let lastName = user.lastName{
                     nameLabel.text = "\(String(describing: firstName)) \(String(describing: lastName))"
                }
            }
           
            profileImageView.setImageWith(URL(string:user.profilePicUrl!)!)
            rankLabel.text = user.rank ?? "noob"
            if let exp = user.experiencePoints{
                experiencePointsLabel.text = "\(exp)"
            }
        }
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
