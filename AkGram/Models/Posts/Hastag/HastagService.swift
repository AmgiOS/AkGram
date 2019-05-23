//
//  HastagService.swift
//  AkGram
//
//  Created by Amg on 20/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HastagService {
    //MARK: - Vars
    var ref_hashTag = refDatabase.child("hashTag")
    
    //MARK: - Get Key Posts to Hashtags
    func fetchPostsWithHashTag(withHashTag tag: String, completion: @escaping (String) -> Void) {
        ref_hashTag.child(tag.lowercased()).observe(.childAdded) { (snapshot) in
            print(snapshot.key)
            completion(snapshot.key)
        }
    }
}
