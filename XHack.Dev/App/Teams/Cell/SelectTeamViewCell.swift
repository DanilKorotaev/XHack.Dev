//
//  SelectTeamViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class SelectTeamViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func set(_ model: ShortTeam) {
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl ?? "")
    }
}
