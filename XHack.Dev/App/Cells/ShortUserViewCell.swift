//
//  ShortUserViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class ShortUserViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private(set) var model: ShortUser!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    func set(for model: ShortUser) {
        self.model = model
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl, placeholder: "no_avatar")
    }
}
