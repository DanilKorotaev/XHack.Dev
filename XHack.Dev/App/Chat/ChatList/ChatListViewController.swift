//
//  ChatListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class ChatListViewController: BaseViewController<ChatListViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.chatList
    
    @IBOutlet weak var tableView: UITableView!
    var refreshHandler: RefreshHandler!
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
        refreshHandler = RefreshHandler(view: tableView)
        tableView.register(ChatViewCell.nib, forCellReuseIdentifier: ChatViewCell.reuseIdentifier)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.isRefreshing
            .bind(to: refreshHandler.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshHandler.refresh
            .bind(to: dataContext.refresh)
            .disposed(by: disposeBag)
        
        dataContext.chats.rx_elements().bind { [weak self] hacks in
            self?.tableView.isHidden = hacks.isEmpty
        }.disposed(by: disposeBag)
        
        
        dataContext.chats.rx_elements()
            .bind(to: tableView.rx.items(cellIdentifier: ChatViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? ChatViewCell else { return }
                cell.set(model: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortChat.self)
            .bind(to: dataContext.chatSelect)
            .disposed(by: disposeBag)
    }
}
