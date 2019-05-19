//
//  DetailViewController.swift
//  AkGram
//
//  Created by Amg on 17/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - Vars
    var loadPost = MyPosts()
    var loadUserInfo = LoadPostService()
    var postID = ""
    var post: Post?
    var user: User?
    
    //MARK: - @IBOutlet
    @IBOutlet weak var postDiscoverTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPost()
    }
}

extension DetailViewController: UITableViewDataSource {
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.post = post
        cell.user = user
        cell.delegate = self
        
        return cell
    }
}

extension DetailViewController {
    //MARK: - Functions
    private func displayPost() {
        loadPost.observePostsToUser(withId: postID) { (success, posts) in
            if success, let post = posts {
                self.fetchUser(post.uid)
                self.post = post
                self.postDiscoverTableview.reloadData()
            }
        }
    }
    
    private func fetchUser(_ currentUser: String) {
        loadUserInfo.setUpUserInfo(currentUser) { (success, users) in
            if success, let user = users {
                self.user = user
                self.postDiscoverTableview.reloadData()
            }
        }
    }
}

extension DetailViewController: HomeTableViewCellDelegate {
    
    //MARK: - Perfom Segue
    func commentToSegue(postId: String) {
        performSegue(withIdentifier: "commentSegue", sender: postId)
    }
    
    func goToProfileUser(userUid: String) {
        performSegue(withIdentifier: "Discover_Segue_Profile", sender: userUid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            guard let commentVC = segue.destination as? CommentViewController else { return }
            commentVC.idPost = sender as? String ?? ""
            
        } else if segue.identifier == "Discover_Segue_Profile" {
            guard let profileVC = segue.destination as? ProfileUserViewController else { return }
            profileVC.userId = sender as? String ?? ""
        }
    }
}
