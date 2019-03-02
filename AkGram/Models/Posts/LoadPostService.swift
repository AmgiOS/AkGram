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
            guard let value = snapshot.value else { return}
            do {
                let data = try FirebaseDecoder().decode(Post.self, from: value)
                completionHandler(true, data)
            } catch {
                print("error decode data")
                completionHandler(false, nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
