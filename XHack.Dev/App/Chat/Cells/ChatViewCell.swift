//
//  ChatViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class ChatViewCell: UITableViewCell {

    private var disposeBag: DisposeBag!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var unreadCountView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func set(model: ShortChat) {
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl)
        lastMessageLabel.text = model.lastMessage?.text
        unreadCountView.isHidden = model.unreadCount <= 0
        unreadCountLabel.text = "\(model.unreadCount)"
    }
}
