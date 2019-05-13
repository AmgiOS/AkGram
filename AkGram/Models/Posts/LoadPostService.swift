//
//  LoadPostService.swift
//  AkGram
//
//  Created by Amg on 01/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class LoadPostService {
    
    //MARK: - Download Posts
    //Get data in post in database
    func reloadPosts(completionHandler: @escaping (Bool, Post?) -> Void) {
        refDatabase.child("posts").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
                guard let value = snapshot.value else { return}
                do {
                    let data = try FirebaseDecoder().decode(Post.self, from: value)
                    completionHandler(true, data)
                } catch {
                    print("error decode data")
                    completionHandler(false, nil)
                }
            }
        })
    }
    
    //Get recents Post in Discover
    func observeTopPosts(completionHandler: @escaping (Bool, Post?) -> Void) {
        refDatabase.child("posts").queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value) { (snapshot) in
            guard let arraySnaphot = (snapshot.children.allObjects as? [DataSnapshot])?.reversed() else { return }
            arraySnaphot.forEach({ (child) in
                do {
                    let data = try FirebaseDecoder().decode(Post.self, from: child.value ?? "")
                    completionHandler(true, data)
                } catch {
                    print("error decode data")
                    completionHandler(false, nil)
                }
            })
        }
    }
    
    //Get User info in each post
    func setUpUserInfo(_ currentUser: String, completionHandler: @escaping (Bool, User?) -> Void) {
        refDatabase.child("users").child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                guard let value = snapshot.value else { return}
                
                do {
                    let data = try FirebaseDecoder().decode(User.self, from: value)
                    completionHandler(true, data)
                } catch {
                    print("error decode data User Home")
                    completionHandler(false, nil)
                }
            }
        }
    }
}
