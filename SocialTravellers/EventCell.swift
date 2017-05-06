//
//  EventCell.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 4/28/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var event: Event1! {
        didSet {
//            nameLabel.text = event.name
//            taglineLabel.text = event.tagline
//            userCountLabel.text = "\(event.users?.count ?? 0)"
           // timeStampLabel.text =             Gotta do some date magic here.
           // distanceLabel.text = event.location?.distance(from: <#T##CLLocation#>)    requires some location magic
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
