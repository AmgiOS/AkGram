//
//  HomeViewController.swift
//  AkGram
//
//  Created by Amg on 19/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Vars

    //MARK: - @IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingScreen()
        connectedScreen()
    }
    
    //MARK: - @IBAction
    @IBAction func logOutButton(_ sender: Any) {
        LogOutService.shared.logOut()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
}
