//
//  SignInViewController.swift
//  AkGram
//
//  Created by Amg on 18/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(emailTextfield)
        setUpTextField(passwordTextfield)
    }
    
    //MARK: - @IBAction
    
}

extension SignInViewController {
    //MARK: - Functions
    
}
