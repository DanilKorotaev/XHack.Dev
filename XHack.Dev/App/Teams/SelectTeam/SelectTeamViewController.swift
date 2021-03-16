//
//  SelectTeamViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class SelectTeamViewController: BaseViewController<SelectTeamViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.selectTeam
    
    var delegate: ModalHandler?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func completeUi() {
        tableView.separatorStyle = .none
        tableView.register(SelectTeamViewCell.nib, forCellReuseIdentifier: SelectTeamViewCell.reuseIdentifier)
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
        
        dataContext.teams
            .bind(to: tableView.rx.items(cellIdentifier: SelectTeamViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? SelectTeamViewCell else { return }
                cell.set(model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortTeam.self)
            .bind(to: dataContext.teamSelect)
            .disposed(by: disposeBag)
    }
}
