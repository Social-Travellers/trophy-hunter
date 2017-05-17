//
//  TrophyCollectionViewCell.swift
//  SocialTravellers
//
//  Created by Anup Kher on 5/11/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class TrophyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trophyContentView: UIView!
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
            trophyExpLabel.text = "\(trophy.experiencePoints?.stringValue ?? "") xp"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 3.0
//        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = true
//        self.layer.cornerRadius = 3.0
//        self.clipsToBounds = true
        let cellShadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3.0
        self.layer.shadowPath = cellShadowPath.cgPath
        
//        trophyImageView.layer.cornerRadius = 3.0
        trophyImageView.clipsToBounds = true
        
//        trophyLabelsView.layer.cornerRadius = 3.0
//        trophyLabelsView.clipsToBounds = true
//        let labelShadowPath = UIBezierPath(rect: trophyLabelsView.bounds)
//        trophyLabelsView.layer.masksToBounds = false
//        trophyLabelsView.layer.shadowColor = UIColor.black.cgColor
//        trophyLabelsView.layer.shadowOffset = CGSize(width: 0, height: -50)
//        trophyLabelsView.layer.shadowOpacity = 0.6
//        trophyLabelsView.layer.shadowRadius = 8.0
//        trophyLabelsView.layer.shadowPath = labelShadowPath.cgPath
    }
}
