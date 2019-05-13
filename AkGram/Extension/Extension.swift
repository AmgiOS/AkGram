//
//  Extension.swift
//  AkGram
//
//  Created by Amg on 22/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    //MARK: - UITextField
    func setUpTextField(_ textfield: UITextField) {
        guard let text = textfield.placeholder else { return }
        textfield.tintColor = UIColor.white
        textfield.backgroundColor = UIColor.clear
        textfield.textColor = UIColor.white
        textfield.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        textfield.layer.addSublayer(bottomLayer)
    }
    
    //MARK: - JGProgressHUD
    static let hud = JGProgressHUD(style: .dark)
    
    func LaunchScreen() {
        let hud = JGProgressHUD(style: .dark)
        hud.tintColor = UIColor.white
        hud.textLabel.text = "Loading ..."
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func errorScreen(_ text: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDErrorIndicatorView(contentView: self.view)
        hud.tintColor = UIColor.red
        hud.textLabel.text = text
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func successScreen() {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
        hud.tintColor = UIColor.green
        hud.textLabel.text = "Success"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func connectedScreen() {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
        hud.tintColor = UIColor.green
        hud.textLabel.text = "Connected"
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func LoadingScreen() {
        UIViewController.hud.tintColor = UIColor.white
        UIViewController.hud.textLabel.text = "Loading ..."
        UIViewController.hud.show(in: self.view)
    }
    
    func dismissLoadingScreen() {
        UIViewController.hud.dismiss(afterDelay: 1.0)
    }
}
