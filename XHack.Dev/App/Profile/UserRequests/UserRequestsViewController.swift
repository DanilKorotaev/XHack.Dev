//
//  UserRequestsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 14.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class UserRequestsViewController: BaseViewController<UserRequestsViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.userRequests
    var delegate: ModalHandler?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UserRequestViewCell.nib, forCellReuseIdentifier: UserRequestViewCell.reuseIdentifier)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.modalDismissed()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        closeButton.rx.tap
            .bind(to: dataContext.close)
            .disposed(by: disposeBag)
        
        dataContext.requests
            .bind(to: tableView.rx.items(cellIdentifier: UserRequestViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? UserRequestViewCell else { return }
                cell.delegate = self
                cell.set(model)
            }
            .disposed(by: disposeBag)
    }
}

extension UserRequestsViewController: UserRequestViewCellDelegate {
    func apply(_ request: TeamRequest) {
        dataContext?.apply.onNext(request)
    }
    
    func cancel(_ request: TeamRequest) {
        dataContext?.cancel.onNext(request)
    }
}
