//
//  ShareService.swift
//  AkGram
//
//  Created by Amg on 26/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ShareService {
    private init() {}
    static let shared = ShareService()
    
    //MARK: - Upload Posts
    //upload picture in database
    func sharePost(_ description: String, _ photoUrl: Data, onSuccess: @escaping (Bool) -> Void, OnError: @escaping (String?) -> Void) {
        let photoIDString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: idStorage).child("posts").child(photoIDString)
        storageRef.putData(photoUrl, metadata: nil, completion: { (_, error) in
            guard error == nil else {
                print("error upload image")
                OnError(error?.localizedDescription ?? "")
                onSuccess(false)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let photoUrl = url?.absoluteString, error == nil else {
                    print("error upload data in storage")
                    OnError(error?.localizedDescription ?? "")
                    onSuccess(false)
                    return
                }
                
                self.uploadPostsInStorage(description, photoUrl)
                onSuccess(true)
            })
        })
    }
    
    //Create dictionnary in database with data uploaded
    private func uploadPostsInStorage(_ description: String, _ photoUrl: String) {
        let newUserReference = refDatabase.child("posts")
        guard let newPostsID = newUserReference.childByAutoId().key else { return }
        newUidPostWhenShare = newPostsID
        let newPostReference = newUserReference.child(newPostsID)
        guard let currentUser = Auth.auth().currentUser else { return }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId ,"photoURL" : photoUrl, "descriptionPhoto": description, "idPost": newPostsID, "likeCount": 0]) { (error, reference) in
            guard error == nil else {
                print("error upload image and Description")
                return
            }
            
            refDatabase.child("feed").child(uidAccountUser).child(newPostsID).setValue(true)
            print("success to share post")
        }
    }
}
