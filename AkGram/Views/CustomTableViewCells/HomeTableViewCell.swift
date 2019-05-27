//
//  HomeTableViewCell.swift
//  AkGram
//
//  Created by Amg on 02/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import KILabel

//MARK: - Protocol
protocol HomeTableViewCellDelegate {
    func commentToSegue(postId: String)
    func goToProfileUser(userUid: String)
    func goToHashTag(tag: String)
}

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: KILabel!
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var volumeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        GestureComment()
        GestureLike()
        GestureName()
        gesturePostsVideo()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        captionLabel.text = "Added comment ..."
        volumeView.isHidden = true
        playerLayer?.removeFromSuperlayer()
        playerVideo?.pause()
    }
    
    //MARK: - @IBAction
    @IBAction func volumeActionbutton(_ sender: UIButton) {
        if isMuted {
            isMuted = !isMuted
            sender.setImage(UIImage(named: "Icon_Volume"), for: .normal)
        } else {
            isMuted = !isMuted
            sender.setImage(UIImage(named: "Icon_Mute"), for: .normal)
        }
        playerVideo?.isMuted = isMuted
    }
    
    //MARK: - Vars
    var delegate: HomeTableViewCellDelegate?
    var homeVC: HomeViewController?
    var likesService = LikesService()
    var peopleUser = PeopleService()
    
    var playerVideo: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isMuted = true
    
    var post: Post? {
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

extension HomeTableViewCell {
    //MARK: - Update View Posts
    private func updateView() {
        guard let post = post else { return }
        
        captionLabel.text = post.descriptionPhoto
        captionLabel.hashtagLinkTapHandler = { label, string, range in
            let tag = String(string.dropFirst())
            self.delegate?.goToHashTag(tag: tag)
        }
        
        captionLabel.userHandleLinkTapHandler = { label, string, range in
            let mention = String(string.dropFirst())
            self.peopleUser.getUserByUsername(username: mention, completionHandler: { (success, users) in
                if success, let user = users {
                    self.delegate?.goToProfileUser(userUid: user.id ?? "")
                }
            })
        }
        
        let image = URL(string: post.photoURL)
        postImageView.sd_setImage(with: image, completed: nil)
        
        postVideo()
        calculDataToPost()
        getLikesInDatabase(post)
    }
    
    private func updateViewUser() {
        guard let user = user else { return }
        self.nameLabel.text = user.username
        
        let image = URL(string: user.profileImage)
        self.profileImageview.sd_setImage(with: image, placeholderImage: UIImage(named: "placeholderImg"), options: .continueInBackground, progress: nil, completed: nil)
    }
    
    //MARK: - Likes
    private func getLikesInDatabase(_ post: Post) {
        let imageName = post.likes == nil || !post.isLiked ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        if let likeCount = post.likeCount, likeCount != 0 {
            likeCountButton.setTitle("\(likeCount) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the First like this", for: .normal)
        }
    }
    
    //MARK: - Post Video
    private func postVideo() {
        if let videoURL = post?.videoUrl {
            guard let video = URL(string: videoURL) else { return }
            volumeView.isHidden = false
            playerVideo = AVPlayer(url: video)
            playerLayer = AVPlayerLayer(player: playerVideo)
            playerLayer?.frame = postImageView.frame
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            self.contentView.layer.addSublayer(playerLayer ?? AVPlayerLayer())
            volumeView.layer.zPosition = 1
            playerVideo?.play()
            playerVideo?.isMuted = isMuted
        }
    }
    
    //MARK: - Date To post
    private func calculDataToPost() {
        if let timestamp = post?.timestamp {
            let timestampData = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampData, to: now)
            
            var timeText = ""
            
            if let second = diff.second, second <= 0 {
                timeText = "Now"
            }
            
            if diff.second ?? 0 > 0 && diff.minute ?? 0 == 0 {
                timeText = (diff.second ?? 0 == 1) ? "\(diff.second ?? 0 ) second ago" : "\(diff.second ?? 0) seconds ago"
            } else if diff.minute ?? 0 > 0 && diff.hour ?? 0 == 0 {
                timeText = (diff.minute ?? 0 == 1) ? "\(diff.minute ?? 0 ) minute ago" : "\(diff.minute ?? 0) minutes ago"
            } else if diff.hour ?? 0 > 0 && diff.day ?? 0 == 0 {
                timeText = (diff.hour ?? 0 == 1) ? "\(diff.hour ?? 0 ) hour ago" : "\(diff.hour ?? 0) hours ago"
            } else if diff.day ?? 0 > 0 && diff.weekOfMonth ?? 0 == 0 {
                timeText = (diff.day ?? 0 == 1) ? "\(diff.day ?? 0 ) day ago" : "\(diff.day ?? 0) days ago"
            } else if diff.weekOfMonth ?? 0 > 0 {
                timeText = (diff.weekOfMonth ?? 0 == 1) ? "\(diff.weekOfMonth ?? 0 ) week ago" : "\(diff.weekOfMonth ?? 0) weeks ago"
            }
            
            timestampLabel.text = timeText
        }
    }
}

extension HomeTableViewCell {
    //MARK: - TapGestureRecognizerComment
    private func GestureComment( ) {
        commentImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        commentImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesture() {
        delegate?.commentToSegue(postId: post?.idPost ?? "")
    }
    
    //MARK: - TapGestureRecognizerLike
    private func GestureLike( ) {
        likeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureLike))
        likeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureLike() {
        guard let postIndex = post else { return }
        likesService.downloadLikesInPosts(postIndex.idPost) { (success, posts) in
            if success, let post = posts {
                self.getLikesInDatabase(post)
                guard let indexPath = self.homeVC?.postsTableView.indexPath(for: self) else { return }
                self.homeVC?.postData[indexPath.row] = post
            }
        }
    }
    
    //MARK: - TapGestureRecongnizerName
    private func GestureName() {
        nameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureName))
        nameLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGestureName() {
        delegate?.goToProfileUser(userUid: user?.id ?? "")
    }
    
    //MARK: - TapGestureRecongnizerPostVideo
    private func gesturePostsVideo() {
        postImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesturePostsVideo))
        postImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesturePostsVideo() {
        if isMuted {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "Icon_Volume"), for: .normal)
        } else {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "Icon_Mute"), for: .normal)
        }
        playerVideo?.isMuted = isMuted
    }
}

