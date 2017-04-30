//
//  EventDetailsViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 4/27/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse

class EventDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Update an event
    func updateEvent()
    {
        let localEvent: Event = Event()
        
        let query = PFQuery(className:"Event")
        query.getObjectInBackground(withId: "") { (event: PFObject?, error: Error?) in
            if (error != nil) {
                print(error)
            } else if let event = event{
                
                event["name"] = localEvent.name
                // .... update other event attributes
                event.saveInBackground()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
