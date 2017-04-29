//
//  EventFeedViewController.swift
//  SocialTravellers
//
//  Created by Anup Kher on 4/27/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


class EventFeedViewController: UIViewController {
    @IBOutlet weak var eventFeedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eventFeedTableView.delegate = self
        eventFeedTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("loggedout")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:  User.userDidLogoutNotification), object: nil)
    }
    

}

extension EventFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EventFeedToDetails", sender: self)
    }
}
