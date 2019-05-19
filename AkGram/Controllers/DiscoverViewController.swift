//
//  DiscoverViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    //MARK: Vars
    var postService = LoadPostService()
    var postsData = [Post]()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopPosts()
    }

    //MARK: - @IBAction
    @IBAction func refreshButton(_ sender: Any) {
        getTopPosts()
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let posts = postsData[indexPath.row]
        cell.posts = posts
        cell.delegate = self
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
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

extension DiscoverViewController {
    //MARK: - Get Top Posts
    private func getTopPosts() {
        LoadingScreen()
        postsData.removeAll()
        postService.observeTopPosts { (success, posts) in
            if success, let post = posts {
                self.dismissLoadingScreen()
                self.postsData.append(post)
                self.discoverCollectionView.reloadData()
            }
            self.dismissLoadingScreen()
        }
    }
}

extension DiscoverViewController: PhotoCollectionViewCellDelegate {
    //MARK: - Go To Details
    func goToDetailVC(postID: String) {
        performSegue(withIdentifier: "Discover_DetailSegue", sender: postID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Discover_DetailSegue" {
            guard let detailVC = segue.destination as? DetailViewController else { return }
            detailVC.postID = sender as? String ?? ""
        }
    }
}
