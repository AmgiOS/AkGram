//
//  SignUpViewController.swift
//  AkGram
//
//  Created by Amg on 18/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    //MARK: - Vars
    let signUpService = SignUpService()
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()

    //MARK: - @IBOutlet
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - @IBAction
    @IBAction func dissmissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpbutton(_ sender: Any) {
        guard let username = usernameTextField.text, let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let imageJPEG = UIImage.jpegData(selectedImage)(compressionQuality: 0.1)
        LoadingScreen()
        
        signUpService.signUp(username, email, password, imageJPEG ?? Data(), onSuccess: { (success) in
            if success {
                self.dismissLoadingScreen()
                self.successScreen()
                self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
            }
        }) { (error) in
            self.errorScreen(error ?? "")
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectedImage = originalImage
        pictureImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
    
    private func ProfilePhoto() {
        imagePicker.delegate = self
        pictureImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesturePicture))
        pictureImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapGesturePicture() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    //MARK: - Functions
    private func setUp() {
        setUpTextField(usernameTextField)
        setUpTextField(emailTextField)
        setUpTextField(passwordTextField)
        ProfilePhoto()
        handleTextField()
    }
    
    private func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightGray, for: .normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
