//
//  Constante.swift
//  AkGram
//
//  Created by Amg on 01/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

let idStorage = "gs://akgram-31c3b.appspot.com"
let refDatabase = Database.database().reference()
let uidAccountUser = Auth.auth().currentUser?.uid ?? ""
