//
//  SignUpViewController.swift
//  AkGram
//
//  Created by Amg on 18/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(usernameTextField)
        setUpTextField(emailTextField)
        setUpTextField(passwordTextField)
    }
    
    //MARK: - @IBAction
    @IBAction func dissmissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpbutton(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        signUp(email, password)
    }
}

extension SignUpViewController {
    //MARK: -Functions
    private func signUp(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user, error != nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }
}
