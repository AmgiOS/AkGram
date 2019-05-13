//
//  HeaderProfileCollectionReusableView.swift
//  AkGram
//
//  Created by Amg on 29/04/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    //MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameProfileLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInfoUser()
        configureStateButton(followButton)
    }
    
    //MARK: - Vars
    var followService = FollowService()
    
    var user: User? {
        didSet {
            updateView()
        }
    }
}

extension HeaderProfileCollectionReusableView {
    //MARK: - SetUp
    private func setUpInfoUser() {
        profileImageView.image = UIImage(named: "placeholderImg")
        nameProfileLabel.text = " "
        myPostCountLabel.text = "0"
        followingCountLabel.text = "0"
        followersCountLabel.text = "0"
    }
    
    private func updateView() {
        guard let user = user else { return }
        self.nameProfileLabel.text = user.username
        
        let image = URL(string: user.profileImage)
        self.profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
        
        checkProfileUser()
    }
}

extension HeaderProfileCollectionReusableView {
    //MARK: - TapGestureRecognizer Button Edit/Follow
    private func checkProfileUser() {
        if user?.id == uidAccountUser {
            followButton.setTitle("Edit Profilee", for: .normal)
        } else {
            updateStateFollowButton()
        }
    }
    
    private func updateStateFollowButton() {
        user?.isFollowing { (values) in
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

extension HeaderProfileCollectionReusableView {
    //MARK: - ConfigureButtonFollow
    private func configureButtonUnfollow() {
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    @objc func unFollowAction() {
        followService.unFollowUploadInDatabase()
        configureFollowButton()
    }
    
    private func configureFollowButton() {
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = UIColor.black
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    
    @objc func followAction() {
        followService.followUploadInDatabase()
        configureButtonUnfollow()
    }
    
    private func configureStateButton(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
}
