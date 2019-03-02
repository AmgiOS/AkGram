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
    
    //MARK: - Functions
    func reloadPosts(completionHandler: @escaping (Bool, Post?) -> Void) {
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
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
    
    func setUpUserInfo(_ currentUser: String, completionHandler: @escaping (Bool, User?) -> Void) {
        Database.database().reference().child("users").child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                guard let value = snapshot.value else { return}
                do {
                    let data = try FirebaseDecoder().decode(User.self, from: value)
                    completionHandler(true, data)
                } catch {
                    print("error decode data")
                    completionHandler(false, nil)
                }
            }
        }
    }
}
