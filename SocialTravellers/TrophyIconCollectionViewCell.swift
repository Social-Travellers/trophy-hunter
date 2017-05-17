//
//  TrophyIconCollectionViewCell.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/16/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class TrophyIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trophyImageView: UIImageView!

    var trophy: Trophy! {
        didSet {
            if let imageFile = trophy.picture {
                imageFile.getDataInBackground(block: { [unowned self] (data: Data?, error: Error?) in
                    if error != nil {
                        debugPrint("Image error: \(error!.localizedDescription)")
                    } else {
                        let image = UIImage(data: data!)
                        self.trophyImageView.image = image
                    }
                })
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.masksToBounds = true

        let cellShadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3.0
        self.layer.shadowPath = cellShadowPath.cgPath

        trophyImageView.clipsToBounds = true

    }
}
