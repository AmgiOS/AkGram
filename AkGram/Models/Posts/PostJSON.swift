//
//  StructPost.swift
//  AkGram
//
//  Created by Amg on 01/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation

//MARK: - SetUp UserInfo
struct Post: Decodable {
    let descriptionPhoto: String
    let photoURL: String
    let uid: String
    let idPost: String
    let likeCount: Int?
    let likes: [String: Bool]?
}

struct User: Decodable {
    let email: String
    let profileImage: String
    let username: String
}

//MARK: SetUp Id Post-Comment
struct Comment: Decodable {
    let commentText, uid: String
}

