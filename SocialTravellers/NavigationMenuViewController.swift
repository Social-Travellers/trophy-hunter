//
//  NavigationMenuViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/13/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import FacebookLogin

class NavigationMenuViewController: MenuViewController {

    let viewControllers = ["Map", "High Scores", "Trophies", "Profile"]
    let menuIcons = [#imageLiteral(resourceName: "map"),#imageLiteral(resourceName: "highScores"),#imageLiteral(resourceName: "trophy"),#imageLiteral(resourceName: "profile")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        tableView.separatorStyle = .none //Hide separator lines
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("loggedout")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:  User.userDidLogoutNotification), object: nil)
    }

}
extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
    
        cell.menuLabel.text = viewControllers[indexPath.row]
        cell.menuIconImageView.image = menuIcons[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let menuContainerViewController = self.menuContainerViewController else { return }
            menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
            menuContainerViewController.hideMenu()
        }
    }
}
