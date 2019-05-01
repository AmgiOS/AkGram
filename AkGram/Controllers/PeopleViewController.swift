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
    var users = [User]()
    var idUsers = [String]()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var peopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUsers()
    }
    
    //MARK: - @IBActions
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
        
        
        cell.users = user
        cell.uidUserChoice = usersID
        return cell
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
