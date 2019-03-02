//
//  CommentTableViewCell.swift
//  AkGram
//
//  Created by Amg on 03/03/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
