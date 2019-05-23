//
//  CommentService.swift
//  AkGram
//
//  Created by Amg on 04/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import CodableFirebase
import FirebaseDatabase
import FirebaseAuth

class CommentService {
    //MARK: - UploadComment
    func shareComment(_ idPost: String, _ comment: String, completionHandler: @escaping (Bool) -> Void) {
        let newUserReference = Database.database().reference().child("comments")
        guard let newCommentID = newUserReference.childByAutoId().key else { return }
        let newCommentReference = newUserReference.child(newCommentID)
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let words = comment.components(separatedBy:  .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                let newHashTagRef = refDatabase.child("hashTag").child(word.lowercased())
                newHashTagRef.updateChildValues([idPost: true])
            }
        }
        
        newCommentReference.setValue(["uid": currentUserId ,"commentText" : comment]) { (error, reference) in
            guard error == nil else {
                print("error upload image and Description")
                completionHandler(false)
                return
            }
            print("success to share post")
            completionHandler(true)
            self.sharePostCommentId(idPost, newCommentID)
        }
    }
    
    //Added id User in comment when share comment
    func sharePostCommentId(_ uid: String, _ commentID: String) {
        let postCommentRef = Database.database().reference().child("post-comments").child(uid).child(commentID)
        
        postCommentRef.setValue(true) { (error, ref) in
            guard error == nil else {
                print("error upload post commentID")
                return
            }
            print("success to share post-commentsID")
        }
    }
}

extension CommentService {
    //MARK: - DownloadService
    func downloadCommentInPostId(_ currentUser: String, completionHandler: @escaping (Bool, Comment?) -> Void) {
        refDatabase.child("post-comments").child(currentUser).observe(.childAdded) { (snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.key
                self.downloadCommentWithId(value, completionHandler: { (success, comments) in
                    if success, let comment = comments {
                        completionHandler(true, comment)
                    } else {
                        completionHandler(false, nil)
                    }
                })
            }
        }
    }
    
    private func downloadCommentWithId(_ key: String, completionHandler: @escaping (Bool, Comment?) -> Void) {
        refDatabase.child("comments").child(key).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                guard let value = snapshot.value else { return}
                do {
                    let data = try FirebaseDecoder().decode(Comment.self, from: value)
                    completionHandler(true, data)
                } catch {
                    completionHandler(false, nil)
                }
            }
        }
    }
}

