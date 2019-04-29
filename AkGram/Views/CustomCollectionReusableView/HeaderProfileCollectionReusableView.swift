//
//  HeaderProfileCollectionReusableView.swift
//  AkGram
//
//  Created by Amg on 29/04/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    //MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameProfileLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInfoUser()
    }
    
    //MARK: - Vars
    var user: User? {
        didSet {
            guard let user = user else { return }
            self.nameProfileLabel.text = user.username
            
            let image = URL(string: user.profileImage)
            self.profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
        }
    }
}

extension HeaderProfileCollectionReusableView {
    //MARK: - SetUp
    private func setUpInfoUser() {
        profileImageView.image = UIImage(named: "placeholderImg")
        nameProfileLabel.text = " "
        
    }
}
