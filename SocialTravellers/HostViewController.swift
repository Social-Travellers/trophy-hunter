//
//  HostViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/13/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
        
        contentViewControllers = contentControllers()
        
        selectContentViewController(contentViewControllers.first!)
        
        // Do any additional setup after loading the view.
    }
    

    override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return TransitionOptionsBuilder() { builder in
            builder.duration = 0.5
            builder.contentScale = 0.9
        }
    }
    
    private func contentControllers() -> [MenuItemContentViewController] {
        var contentList = [MenuItemContentViewController]()
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "TrophiesMapViewController") as! MenuItemContentViewController)
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "ScoreboardViewController") as! MenuItemContentViewController)
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "UserTrophiesViewController") as! MenuItemContentViewController)
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! MenuItemContentViewController)
        return contentList
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
