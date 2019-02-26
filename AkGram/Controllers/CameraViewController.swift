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
    var selectedImage = UIImage()

    //MARK: - @IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePhoto()
    }
    
    //MARK: - @IBAction
    @IBAction func sharePostButton(_ sender: Any) {
        guard let text = captionTextView.text else { return }
        let imageJPEG = UIImage.jpegData(selectedImage)(compressionQuality: 0.1)
        LoadingScreen()
        ShareService.shared.sharePost(text, imageJPEG ?? Data(), onSuccess: { (success) in
            if success {
                print("share posts in database")
                self.successScreen()
            }
        }) { (error) in
            self.errorScreen("Failed shared Posts")
        }
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
