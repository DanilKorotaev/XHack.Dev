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
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func set(model: ShortChat) {
        disposeBag = DisposeBag()
        nameLabel.text = model.name
        avatarImageView.downloaded(from: model.avatarUrl)
        model.lastMessageText
            .bind(to: lastMessageLabel.rx.text)
            .disposed(by: disposeBag)
        model.lastMessageDateText
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        model.unreadCount
            .bind{ count in
                self.unreadCountView.isHidden = count <= 0
                self.unreadCountLabel.text = "\(count)"
            }.disposed(by: disposeBag)
    }
}
