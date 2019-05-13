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
                if data.id != uidAccountUser {
                   completionHandler(true, data, snapshot.key)
                }
            } catch {
                completionHandler(false, nil, "")
                print("Error to download All Users")
            }
        }
    }
    
    func queryUsers(withText text: String, completionHandler: @escaping (Bool, User?, String) -> Void) {
        getAllUsers.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach({ (value) in
                guard let values = value as? DataSnapshot else { return }
                
                do {
                    let data = try FirebaseDecoder().decode(User.self, from: values.value ?? "")
                    print(data)
                    completionHandler(true, data, values.key)
                } catch {
                    completionHandler(false, nil, "")
                    print("Error to Search Name Users")
                }
            })
        }
    }
}
