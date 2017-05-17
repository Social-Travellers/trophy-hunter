//
//  ScoreboardViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 5/7/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import AFNetworking
import Parse
import InteractiveSideMenu

class ScoreboardViewController: MenuItemContentViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreboardNavigationBar: UINavigationBar!
    @IBOutlet weak var scoreboardNavigationItem: UINavigationItem!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        configureRowHeight()

        setUpNavigationBar()
        addRefreshControl()
        fetchUserList()
    }

    @IBAction func onMenuButton(_ sender: Any) {
        showMenu()
    }


    func fetchUserList() {
        let query = PFQuery(className: Constants.ParseServer.USER)
        query.includeKey("trophies")
        query.limit = 10;
        // limit to at most 10 results
        query.order(byDescending: "experiencePoints")
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in

            if error == nil {
                // The find succeeded.
                debugPrint("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    self.users = []
                    for backendUser in backendUsers {
                        debugPrint(backendUser.objectId!)
                        let frontendUser = User(PFObject: backendUser)
                        self.users.append(frontendUser)
                        debugPrint("reloading table view")
                        self.tableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                debugPrint("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScoreboardToUser" {
            let userCell = sender as! User1Cell
            let userIndexPath = tableView.indexPath(for: userCell)
            let user = users[(userIndexPath?.row)!]
            let userProfileVC = segue.destination as! UserProfileViewController
            userProfileVC.userFromCell = user
            userProfileVC.transitionedFromSegue = true
        }
    }

    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User1Cell", for: indexPath) as! User1Cell

        if users.count != 0 {
            let user = users[indexPath.row]
            cell.user = user
        }
        debugPrint("setting up cell")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add segue to send to that user's profileView
        tableView.deselectRow(at: indexPath, animated: true)
    }

    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    @objc fileprivate func refreshControlAction(refreshControl: UIRefreshControl) {
        let query = PFQuery(className: Constants.ParseServer.USER)
        query.includeKey("trophies")
        query.limit = 10;
        // limit to at most 10 results
        query.order(byDescending: "experiencePoints")
        // Investigate if there's a query parameter that will sort this by a key-value (experience points)
        query.findObjectsInBackground {
            (backendUsers: [PFObject]?, error: Error?) -> Void in

            if error == nil {
                // The find succeeded.
                debugPrint("Successfully retrieved \(backendUsers!.count) users.")
                // Do something with the found objects
                if let backendUsers = backendUsers {
                    self.users = []
                    for backendUser in backendUsers {
                        debugPrint(backendUser.objectId!)
                        let frontendUser = User(PFObject: backendUser)
                        self.users.append(frontendUser)
                        debugPrint("reloading table view")
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
            } else {
                // Log details of the failure
                debugPrint("Error: \(error!) \(error!.localizedDescription)")
                refreshControl.endRefreshing()
            }
        }
    }

    func setUpNavigationBar() {
        scoreboardNavigationBar.barTintColor = Constants.Color.THEMECOLOR
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "High Scores"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        scoreboardNavigationItem.titleView = titleLabel
    }
}
