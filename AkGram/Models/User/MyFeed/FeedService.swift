//
//  FeedService.swift
//  AkGram
//
//  Created by Amg on 11/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Feed {
    var refFeed = Database.database().reference().child("feed")
    let postService = MyPosts()
    
    //MARK: - Observe my Feed
    func uploadFeed(completionHandler: @escaping (Bool, Post?) -> Void) {
        refFeed.child(uidAccountUser).observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            self.postService.observePostsToUser(withId: key, completionHandler: { (success, posts) in
                if success, let post = posts {
                    completionHandler(true, post)
                } else {
                    print("error to get my feed")
                }
            })
        }
    }
    
    //Remove My feed if he not follow
    func observeRemoveFeed(completionHandler: @escaping (Bool, Post?) -> Void) {
        refFeed.child(uidAccountUser).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key
            self.postService.observePostsToUser(withId: key, completionHandler: { (success, posts) in
                if success, let post = posts {
                    completionHandler(true, post)
                } else {
                    print("error to get my feed")
                }
            })
        }
    }
}
