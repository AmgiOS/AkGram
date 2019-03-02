//
//  CameraViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    //MARK: - Vars
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?

    //MARK: - @IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePhoto()
        clean()
    }
    
    //MARK: - @IBAction
    @IBAction func sharePostButton(_ sender: Any) {
        guard let text = captionTextView.text else { return }
        guard let image = selectedImage else { return }
        guard let imageJPEG = UIImage.jpegData(image)(compressionQuality: 0.1) else {return}
        LoadingScreen()
        ShareService.shared.sharePost(text, imageJPEG, onSuccess: { (success) in
            if success {
                self.successScreen()
                self.allResetAfterPost()
            }
        }) { (error) in
            self.errorScreen("Failed shared Posts")
        }
    }
    @IBAction func removeButton(_ sender: Any) {
        captionTextView.text = ""
        photoImageView.image = UIImage(named: "Placeholder-image")
        selectedImage = nil
        handlePhoto()
        clean()
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = originalImage
        selectedImage = originalImage
        dismiss(animated: true, completion: nil)
    }
    
    private func ProfilePhoto() {
        imagePicker.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesturePicture))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesturePicture() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension CameraViewController {
    //MARK: - Functions
    private func allResetAfterPost() {
        captionTextView.text = ""
        photoImageView.image = UIImage(named: "Placeholder-image")
        selectedImage = nil
        tabBarController?.selectedIndex = 0
    }
    
    private func handlePhoto() {
        if selectedImage != nil {
            shareButton.isEnabled = true
            shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor.lightGray
        }
    }
    
    private func clean() {
        if selectedImage == nil {
            removeButton.isEnabled = false
        } else {
            removeButton.isEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
