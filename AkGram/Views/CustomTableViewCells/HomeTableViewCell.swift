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
    }

    //MARK: - Vars
    var postService = LoadPostService()
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            captionLabel.text = post.descriptionPhoto
            
            let image = URL(string: post.photoURL)
            postImageView.sd_setImage(with: image, completed: nil)
            
            loadUserInfo(post.uid)
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
}
