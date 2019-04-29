//
//  CommentViewController.swift
//  AkGram
//
//  Created by Amg on 03/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    //MARK: - Vars
    var commentService = CommentService()
    var arrayComments = [Comment]()
    var idPost = String()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextField()
        keyboardWhenShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        downloadComment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - @IBAction
    @IBAction func sendCommentButton(_ sender: Any) {
        guard let commentText = commentTextField.text else { return }
        LoadingScreen()
        commentService.shareComment(idPost, commentText) { (success) in
            if success {
                self.dismissLoadingScreen()
                self.commentTextField.text = ""
                self.sendCommentButton.isEnabled = false
                self.view.endEditing(true)
            }
        }
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.comment = arrayComments[indexPath.row]
        cell.commentVC = self
        
        return cell
    }
    
}

extension CommentViewController {
    //MARK: - Functions
    private func handleTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            sendCommentButton.setTitleColor(UIColor.lightGray, for: .normal)
            sendCommentButton.isEnabled = false
            return
        }
        sendCommentButton.setTitleColor(UIColor.black, for: .normal)
        sendCommentButton.isEnabled = true
    }
    
    private func downloadComment() {
        commentService.downloadCommentInPostId(idPost) { (success, comments) in
            if success, let comment = comments {
                self.arrayComments.append(comment)
                self.commentTableView.reloadData()
            }
        }
    }
}

extension CommentViewController {
    //MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWhenShow() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardScreenEndFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            UIView.animate(withDuration: 0.3) {
                self.constraintToBottom.constant = -keyboardScreenEndFrame.height
                self.view.layoutIfNeeded()
            }
        } else {
            constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
