//
//  ActivityTableViewCell.swift
//  AkGram
//
//  Created by Amg on 24/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol ActivityTableViewCellDelegate {
    func goToDetailVC(postID: String)
    func goToProfileVC(userID: String)
}

class ActivityTableViewCell: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        GesturePhoto()
        GestureName()
    }

    //MARK: - Vars
    var posts = MyPosts()
    var delegate: ActivityTableViewCellDelegate?
    
    var notification: NotificationApi? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            updateViewUser()
        }
    }
}

extension ActivityTableViewCell {
    //MARK: - Update View Posts
    private func updateView() {
        guard let notification = notification else { return }
        switch notification.type {
        case "feed":
            descriptionLabel.text = "Added a new post"
        default:
            print("")
        }
        
        downloadPosts()
        calculDataToPost()
    }
    
    private func updateViewUser() {
        guard let user = user else { return }
        self.usernameLabel.text = user.username
        
        let image = URL(string: user.profileImage)
        self.profileImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
    }

    //MARK: - Date To post
    private func calculDataToPost() {
        if let timestamp = notification?.timestamp {
            let timestampData = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampData, to: now)
            
            var timeText = ""
            
            if let second = diff.second, second <= 0 {
                timeText = "Now"
            }
            
            if diff.second ?? 0 > 0 && diff.minute ?? 0 == 0 {
                timeText = "\(diff.second ?? 0)s"
            } else if diff.minute ?? 0 > 0 && diff.hour ?? 0 == 0 {
                timeText = "\(diff.minute ?? 0)min"
            } else if diff.hour ?? 0 > 0 && diff.day ?? 0 == 0 {
                timeText = "\(diff.hour ?? 0)hr"
            } else if diff.day ?? 0 > 0 && diff.weekOfMonth ?? 0 == 0 {
                timeText = "\(diff.day ?? 0)day"
            } else if diff.weekOfMonth ?? 0 > 0 {
                timeText = "\(diff.weekOfMonth ?? 0)wk"
            }
            
            timeLabel.text = timeText
        }
    }
    
    //MARK - Download Photo Post
    private func downloadPosts() {
        posts.observePostsToUser(withId: notification?.objectId ?? "") { (success, posts) in
            if success, let post = posts {
                let image = URL(string: post.photoURL)
                self.photoImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
            }
        }
    }
}

extension ActivityTableViewCell {
    //MARK: - TapGesturePhoto
    private func GesturePhoto( ) {
        photoImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapGesture))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func photoTapGesture() {
        delegate?.goToDetailVC(postID: notification?.objectId ?? "")
    }
    
    //MARK: - TapGestureRecongnizerName
    private func GestureName() {
        usernameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureName))
        usernameLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureName() {
        delegate?.goToProfileVC(userID: user?.id ?? "")
    }
}
