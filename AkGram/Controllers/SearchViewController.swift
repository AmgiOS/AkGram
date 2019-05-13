//
//  SearchViewController.swift
//  AkGram
//
//  Created by Amg on 12/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Vars
    var searchBar = UISearchBar()
    var peopleService = PeopleService()
    var searchUsers = [User]()
    var idUsers = [String]()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var searchUsersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        doSearch()
    }

    //MARK: - @IBAction
    @IBAction func clickedButton(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.searchUsersTableView)
        guard let indexPath = searchUsersTableView.indexPathForRow(at: buttonPosition) else { return }
        uidUserFollow = idUsers[indexPath.row]
    }
    
}

extension SearchViewController: UITableViewDataSource {
    //MARK: - Collection View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as? PeopleTableViewCell else { return UITableViewCell()}
        let users = searchUsers[indexPath.row]
        let usersID = idUsers[indexPath.row]
        uidAllUsers = [usersID]
        
        cell.users = users
        cell.delegate = self
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    //MARK: - Search Bar
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    
    private func doSearch() {
        guard let text = searchBar.text?.lowercased() else { return }
        searchUsers.removeAll()
        searchUsersTableView.reloadData()
        peopleService.queryUsers(withText: text) { (success, users, id)  in
            if success, let user = users {
                self.searchUsers.append(user)
                self.idUsers.append(id)
                self.searchUsersTableView.reloadData()
            }
        }
    }
}

extension SearchViewController: PeopleTableViewCellDelegate {
    //MARK: - Perfom Segue
    func goToProfileUser(userId: String) {
        performSegue(withIdentifier: "Discover_Segue_Profile", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Discover_Segue_Profile" {
            guard let profileVC = segue.destination as? ProfileUserViewController else { return }
            profileVC.userId = sender as? String ?? ""
            
        }
    }
}
