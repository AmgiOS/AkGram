//
//  NotificationService.swift
//  AkGram
//
//  Created by Amg on 26/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import Foundation
import CodableFirebase

class NotificationService {
    //MARK: - Vars
    var ref_notification = refDatabase.child("notification")
    
    //MARK: - Get notification in Database
    func uploadNotification(completionHandler: @escaping (Bool, NotificationApi?, String) -> Void) {
        ref_notification.child(uidAccountUser).observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            do {
                let data = try FirebaseDecoder().decode(NotificationApi.self, from: dict)
                completionHandler(true, data, snapshot.key)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
