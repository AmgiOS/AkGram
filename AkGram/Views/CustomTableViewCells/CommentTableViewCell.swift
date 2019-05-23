//
//  CommentTableViewCell.swift
//  AkGram
//
//  Created by Amg on 03/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import KILabel

protocol CommentTableViewCellDelegate {
    func goToProfileUser(userId: String)
    func goToHashTag(tag: String)
}

class CommentTableViewCell: UITableViewCell {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: KILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        gestureName()
    }
    
    //MARK: - Vars
    var postService = LoadPostService()
    var peopleUser = PeopleService()
    var commentVC: CommentViewController?
    var delegate: CommentTableViewCellDelegate?
    
    var comment: Comment? {
        didSet{
            updateView()
        }
    }
}

extension CommentTableViewCell {
    //MARK: - UpdateView
    private func updateView() {
        guard let comment = comment else { return }
        commentLabel.text = comment.commentText
        commentLabel.hashtagLinkTapHandler = { label, string, range in
            let tag = String(string.dropFirst())
            self.delegate?.goToHashTag(tag: tag)
        }
        
        commentLabel.userHandleLinkTapHandler = { label, string, range in
            let mention = String(string.dropFirst())
            self.peopleUser.getUserByUsername(username: mention, completionHandler: { (success, users) in
                if success, let user = users {
                    self.delegate?.goToProfileUser(userId: user.id ?? "")
                }
            })
        }
        
        loadUserInfo(comment.uid)
    }
    
    //MARK: - Load User Info
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
