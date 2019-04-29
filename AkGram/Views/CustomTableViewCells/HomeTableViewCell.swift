//
//  HomeTableViewCell.swift
//  AkGram
//
//  Created by Amg on 02/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = "Added comment ..."
        tapGestureComment()
        GestureLike()
    }

    //MARK: - Vars
    var postService = LoadPostService()
    var homeVC: HomeViewController?
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            captionLabel.text = post.descriptionPhoto
            
            let image = URL(string: post.photoURL)
            postImageView.sd_setImage(with: image, completed: nil)
            
            loadUserInfo(post.uid)
            getLikesInDatabase(post)
            reloadLikes()
        }
    }
}

extension HomeTableViewCell {
    
    //MARK: - Functions
    private func loadUserInfo(_ currentUser: String) {
        postService.setUpUserInfo(currentUser) { (success, user) in
            if success, let user = user {
                self.nameLabel.text = user.username
                
                let image = URL(string: user.profileImage)
                self.profileImageview.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
            }
        }
    }
    
    private func getLikesInDatabase(_ post: Post) {
        let isLiked = post.likes?[uidAccountUser] ?? false
        let imageName = post.likes == nil || !isLiked ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        if let likeCount = post.likeCount, likeCount != 0 {
            likeCountButton.setTitle("\(likeCount) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the First like", for: .normal)
        }
    }
    
    private func reloadLikes() {
        guard let posts = post else { return }
        LikesService.shared.reloadLikesPosts(posts.idPost) { (likeCount) in
            self.likeCountButton.setTitle("\(likeCount) likes", for: .normal)
        }
    }
}

extension HomeTableViewCell {
    //MARK: - TapGestureRecognizerComment
    private func tapGestureComment( ) {
        commentImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        commentImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesture() {
        homeVC?.performSegue(withIdentifier: "commentSegue", sender: post?.idPost)
    }
    
    //MARK: - TapGestureRecognizerLike
    private func GestureLike( ) {
        likeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureLike))
        likeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureLike() {
        guard let postIndex = post else { return }
        LikesService.shared.downloadLikesInPosts(postIndex.idPost) { (success, posts)  in
            if success, let post = posts {
                self.getLikesInDatabase(post)
            }
        }
    }
}

