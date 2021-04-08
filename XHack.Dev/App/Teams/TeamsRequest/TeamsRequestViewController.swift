//
//  TeamsRequestViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class TeamRequestViewController: BaseViewController<TeamRequestViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.teamRequest
    var delegate: ModalHandler?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func completeUi() {
        tableView.separatorStyle = .none
        tableView.register(TeamRequestViewCell.self)
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
            .bind(to: tableView.rx.items(cellIdentifier: TeamRequestViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? TeamRequestViewCell else { return }
                cell.delegate = self
                cell.set(model)
            }
            .disposed(by: disposeBag)
    }
}

extension TeamRequestViewController: TeamRequestViewCellDelegate {
    func apply(_ request: TeamRequest) {
        dataContext?.apply.onNext(request)
    }
    
    func cancel(_ request: TeamRequest) {
        dataContext?.cancel.onNext(request)
    }
}
