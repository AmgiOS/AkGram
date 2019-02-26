//
//  SignInService.swift
//  AkGram
//
//  Created by Amg on 25/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInService {
    
    //MARK: Functions
    func signIn(_ email: String, _ password: String, onSuccess: @escaping (Bool) -> Void, OnError: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user, user.user.email != nil , error == nil else {
                print(error?.localizedDescription ?? "")
                OnError(error?.localizedDescription ?? "")
                onSuccess(false)
                return
            }
            onSuccess(true)
        }
    }
    
    func checkIfUserIsAlreadyOnline(completion: @escaping (Bool) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(false)
            return
        }
        completion(true)
    }
}
