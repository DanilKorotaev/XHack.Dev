//
//  IncomingRequestViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 01.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class IncomingRequestViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    func set(_ model: IncomingRequest) {
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl ?? "")
    }
}
