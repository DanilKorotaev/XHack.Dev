//
//  ShortTeamViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class ShortTeamViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    func set(for model: ShortTeam) {
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl, placeholder: "no_group_avatar")
    }

}
