//
//  TopHackViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class TopHackViewCell: UICollectionViewCell {

    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var hackNameLabel: UILabel!
    
    var avatarUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(for model: ShortHackathon) {
        if avatarUrl != model.avatarUrl {
            hackImageView.downloaded(from: model.avatarUrl, contentMode: .scaleAspectFill)
            avatarUrl = model.avatarUrl
        }
        
        hackNameLabel.text = model.name
//        locationLabel.text = model.location
        dateLabel.text = model.dateText
        locationImageView.isHidden = !model.isOnline
//        descriptionLabel.text = model.description
    }
    
    func setupCollection() {
        tagsCollectionView.register(UINib(nibName: "TagViewCell", bundle: nil), forCellWithReuseIdentifier: "TagViewCell")
        
    }
}
