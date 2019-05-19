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
    var myPostsProfile = MyPosts()
    var posts = [Post]()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var collectionViewProfile: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadUserInfo(uidAccountUser)
        getPostsUser()
    }
    
    //MARK: - @IBAction
}

extension ProfileViewController: UICollectionViewDataSource {
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let post = posts[indexPath.row]
        cell.posts = post
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as? HeaderProfileCollectionReusableView else { return UICollectionReusableView()}
        headerViewCell.user = userProfile
        headerViewCell.delegateToSettingsVC = self
        
        return headerViewCell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    //MARK: Collection View Flow Layout for Size Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileViewController {
    //MARK: - Functions
    private func setUp() {
        collectionViewProfile.dataSource = self
        collectionViewProfile.delegate = self
    }
    
    private func loadUserInfo(_ currentUser: String) {
        postService.setUpUserInfo(currentUser) { (success, user) in
            if success, let user = user {
                self.userProfile = user
                self.navigationItem.title = user.username
                self.collectionViewProfile.reloadData()
            }
        }
    }
    
    private func getPostsUser() {
        self.myPostsProfile.fetchMyPosts(currentId: uidAccountUser) { (success, posts) in
            if success, let post = posts {
                self.posts.append(post)
                self.collectionViewProfile.reloadData()
            }
        }
    }
}

extension ProfileViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingsVC {
    //MARK: - Switch Settings VC
    func goToSettingsVC() {
        performSegue(withIdentifier: "Profile_SettingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile_SettingSegue" {
            let settingsVC = segue.destination as? SettingsTableViewController
            settingsVC?.delegate = self
        } else if segue.identifier == "Profile_SegueDetail" {
            let detailsVC = segue.destination as? DetailViewController
            detailsVC?.postID = sender as? String ?? ""
        }
    }
}

extension ProfileViewController: SettingsTableViewControllerDelegate {
    func updateUserInfo() {
        loadUserInfo(uidAccountUser)
    }
}

extension ProfileViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postID: String) {
        performSegue(withIdentifier: "Profile_SegueDetail", sender: postID)
    }
}
