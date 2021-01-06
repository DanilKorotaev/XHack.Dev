//
//  PopularHackViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class PopularHackViewCell: UICollectionViewCell {

    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var nameHackLabel: UILabel!
    
    var avatarUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(for model: ShortHackathon) {
        if avatarUrl != model.avatarUrl {
            hackImageView.downloaded(from: model.avatarUrl, contentMode: .scaleToFill)
            avatarUrl = model.avatarUrl
        }
        
        nameHackLabel.text = model.name
    }
}
