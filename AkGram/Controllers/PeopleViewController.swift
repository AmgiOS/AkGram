//
//  PeopleViewController.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    //MARK: - Vars
    var people = PeopleService()
    var follow = FollowService()
    var users = [User]()
    var idUsers = [String]()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var peopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
    }
    
    //MARK: - @IBActions
    @IBAction func clickedButton(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.peopleTableView)
        guard let indexPath = peopleTableView.indexPathForRow(at: buttonPosition) else { return }
        uidUserFollow = idUsers[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            guard let profileUserVc = segue.destination as? ProfileUserViewController else { return }
            profileUserVc.userId = sender as! String
        }
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as? PeopleTableViewCell else { return UITableViewCell()}
        
        let user = users[indexPath.row]
        let usersID = idUsers[indexPath.row]
        uidAllUsers = [usersID]
        
        cell.users = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.row]
        performSegue(withIdentifier: "ProfileSegue", sender: userId.id)
    }
}

extension PeopleViewController {
    //MARK: - Functions
    private func getAllUsers() {
        people.getAllPeople { (success, users, id) in
            if success, let user = users {
                self.users.append(user)
                self.idUsers.append(id)
                self.peopleTableView.reloadData()
            }
        }
    }
}
