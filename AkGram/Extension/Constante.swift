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

//Id Storage path for Firebase
let idStorage = "gs://akgram-31c3b.appspot.com"

//Reference to Realtime Database For Get Data
let refDatabase = Database.database().reference()

//Uid to current User
let uidAccountUser = Auth.auth().currentUser?.uid ?? ""

//New Uid When post is Share in Home
var newUidPostWhenShare = ""

//Get Uid User Index Path
var uidUserFollow = ""
