//
//  ProfileViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Vars
    var userProfile: User?
    var postService = LoadPostService()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var collectionViewProfile: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewProfile.dataSource = self
        loadUserInfo(uidAccountUser)
    }
    
    //MARK: - @IBAction
}

extension ProfileViewController: UICollectionViewDataSource {
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as? HeaderProfileCollectionReusableView else { return UICollectionReusableView()}
        headerViewCell.user = userProfile
        
        return headerViewCell
    }
}

extension ProfileViewController {
    //MARK: - Functions
    private func loadUserInfo(_ currentUser: String) {
        postService.setUpUserInfo(currentUser) { (success, user) in
            if success, let user = user {
                self.userProfile = user
                self.collectionViewProfile.reloadData()
            }
        }
    }
}
