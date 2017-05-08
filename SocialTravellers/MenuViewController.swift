//
//  MenuViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/7/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var trophiesViewController: UIViewController!
    fileprivate var userProfileViewController: UIViewController!
    fileprivate var scoreboardViewController: UIViewController!
    
    var menuLabels = ["Map", "Profile", "High Scores"]
    
    var viewControllers: [UIViewController] = []
    var containerViewController: Container1ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        configureRowHeight()
        
        print("ViewDidLoad: MenuViewController")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        trophiesViewController = storyboard.instantiateViewController(withIdentifier: "TrophiesMapViewController") as! UIViewController
        userProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UIViewController
        scoreboardViewController = storyboard.instantiateViewController(withIdentifier: "ScoreboardViewController") as! UIViewController
        
        viewControllers.append(trophiesViewController)
        viewControllers.append(userProfileViewController)
        viewControllers.append(scoreboardViewController)
       
        containerViewController?.contentViewController = trophiesViewController
        
    }
    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuLabel.text = menuLabels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        containerViewController.contentViewController = viewControllers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
