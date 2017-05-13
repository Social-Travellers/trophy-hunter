//
//  TrophyCollectionViewCell.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/11/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class TrophyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trophyImageView: UIImageView!
    @IBOutlet weak var trophyNameLabel: UILabel!
    @IBOutlet weak var trophyExpLabel: UILabel!
    
    var trophy: Trophy! {
        didSet {
            if let imageFile = trophy.picture {
                imageFile.getDataInBackground(block: { [unowned self] (data: Data?, error: Error?) in
                    if error != nil {
                        print("Image error: \(error!.localizedDescription)")
                    } else {
                        let image = UIImage(data: data!)
                        self.trophyImageView.image = image
                    }
                })
            }
            
            trophyNameLabel.text = trophy.name
            trophyExpLabel.text = trophy.experiencePoints?.stringValue
        }
    }
}
