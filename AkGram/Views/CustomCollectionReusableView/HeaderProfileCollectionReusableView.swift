//
//  HeaderProfileCollectionReusableView.swift
//  AkGram
//
//  Created by Amg on 29/04/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingsVC {
    func goToSettingsVC()
}

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
    var myPosts = MyPosts()
    var delegateToSettingsVC: HeaderProfileCollectionReusableViewDelegateSwitchSettingsVC?
    
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
        uidUserFollow = user.id
        
        let image = URL(string: user.profileImage)
        self.profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
        
        checkProfileUser()
        fetchCountPosts()
        fetchCountFollow()
        fetchCountFollowers()
    }
}

extension HeaderProfileCollectionReusableView {
    //MARK: - TapGestureRecognizer Button Edit/Follow
    private func checkProfileUser() {
        if user?.id == uidAccountUser {
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.addTarget(self, action: #selector(goTosettingsVC), for: .touchUpInside)
        } else {
            updateStateFollowButton()
        }
    }
    
    @objc func goTosettingsVC() {
        delegateToSettingsVC?.goToSettingsVC()
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

extension HeaderProfileCollectionReusableView {
    //MARK: - Functions
    private func updateStateFollowButton() {
        user?.isFollowing(uidUser: user?.id ?? "") { (values) in
            DispatchQueue.main.async {
                if let value = values, value {
                    self.configureButtonUnfollow()
                } else {
                    self.configureFollowButton()
                }
            }
        }
    }
    
    //Display Count In Profile
    private func fetchCountPosts() {
        myPosts.fetchMyCountPosts(user?.id ?? "") { (count) in
            self.myPostCountLabel.text = "\(count)"
        }
    }
    
    private func fetchCountFollow() {
        followService.fetchCountFollowUser(user?.id ?? "") { (count) in
            self.followingCountLabel.text = "\(count)"
        }
    }
    
    private func fetchCountFollowers() {
        followService.fetchCountFollowerUser(user?.id ?? "") { (count) in
            self.followersCountLabel.text = "\(count)"
        }
    }
}
