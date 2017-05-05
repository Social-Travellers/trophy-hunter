//
//  ThreeTabViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/3/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class ThreeTabViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    
    var eventDetailsViewController: UIViewController?
    var eventChatViewController: UIViewController?
    var eventUserListViewController: UIViewController?
    
    private var activeViewController: UIViewController! {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        eventDetailsViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        eventChatViewController = storyboard.instantiateViewController(withIdentifier: "EventChatViewController") as! EventChatViewController
        eventUserListViewController = storyboard.instantiateViewController(withIdentifier: "EventUserListViewController") as! EventUserListViewController
        
        
        activeViewController = eventChatViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDetailButton(_ sender: Any) {
        activeViewController = eventDetailsViewController
    }
    
    @IBAction func onChatButton(_ sender: Any) {
        activeViewController = eventChatViewController
    }
    
    @IBAction func onAttendeeButton(_ sender: Any) {
        activeViewController = eventUserListViewController
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = contentView.bounds
            contentView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMove(toParentViewController: self)
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
