//
//  PeopleTableViewCell.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    //MARK: - @IBoutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Vars
    var followService = FollowService()
    
    var users: User? {
        didSet {
            updateView()
        }
    }
    
    var uidUserChoice: String? {
        didSet {
            uidUserFollow = uidUserChoice ?? ""
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
        
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    @objc func followAction() {
        followService.followUploadInDatabase()
    }
    
    @objc func unFollowAction() {
//        followService.unFollowUploadInDatabase()
    }
}
