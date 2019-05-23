//
//  HashTagViewController.swift
//  AkGram
//
//  Created by Amg on 23/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class HashTagViewController: UIViewController {
    //MARK: - Vars
    var hashTag = ""
    var hashTagService = HastagService()
    var getPosts = MyPosts()
    var posts = [Post]()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var hashTagCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = hashTag
        getPostsWithHashTag()
    }
}

extension HashTagViewController: UICollectionViewDataSource {
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
}

extension HashTagViewController: UICollectionViewDelegateFlowLayout {
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

extension HashTagViewController {
    //MARK: - Get Posts
    private func getPostsWithHashTag() {
        hashTagService.fetchPostsWithHashTag(withHashTag: hashTag) { (key) in
            self.getPosts.observePostsToUser(withId: key, completionHandler: { (success, posts) in
                if success, let post = posts {
                    self.posts.append(post)
                    self.hashTagCollectionView.reloadData()
                }
            })
        }
    }
}

extension HashTagViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postID: String) {
        performSegue(withIdentifier: "Hashtag_Segue_Detail", sender: postID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Hashtag_Segue_Detail" {
            guard let detailsVC = segue.destination as? DetailViewController else { return }
            detailsVC.postID = sender as? String ?? ""
        }
    }
}
