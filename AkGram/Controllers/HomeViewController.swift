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
    var feedService = Feed()
    var postService = LoadPostService()
    var postData = [Post]()
    var userData = [User]()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedScreen()
        loadData()
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
        
        if userData.count > 0 || userData.count > 1 {
            let user = userData[indexPath.row]
            cell.user = user
        }
        
        cell.homeVC = self
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController {
    //MARK: - Load Posts
    private func loadData() {
        activityIndicator.isHidden = false
        feedService.uploadFeed { (success, posts) in
            if success, let post = posts {
                self.activityIndicator.isHidden = true
                self.postData.insert(post, at: 0)
                self.loadUserInfo(post.uid)
                self.postsTableView.reloadData()
            }
        }
        
        feedService.observeRemoveFeed { (success, posts) in
            if success, let post = posts {
                self.postData = self.postData.filter { $0.idPost != post.idPost }
                self.userData = self.userData.filter { $0.id != post.uid}
                self.postsTableView.reloadData()
            }
        }
    }
    
    //MARK: - User Info
    func loadUserInfo(_ currentUserPost: String) {
        postService.setUpUserInfo(currentUserPost) { (success, user) in
            if success, let user = user {
                self.userData.insert(user, at: 0)
                self.postsTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    //MARK: - Perfom Segue
    func commentToSegue(postId: String) {
        performSegue(withIdentifier: "commentSegue", sender: postId)
    }
    
    func goToProfileUser(userUid: String) {
        performSegue(withIdentifier: "Home_Segue_Profile", sender: userUid)
    }
    
    func goToHashTag(tag: String) {
        performSegue(withIdentifier: "Home_Segue_HashTag", sender: tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            guard let commentVC = segue.destination as? CommentViewController else { return }
            commentVC.idPost = sender as? String ?? ""
            
        } else if segue.identifier == "Home_Segue_Profile" {
            guard let profileVC = segue.destination as? ProfileUserViewController else { return }
            profileVC.userId = sender as? String ?? ""
            
        } else if segue.identifier == "Home_Segue_HashTag" {
            guard let tagVC = segue.destination as? HashTagViewController else { return }
            tagVC.hashTag = sender as? String ?? ""
        }
        
    }
}
