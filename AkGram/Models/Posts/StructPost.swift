//
//  StructPost.swift
//  AkGram
//
//  Created by Amg on 01/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let descriptionPhoto: String
    let photoURL: String
}

struct User: Decodable {
    let email: String
    let profileImage: String
    let username: String
}
