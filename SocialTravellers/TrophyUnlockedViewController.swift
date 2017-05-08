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
    var trophy: Trophy!
    
    @IBOutlet weak var trophyImageView: UIImageView!
    
    @IBOutlet weak var trophyNameLabel: UILabel!
    @IBOutlet weak var expAcquiredLabel: UILabel!
    @IBOutlet weak var currentExpLabel: UILabel!
    @IBOutlet weak var expToNextLevelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveTrophy()
        //updateScreenLabels()
        
        // Do any additional setup after loading the view.
    }

    
    func retrieveTrophy(){
        let query = PFQuery(className:"Trophy")

        query.getObjectInBackground(withId: "Mw7eCMdS0H"){ (backendTrophy: PFObject?, error: Error?) in
            if error == nil && backendTrophy != nil {
                print(backendTrophy)
                self.trophy = Trophy(trophy: backendTrophy!)
                self.updateScreenLabels()
            } else {
                print(error)
            }
        }
    }
 
    
    func updateScreenLabels(){
        trophyNameLabel.text = trophy.name!
        expAcquiredLabel.text = "\(String(describing: trophy.experiencePoints!))"
        
        currentExpLabel.text = "\(String(describing: User.currentUser?.experiencePoints))"
     //  expToNextLevelLabel.text = Requires look-up table to know what exp points corresponds to what rank
        
     //   trophyImageView.image = trophy.picture
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClicked(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as? Container1ViewController {
            
            // TODO Remove trophy from Map
                    self.present(viewController, animated: true, completion: nil)
        }
    }
 }
