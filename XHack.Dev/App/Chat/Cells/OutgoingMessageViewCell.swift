//
//  OutgoingMessageViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class OutgoingMessageViewCell: UITableViewCell {

    private var disposeBag: DisposeBag!
    
    let MinDateWidth: CGFloat = 140
    let LeftPadding: CGFloat = 30
    let RightPadding: CGFloat = 10
    let TextSidePadding: CGFloat = 10
    var screenWidth: CGFloat {
        UIApplication.shared.windows[0].frame.width
    }
    
    var maxTextWigth: CGFloat {
        screenWidth - LeftPadding - TextSidePadding * 2
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setRotation(180)
    }
    
    func set(_ model: ChatMessage) {
        disposeBag = DisposeBag()
        if model.isIncoming {
            fatalError("\(IncomingMessageViewCell.reuseIdentifier) support only 'false' value for isIncoming for ChatMessage")
        }
        dateLabel.text = model.date.localDate().toString("dd:MM:yy HH:mm:ss")
        messageTextView.text = model.text
        
        let textSize = model.text.getRequiredTextSize(messageTextView.font!, maxTextWigth)
        let bubbleWidth = max(textSize.width, MinDateWidth)
        bubbleWidthConstraint.constant = bubbleWidth
    }
}
