//
//  ChatViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class ChatViewController: BaseViewController<ChatViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.chat

    let defaultMessageTextViewHeight: CGFloat = 35
    lazy var pageLoadingBehavior: PageLoadingBehaviour = {
        return PageLoadingBehaviour(TableViewLoadingTarget(tableView))
    }()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputViewBottomtConstraint: NSLayoutConstraint!
    
    override func completeUi() {
        configureDismissKeyboard()
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(IncomingMessageViewCell.nib, forCellReuseIdentifier: IncomingMessageViewCell.reuseIdentifier)
        tableView.register(OutgoingMessageViewCell.nib, forCellReuseIdentifier: OutgoingMessageViewCell.reuseIdentifier)
        tableView.setRotation(180)
        messageTextView.textContainerInset = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        messageTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageLoadingBehavior.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageLoadingBehavior.deinitialize()
    }
    
    
    func setTextInputHeight() {
        var inputHeight = messageTextView.getRequiredTextSize().height
        if inputHeight < defaultMessageTextViewHeight {
            inputHeight = defaultMessageTextViewHeight
        }
        
        let isMaxSize = inputHeight >= 150;
        inputHeight = isMaxSize ? 150 : inputHeight
        
        if inputHeight != messageTextViewHeightConstraint.constant {
            messageTextViewHeightConstraint.constant = inputHeight
            if !isMaxSize {
                messageTextView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        nameLabel.text = dataContext.shortChat?.name
        avatarImageView.downloaded(from: dataContext.shortChat?.avatarUrl ?? "")
        
        dataContext.messages.rx_elements()
            .bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                if item.isIncoming {
                    let cell = tableView.dequeueReusableCell(withIdentifier: IncomingMessageViewCell.reuseIdentifier) as! IncomingMessageViewCell
                    cell.set(item)
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingMessageViewCell.reuseIdentifier) as! OutgoingMessageViewCell
                cell.set(item)
                return cell
        }
        .disposed(by: disposeBag)

        pageLoadingBehavior.command = dataContext.loadNext
        dataContext.isPageLoading
            .bind(to: pageLoadingBehavior.isLoading)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .bind(to: dataContext.sendMessage)
            .disposed(by: disposeBag)
        
        messageTextView.rx.text.orEmpty
            .bind(to: dataContext.messageText)
            .disposed(by: disposeBag)
        
        dataContext.messageText
            .bind(to: messageTextView.rx.text)
            .disposed(by: disposeBag)
        
        informationButton.rx.tap
            .bind(to: dataContext.information)
            .disposed(by: disposeBag)
        
        dataContext.messages.rx_events()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx_autoUpdater)
            .disposed(by: disposeBag)
    }
    
    override func keyboardHideHandler(_ keyboardBounds: CGRect) {
        inputViewBottomtConstraint.constant = 0
    }
    
    override func keyboardShownHandler(_ keyboardBounds: CGRect) {
        inputViewBottomtConstraint.constant = keyboardBounds.height - safeAreaInsets.bottom
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        setTextInputHeight()
    }
}
