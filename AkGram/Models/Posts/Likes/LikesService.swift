//
//  LikesService.swift
//  AkGram
//
//  Created by Amg on 05/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class LikesService {
    
    //MARK: - Upload Likes in Database
    func downloadLikesInPosts(_ postsId: String, completionHandler: @escaping (Bool, Post?) -> Void) {
        DispatchQueue.main.async {
            refDatabase.child("posts").child(postsId).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                    var likes: Dictionary<String, Bool>
                    likes = post["likes"] as? [String : Bool] ?? [:]
                    var likeCount = post["likeCount"] as? Int ?? 0
                    if let _ = likes[uid] {
                        // Unstar the post and remove self from likes
                        likeCount -= 1
                        likes.removeValue(forKey: uid)
                    } else {
                        // Star the post and add self to likes
                        likeCount += 1
                        likes[uid] = true
                    }
                    post["likeCount"] = likeCount as AnyObject?
                    post["likes"] = likes as AnyObject?
                    
                    // Set value and report transaction success
                    currentData.value = post
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let value = snapshot?.value else { return }
                guard let postJSON = try? FirebaseDecoder().decode(Post.self, from: value) else { return }
                completionHandler(true, postJSON)
            }
        }
    }
    
    //Reload Data in Realtime When likes count change
    func reloadLikesPosts(_ uid: String, completionHandler: @escaping (Int) -> Void) {
        refDatabase.child("posts").child(uid).observe(.childChanged) { (snapshot) in
            guard let value = snapshot.value as? Int else { return }
            completionHandler(value)
        }
    }
}
