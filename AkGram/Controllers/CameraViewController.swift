//
//  CameraViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    //MARK: - Vars
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var selectedVideoURL: URL?
    var myPosts = MyPosts()

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
        guard let imageJPEG = UIImage.jpegData(image)(compressionQuality: 1.0) else {return}
        LoadingScreen()
        ShareService.shared.sharePost(text, imageJPEG,selectedVideoURL, onSuccess: { (success) in
            if success {
                self.myPosts.uploadRefMyPostsInDatabase()
                self.dismissLoadingScreen()
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
        //Select Photo
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            photoImageView.image = originalImage
            selectedImage = originalImage
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "Camera_FilterSegue", sender: originalImage)
            }
            
            //Select Video
        } else if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            guard let thumbnailImage = thumbnailImageForfileUrl(video) else { return }
            selectedImage = thumbnailImage
            photoImageView.image = thumbnailImage
            selectedVideoURL = video
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController {
    //MARK: - Tap Gesture photo and Configure
    private func ProfilePhoto() {
        imagePicker.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesturePicture))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesturePicture() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true, completion: nil)
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
}

extension CameraViewController {
    //MARK: - Configure Video
    private func thumbnailImageForfileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 10), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Camera_FilterSegue" {
            guard let filterVC = segue.destination as? FilterViewController else { return }
            filterVC.filterImage = sender as? UIImage ?? UIImage()
            filterVC.delegate = self
        }
    }
}

extension CameraViewController: FilterViewControllerDelegate {
    //MARK: - Update Photo Protocol
    func updatePhoto(_ imageFilter: UIImage) {
        photoImageView.image = imageFilter
        selectedImage = imageFilter
    }
}
