//
//  EventUserListViewController.swift
//  SocialTravellers
//
//  Created by victor rodriguez on 4/29/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit

class EventUserListViewController: UIViewController {

    @IBOutlet weak var eventDetailHeaderView: EventDetailHeader!
    
    @IBOutlet weak var tableView: UITableView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventDetailHeaderView.event = event
        
        // Do any additional setup after loading the view.
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

extension EventUserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add function to disable cell selection animation
    }
}
