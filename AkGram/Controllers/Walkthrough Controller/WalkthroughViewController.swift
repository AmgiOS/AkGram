//
//  WalkthroughViewController.swift
//  AkGram
//
//  Created by Amg on 27/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    //MARK: - Vars
    var index = 0
    var contentText = ""
    var backgroundImage = ""
    
    //MARK: - @IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - @IBAction
    @IBAction func slidePageButton(_ sender: Any) {
        switch index {
        case 0...1:
            guard let pageVC = parent as? WalkthroughPageViewController else {return}
            pageVC.forward(index: index)
        case 2:
            dismiss(animated: true, completion: nil)
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewviedWalkthrough")
        default:
            break
        }
    }
}

extension WalkthroughViewController {
    private func setUp() {
        backgroundImageView.image = UIImage(named: backgroundImage)
        contentLabel.text = contentText
        pageControl.currentPage = index
        switch index {
        case 0...1:
            nextButton.setImage(UIImage(named: "arrow"), for: .normal)
        case 2:
            nextButton.setImage(UIImage(named: "doneIcon-1"), for: .normal)
        default:
            break
        }
    }
}
