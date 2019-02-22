//
//  Extension.swift
//  AkGram
//
//  Created by Amg on 22/02/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

extension UIViewController {
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
}
