//
//  CommentTableViewCell.swift
//  AkGram
//
//  Created by Amg on 03/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate {
    func goToProfileUser(userId: String)
}

class CommentTableViewCell: UITableViewCell {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        gestureName()
    }
    
    //MARK: - Vars
    var postService = LoadPostService()
    var commentVC: CommentViewController?
    var delegate: CommentTableViewCellDelegate?
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
            commentLabel.text = comment.commentText
            loadUserInfo(comment.uid)
        }
    }
}

extension CommentTableViewCell {
    
    //MARK: - Functions
    private func loadUserInfo(_ currentUser: String) {
        postService.setUpUserInfo(currentUser) { (success, user) in
            if success, let user = user {
                self.nameLabel.text = user.username
                
                let image = URL(string: user.profileImage)
                self.profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
            }
        }
    }
}

extension CommentTableViewCell {
    //MARK: - TapGestureRecognizerName
    private func gestureName() {
        nameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureName))
        nameLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureName() {
        delegate?.goToProfileUser(userId: comment?.uid ?? "")
    }
}
