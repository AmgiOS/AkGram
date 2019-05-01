//
//  FollowService.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowService {
    //MARK: - Vars
    var refFollowers = refDatabase.child("followers")
    var refFollowing = refDatabase.child("following")
    
    //MARK: - Functions
    //Follow Upload in Database
    func followUploadInDatabase() {
        refFollowers.child(uidUserFollow).child(uidAccountUser).setValue(true)
        refFollowing.child(uidAccountUser).child(uidUserFollow).setValue(true)
    }
    
    //Unfollow Upload in Database
    func unFollowUploadInDatabase() {
        refFollowers.child(uidUserFollow).child(uidAccountUser).setValue(NSNull())
        refFollowing.child(uidAccountUser).child(uidUserFollow).setValue(NSNull())
    }
}
