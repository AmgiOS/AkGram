//
//  HomeViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Vars
    var postService = LoadPostService()
    var postCount = [Post]()
    var postData: Post?
    
    //MARK: - @IBOutlet
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LaunchScreen()
        connectedScreen()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    //MARK: - @IBAction
    @IBAction func logOutButton(_ sender: Any) {
        LogOutService.shared.logOut()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.post = postCount[indexPath.row]
        return cell
    }
}

extension HomeViewController {
    //MARK: - Functions
    private func setUp() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
    }
    
    private func reloadData() {
        postService.reloadPosts { (success, posts) in
            if success, let post = posts {
                self.postData = post
                print(self.postCount.count)
                self.postsTableView.reloadData()
            }
        }
    }
}
