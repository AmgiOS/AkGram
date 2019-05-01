//
//  MyPosts.swift
//  AkGram
//
//  Created by Amg on 29/04/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class MyPosts {
    let refDatabaseMyPosts = refDatabase.child("myPosts").child(uidAccountUser)
    let refPosts = refDatabase.child("posts")
    
    //MARK: - Functions
    func uploadRefMyPostsInDatabase() {
        refDatabaseMyPosts.child(newUidPostWhenShare).setValue(true) { (error, ref) in
            guard error == nil else {
                print("error upload post reference")
                return
            }
            print("success to share post with reference")
        }
    }
    
    func fetchMyPosts(completionHandler: @escaping (Bool, Post?) -> Void) {
        refDatabaseMyPosts.observe(.childAdded) { (snapshot) in
            
            let key = snapshot.key
            self.observePostsToUser(withId: key, completionHandler: { (success, posts) in
                if success, let post = posts {
                    completionHandler(true, post)
                } else {
                    completionHandler(false, nil)
                    print("error To Observe Posts to User")
                }
            })
        }
    }
    
    private func observePostsToUser(withId id: String, completionHandler: @escaping (Bool, Post?) -> Void) {
        refPosts.child(id).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value else { return }
            do {
                let data = try FirebaseDecoder().decode(Post.self, from: value)
                completionHandler(true, data)
            } catch {
                completionHandler(false, nil)
            }
        }
    }
}
