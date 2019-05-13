//
//  PhotoCollectionViewCell.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - @IBoutlet
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Vars
    var posts: Post? {
        didSet {
            setUpProfile()
        }
    }
}

extension PhotoCollectionViewCell {
    //MARK: - Functions
    //SetUp Library Image Profile
    private func setUpProfile() {
        guard let post = posts else { return }
        
        let image = URL(string: post.photoURL)
        photoImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "Placeholder-image"), options: .continueInBackground, progress: nil, completed: nil)
    }
}
