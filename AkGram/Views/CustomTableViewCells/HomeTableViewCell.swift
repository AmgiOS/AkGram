//
//  HomeTableViewCell.swift
//  AkGram
//
//  Created by Amg on 02/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeTableViewCellDelegate {
    func commentToSegue(postId: String)
    func goToProfileUser(userUid: String)
}

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
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = "User"
        captionLabel.text = "Added comment ..."
        GestureComment()
        GestureLike()
        GestureName()
    }

    //MARK: - Vars
    var delegate: HomeTableViewCellDelegate?
    var homeVC: HomeViewController?
    var likesService = LikesService()
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            self.nameLabel.text = user.username
            
            let image = URL(string: user.profileImage)
            self.profileImageview.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
        }
    }
}

extension HomeTableViewCell {
    //MARK: - Update View Posts
    private func updateView() {
        guard let post = post else { return }
        
        captionLabel.text = post.descriptionPhoto
        let image = URL(string: post.photoURL)
        postImageView.sd_setImage(with: image, completed: nil)
        
        getLikesInDatabase(post)
    }
    
    //MARK: - Likes
    private func getLikesInDatabase(_ post: Post) {
        let imageName = post.likes == nil || !post.isLiked ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        if let likeCount = post.likeCount, likeCount != 0 {
            likeCountButton.setTitle("\(likeCount) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the First like this", for: .normal)
        }
    }
}

extension HomeTableViewCell {
    //MARK: - TapGestureRecognizerComment
    private func GestureComment( ) {
        commentImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        commentImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesture() {
        delegate?.commentToSegue(postId: post?.idPost ?? "")
    }
    
    //MARK: - TapGestureRecognizerLike
    private func GestureLike( ) {
        likeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureLike))
        likeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureLike() {
        guard let postIndex = post else { return }
        likesService.downloadLikesInPosts(postIndex.idPost) { (success, posts) in
            if success, let post = posts {
                self.getLikesInDatabase(post)
                guard let indexPath = self.homeVC?.postsTableView.indexPath(for: self) else { return }
                self.homeVC?.postData[indexPath.row] = post
            }
        }
    }
    
    //MARK: - TapGestureRecongnizerName
    private func GestureName() {
        nameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureName))
        nameLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureName() {
        delegate?.goToProfileUser(userUid: user?.id ?? "")
    }
}

