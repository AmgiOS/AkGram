//
//  SignUpService.swift
//  AkGram
//
//  Created by Amg on 24/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpService {
    
    //MARK: - Functions
    func signUp(_ username: String, _ email: String, _ password: String, _ imageJPEG: Data, onSuccess: @escaping (Bool) -> Void, OnError: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user?.user.uid, error == nil else {
                OnError(error?.localizedDescription ?? "")
                onSuccess(false)
                return
            }
            
            let storageRef = Storage.storage().reference(forURL: idStorage).child("profile_image").child(user)
            storageRef.putData(imageJPEG, metadata: nil, completion: { (_, error) in
                guard error == nil else {
                    print("error upload image")
                    OnError(error?.localizedDescription ?? "")
                    onSuccess(false)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    guard let urlImage = url?.absoluteString, error == nil else {
                        print("error upload data in storage")
                        OnError(error?.localizedDescription ?? "")
                        onSuccess(false)
                        return
                    }
                    
                    self.uploadDataInStorage(user: user, username, email, urlImage, user)
                    onSuccess(true)
                })
            })
        }
    }
    
    private func uploadDataInStorage(user: String, _ username: String, _ email: String, _ profileImage: String, _ id: String) {
        let newUserReference = Database.database().reference().child("users").child(user)
        newUserReference.setValue(["username" : username, "username_lowercase": username.lowercased(), "email": email, "profileImage": profileImage, "id": id])
    }
}
