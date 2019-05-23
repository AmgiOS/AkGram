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
    
    //MARK: - Upload Image
    //upload picture in database
    func sharePost(_ description: String, _ data: Data,_ videoURL: URL? = nil, onSuccess: @escaping (Bool) -> Void, OnError: @escaping (String?) -> Void) {
        if let videoURL = videoURL {
            self.uploadVideoToFirebaseStorage(videoURL) { (urlVideo) in
                self.uploadImageToFirebaseStorage(data: data, onSuccess: { (imageURL) in
                    self.uploadPostsInStorage(description, imageURL, urlVideo, onSuccess: onSuccess, OnError: OnError)
                })
            }
        } else {
            uploadImageToFirebaseStorage(data: data) { (photoURL) in
                self.uploadPostsInStorage(description, photoURL, onSuccess: onSuccess, OnError: OnError)
            }
        }
    }
    
    private func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageURL: String) -> Void) {
        let photoIDString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: idStorage).child("posts").child(photoIDString)
        
        storageRef.putData(data, metadata: nil, completion: { (_, error) in
            guard error == nil else {
                print("error upload image")
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let photoUrl = url?.absoluteString, error == nil else {
                    print("error upload data in storage")
                    return
                }
                
                onSuccess(photoUrl)
            })
        })
    }
    
    //Create dictionnary in database with data uploaded
    private func uploadPostsInStorage(_ description: String, _ photoUrl: String,_ videoURL: String? = nil, onSuccess: @escaping (Bool) -> Void, OnError: @escaping (String?) -> Void) {
        let newUserReference = refDatabase.child("posts")
        
        guard let newPostsID = newUserReference.childByAutoId().key else { return }
        newUidPostWhenShare = newPostsID
        
        let newPostReference = newUserReference.child(newPostsID)
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let currentUserId = currentUser.uid
        
        let words = description.components(separatedBy:  .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                let newHashTagRef = refDatabase.child("hashTag").child(word.lowercased())
                newHashTagRef.updateChildValues([newPostsID: true])
            }
        }
        
        let timestamp = Int(Date.timeIntervalBetween1970AndReferenceDate)
        
        
        var dict = ["uid": currentUserId ,"photoURL" : photoUrl, "descriptionPhoto": description, "idPost": newPostsID, "likeCount": 0, "timestamp": timestamp] as [String : Any]
        if let videoUrl = videoURL {
            dict["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(dict) { (error, reference) in
            guard error == nil else {
                print("error upload image and Description")
                OnError(error?.localizedDescription)
                onSuccess(false)
                return
            }
            
            onSuccess(true)
            refDatabase.child("feed").child(uidAccountUser).child(newPostsID).setValue(true)
            print("success to share post")
        }
    }
}

extension ShareService {
    //MARK: - Upload Video in Database
    private func uploadVideoToFirebaseStorage(_ videoURL: URL, onSuccess: @escaping (_ imageURL: String) -> Void) {
        let videoIDString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: idStorage).child("posts").child(videoIDString)
        
        storageRef.putFile(from: videoURL, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("error upload image")
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let videoUrl = url?.absoluteString, error == nil else {
                    print("error upload data in storage")
                    return
                }
                onSuccess(videoUrl)
            })
        }
    }
}
