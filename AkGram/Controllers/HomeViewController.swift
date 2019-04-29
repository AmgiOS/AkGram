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
    var postData = [Post]()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedScreen()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postData.removeAll()
        loadData()
    }
    
    //MARK: - @IBAction
    @IBAction func logOutButton(_ sender: Any) {
        LogOutService.shared.logOut()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            guard let commentVC = segue.destination as? CommentViewController else { return }
            commentVC.idPost = sender as? String ?? ""
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let post = postData[indexPath.row]
        cell.post = post
        cell.homeVC = self
        
        return cell
    }
}

extension HomeViewController {
    //MARK: - Functions
    private func setUp() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
    }
    
    private func loadData() {
        activityIndicator.isHidden = false
        postService.reloadPosts { (success, posts) in
            if success, let post = posts {
                self.activityIndicator.isHidden = true
                self.checkIfElementExist(post)
                self.postsTableView.reloadData()
            }
        }
    }
    
    private func checkIfElementExist(_ post: Post) {
        let contain = postData.contains(where: { (element) -> Bool in
            var value = false
            if element.photoURL == post.photoURL {
                value = true
            }
            return value
        })
        if !contain {
            postData.insert(post, at: 0)
        }
    }
}
