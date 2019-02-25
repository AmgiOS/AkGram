//
//  SignInViewController.swift
//  AkGram
//
//  Created by Amg on 18/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    //MARK: - Vars
    let signInService = SignInService()

    //MARK: - @IBOutlet
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(emailTextfield)
        setUpTextField(passwordTextfield)
        handleTextField()
    }
    
    //MARK: - @IBAction
    @IBAction func signInButton(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else { return }
        signInService.signIn(email, password) { (success) in
            if success {
                self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
            } else {
                print("error identification")
            }
        }
    }
    
}

extension SignInViewController {
    //MARK: - Functions
    private func handleTextField() {
        emailTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextfield.text, !email.isEmpty, let password = passwordTextfield.text, !password.isEmpty else {
            signInButton.setTitleColor(UIColor.lightGray, for: .normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.isEnabled = true
    }
}
