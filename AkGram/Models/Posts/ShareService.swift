//
//  ShareService.swift
//  AkGram
//
//  Created by Amg on 26/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ShareService {
    private init() {}
    static let shared = ShareService()
    
    //MARK: - Functions
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
            print(2)
            storageRef.downloadURL(completion: { (url, error) in
                guard let photoUrl = url?.absoluteString, error == nil else {
                    print("error upload data in storage")
                    OnError(error?.localizedDescription ?? "")
                    onSuccess(false)
                    return
                }
                print(3)
                self.uploadPostsInStorage(description, photoUrl)
                onSuccess(true)
            })
        })
    }
    
    private func uploadPostsInStorage(_ description: String, _ photoUrl: String) {
        let newUserReference = Database.database().reference().child("posts")
        guard let newPostsID = newUserReference.childByAutoId().key else { return }
        let newPostReference = newUserReference.child(newPostsID)
        guard let currentUser = Auth.auth().currentUser else { return }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId ,"photoURL" : photoUrl, "descriptionPhoto": description]) { (error, reference) in
            guard error == nil else {
                print("error upload image and Description")
                return
            }
            print("success to share post")
        }
    }
}
