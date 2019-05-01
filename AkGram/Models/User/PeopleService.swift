//
//  People.swift
//  AkGram
//
//  Created by Amg on 01/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

class PeopleService {
    //MARK: - Vars
    var getAllUsers = refDatabase.child("users")
    
    //MARK: - Functions
    //Get All People in Database
    func getAllPeople(completionHandler: @escaping (Bool, User?, String) -> Void) {
        getAllUsers.observe(.childAdded) { (snapshot) in
            guard let value = snapshot.value else { return }
            
            do {
                let data = try FirebaseDecoder().decode(User.self, from: value)
                completionHandler(true, data, snapshot.key)
            } catch {
                completionHandler(false, nil, "")
                print("Error to download All Users")
            }
        }
    }
}
