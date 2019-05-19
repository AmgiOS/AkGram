//
//  ProfileUserViewController.swift
//  AkGram
//
//  Created by Amg on 13/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol ProfileUserViewControllerDelegate {
    func updateFollowInfo()
}

class ProfileUserViewController: UIViewController {
    //MARK: - Vars
    var postService = LoadPostService()
    var myPostsProfile = MyPosts()
    var userProfile: User?
    var userId = ""
    var posts = [Post]()
    var delegate: ProfileUserViewControllerDelegate?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var profileUserCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        getPostsUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.updateFollowInfo()
    }
}

extension ProfileUserViewController: UICollectionViewDataSource {
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

extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
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

extension ProfileUserViewController {
    //MARK: - Functions
    private func loadUserInfo() {
        postService.setUpUserInfo(userId) { (success, user) in
            if success, let user = user {
                self.userProfile = user
                self.navigationItem.title = user.username
                self.profileUserCollectionView.reloadData()
            }
        }
    }
    
    private func getPostsUser() {
        self.myPostsProfile.fetchMyPosts(currentId: userId) { (success, posts) in
            if success, let post = posts {
                self.posts.append(post)
                self.profileUserCollectionView.reloadData()
            }
        }
    }
}

extension ProfileUserViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingsVC {
    //MARK: - Switch Settings VC
    func goToSettingsVC() {
        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUser_SettingSegue" {
            _ = segue.destination as? SettingsTableViewController
        } else if segue.identifier == "ProfileUser_SegueDetail" {
            let detailVC = segue.destination as? DetailViewController
            detailVC?.postID = sender as? String ?? ""
        }
    }
}

extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postID: String) {
        performSegue(withIdentifier: "ProfileUser_SegueDetail", sender: postID)
    }
}
