//
//  PhotoCollectionViewCell.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postID: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - @IBoutlet
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GesturePhoto()
    }
    
    //MARK: - Vars
    var delegate: PhotoCollectionViewCellDelegate?
    
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

extension PhotoCollectionViewCell {
    //MARK: - TapGesturePhoto
    private func GesturePhoto( ) {
        photoImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapGesture))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func photoTapGesture() {
        delegate?.goToDetailVC(postID: posts?.idPost ?? "")
    }
}
