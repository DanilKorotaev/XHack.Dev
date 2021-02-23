//
//  TeamListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackTeamListViewController: BaseViewController<HackTeamListViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.hackTeamList
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: CustomShadowTextField!
    @IBOutlet weak var backButton: UIButton!
        
    override func completeUi() {
        configureDismissKeyboard()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(HackathonViewCell.nib, forCellReuseIdentifier: HackathonViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.teams
            .bind(to: tableView.rx.items(cellIdentifier: HackathonViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? HackathonViewCell else { return }
//                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Team.self)
            .bind(to: dataContext.teamSelected)
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .asDriver()
            .skip(3)
            .debounce(2)
            .distinctUntilChanged()
            .drive(onNext: {value in
                dataContext.filterBy.onNext(value)
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}

