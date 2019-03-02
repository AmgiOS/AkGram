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

    //MARK: - @IBOutlet
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - @IBAction
    @IBAction func segueButton(_ sender: Any) {
        
    }
}
