//
//  HackTeamViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackTeamViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var countMembersLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func set(_ model: Team) {
        avatarImageView.downloaded(from: model.avatarUrl ?? "", placeholder: "no_group_avatar")
        nameLabel.text = model.name
        countMembersLabel.text = "Participants: \(model.members.count)"
        descriptionLabel.text = model.description
    }
}
