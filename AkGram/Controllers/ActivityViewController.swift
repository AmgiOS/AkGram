//
//  ActivityViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    //MARK: - Vars
    var notificationService = NotificationService()
    var postService = LoadPostService()
    var notifications = [NotificationApi]()
    var userData = [User]()
    var user: User?
    
    //MARK: - @IBOutlet
    @IBOutlet weak var activityTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        observeNotification()
    }

    //MARK: - @IBAction
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        let notification = notifications[indexPath.row]
        cell.notification = notification
        
        if userData.count <= 1 {
            cell.user = user
        } else {
            let user = userData[indexPath.row]
            cell.user = user
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension ActivityViewController {
    //MARK: - Observe Notification in Database
    private func observeNotification() {
        notificationService.uploadNotification { (success, notif, key) in
            if success, let notif = notif {
                print(notif)
                self.loadUserInfo(notif.from)
                self.notifications.insert(notif, at: 0)
                self.activityTableView.reloadData()
            }
        }
    }
    
    //MARK: - User Info
    func loadUserInfo(_ currentUserPost: String) {
        postService.setUpUserInfo(currentUserPost) { (success, user) in
            if success, let user = user {
                self.user = user
                self.userData.insert(user, at: 0)
                self.activityTableView.reloadData()
            }
        }
    }
}

extension ActivityViewController: ActivityTableViewCellDelegate {
    //MARK: - Go To Details
    func goToDetailVC(postID: String) {
        performSegue(withIdentifier: "Activity_DetailSegue", sender: postID)
    }
    
    func goToProfileVC(userID: String) {
        performSegue(withIdentifier: "Activity_ProfileUserSegue", sender: userID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Activity_DetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController else { return }
            detailVC.postID = sender as? String ?? ""
            
        } else if segue.identifier == "Activity_ProfileUserSegue" {
            guard let userVC = segue.destination as? ProfileUserViewController else { return }
            userVC.userId = sender as? String ?? ""
        }
    }
}
