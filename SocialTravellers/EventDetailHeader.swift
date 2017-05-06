//
//  EventDetailHeader.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 4/29/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class EventDetailHeader: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var event: Event! {
        didSet {
            //nameLabel.text = event.name
           // addressLabel.text = event.address event does not have an address property yet
           // distanceLabel.text = event.location?.distance(from: <#T##CLLocation#>)    requires some location magic
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "EventDetailHeader", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
