//
//  StructPost.swift
//  AkGram
//
//  Created by Amg on 01/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Get Post JSON
struct Post: Decodable {
    let descriptionPhoto: String
    let photoURL: String
    let uid: String
    let idPost: String
    var likeCount: Int?
    var likes: [String: Bool]?
    var isLiked: Bool {
        get {
            var like = Bool()
            if likes != nil {
                if likes?[uidAccountUser] != nil {
                    like = true
                } else {
                    like = false
                }
            }
            return like
        }
        set {}
    }
}

//MARK: - Get User Info JSON
struct User: Decodable {
    let email: String
    let profileImage: String
    let username: String
    let id: String?
    
    //Get Following in Database
    func isFollowing(uidUser: String, completionHandler: @escaping (Bool?) -> Void) {
        refFollowers.child(uidUser).child(uidAccountUser).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
    }
}

//MARK: - SetUp Id Post-Comment
struct Comment: Decodable {
    let commentText, uid: String
}
