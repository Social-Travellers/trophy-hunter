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
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "CreateTrophyViewController") as! MenuItemContentViewController)
        return contentList
    }

}
