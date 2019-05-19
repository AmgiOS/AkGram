//
//  SettingsTableViewController.swift
//  AkGram
//
//  Created by Amg on 17/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingsTableViewController: UITableViewController {
    
    //MARK: - Vars
    var loadUserInfo = LoadPostService()
    let signUpService = SignUpService()
    let imagePicker = UIImagePickerController()
    var delegate: SettingsTableViewControllerDelegate?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        fetchUserInfo()
        setUp()
    }
    
    //MARK: - @IBAction
    @IBAction func saveInfoButton(_ sender: Any) {
        replaceInfoUser()
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        LogOutService.shared.logOut()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    @IBAction func changeProfileImageView(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension SettingsTableViewController {
    //MARK: - Functions
    
    private func setUp() {
        imagePicker.delegate = self
        usernameTextFiled.delegate = self
        emailTextField.delegate = self
    }
    
    //Get User Info
    private func fetchUserInfo() {
        loadUserInfo.setUpUserInfo(uidAccountUser) { (success, users) in
            if success, let user = users {
                guard let url = URL(string: user.profileImage) else { return }
                guard let image = try? Data(contentsOf: url) else { return }
                self.profileImageView.image = UIImage(data: image)
                self.usernameTextFiled.text = user.username
                self.emailTextField.text = user.email
            }
        }
    }
    
    private func replaceInfoUser() {
        guard let username = usernameTextFiled.text, let email = emailTextField.text else { return }
        guard let imageJPEG = UIImage.jpegData(self.profileImageView.image ?? UIImage())(compressionQuality: 0.1) else { return }
        LoadingScreen()

        signUpService.updateUserInfo(username, email, imageJPEG, onSuccess: { (success) in
            if success {
                self.dismissLoadingScreen()
                self.successScreen()
                self.delegate?.updateUserInfo()
            }
        }) { (error) in
            self.dismissLoadingScreen()
            self.errorScreen(error ?? "")
        }
        
    }
}

extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        profileImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsTableViewController: UITextFieldDelegate {
    //MARK: - KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextFiled.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
}
