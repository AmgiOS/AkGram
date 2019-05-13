//
//  FollowService.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

class FollowService {
    //MARK: - Vars
    var refFollowers = refDatabase.child("followers")
    var refFollowing = refDatabase.child("following")
    
    //MARK: - Functions
    //Follow Upload in Database
    func followUploadInDatabase() {
        refDatabase.child("myPosts").child(uidUserFollow).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            for key in value.keys {
                refDatabase.child("feed").child(uidAccountUser).child(key).setValue(true)
            }
        }
        refFollowers.child(uidUserFollow).child(uidAccountUser).setValue(true)
        refFollowing.child(uidAccountUser).child(uidUserFollow).setValue(true)
    }
    
    //Unfollow Upload in Database
    func unFollowUploadInDatabase() {
        refDatabase.child("myPosts").child(uidUserFollow).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any], !value.isEmpty {
                for key in value.keys {
                    if key != "" {
                      refDatabase.child("feed").child(uidAccountUser).child(key).removeValue()
                    }
                }
            }
        }
        refFollowers.child(uidUserFollow).child(uidAccountUser).setValue(NSNull())
        refFollowing.child(uidAccountUser).child(uidUserFollow).setValue(NSNull())
    }
}
