//
//  logOutService.swift
//  AkGram
//
//  Created by Amg on 25/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogOutService {
    private init() {}
    static let shared = LogOutService()
    
    //MARK: - Functions
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
