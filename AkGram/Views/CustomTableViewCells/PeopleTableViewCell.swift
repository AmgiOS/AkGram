//
//  PeopleTableViewCell.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol PeopleTableViewCellDelegate {
    func goToProfileUser(userId: String)
}

class PeopleTableViewCell: UITableViewCell {
    //MARK: - @IBoutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.setTitle("", for: .normal)
        configureStateButton(followButton)
        gestureName()
    }

    //MARK: - Vars
    var followService = FollowService()
    var delegate: PeopleTableViewCellDelegate?
    
    var users: User? {
        didSet {
            updateView()
        }
    }
}

extension PeopleTableViewCell {
    //MARK: - Functions
    private func updateView() {
        guard let user = users else { return }
        
        let image = URL(string: user.profileImage)
        profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
        nameLabel.text = user.username
        
        updateFollowUser()
    }
    
    func updateFollowUser() {
        users?.isFollowing(uidUser: users?.id ?? "") { (values) in
            DispatchQueue.main.async {
                if let value = values, value {
                    self.configureButtonUnfollow()
                } else {
                    self.configureFollowButton()
                }
            }
        }
    }
}

extension PeopleTableViewCell {
    //MARK: - Configure Button Follow
    private func configureButtonUnfollow() {
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    private func configureFollowButton() {
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = UIColor.black
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    
    private func configureStateButton(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }

    @objc func followAction() {
        followService.followUploadInDatabase()
        configureButtonUnfollow()
    }
    
    @objc func unFollowAction() {
        followService.unFollowUploadInDatabase()
        configureFollowButton()
    }
}

extension PeopleTableViewCell {
    //MARK: - TapGestureRecognizerName
    private func gestureName() {
        nameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureName))
        nameLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureName() {
        delegate?.goToProfileUser(userId: users?.id ?? "")
    }
}
