//
//  IncomingMessageViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class IncomingMessageViewCell: UITableViewCell {

    let MinDateWidth: CGFloat = 130
    let LeftPadding: CGFloat = 50
    let RightPadding: CGFloat = 30
    let TextSidePadding: CGFloat = 10
    var screenWidth: CGFloat {
        UIApplication.shared.windows[0].frame.width
    }
    
    var maxTextWigth: CGFloat {
        screenWidth - LeftPadding - TextSidePadding * 2
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setRotation(180)
    }
    
    func set(_ model: ChatMessage) {
        if !model.isIncoming {
            fatalError("\(IncomingMessageViewCell.reuseIdentifier) support only 'true' value for isIncoming for ChatMessage")
        }
        nameLabel.text = model.user.name
        dateLabel.text = model.date.localDate().toString("dd:MM:yy HH:mm:ss")
        avatarImageView.downloaded(from: model.user.avatarUrl, placeholder: "no_avatar")
        messageTextView.text = model.text
        
        let textSize = model.text.getRequiredTextSize(messageTextView.font!, maxTextWigth)
        let bubbleWidth = max(textSize.width, MinDateWidth)
        bubbleWidthConstraint.constant = bubbleWidth
    }
}
