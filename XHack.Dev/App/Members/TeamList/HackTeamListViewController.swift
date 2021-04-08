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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(HackTeamViewCell.self)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.teams.rx_elements()
            .bind(to: tableView.rx.items(cellIdentifier: HackTeamViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? HackTeamViewCell else { return }
                cell.set(model)
            }
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(Team.self)
//            .bind(to: dataContext.teamSelected)
//            .disposed(by: disposeBag)
        
//        searchTextField.rx.text.orEmpty
//            .asDriver()
//            .skip(3)
//            .debounce(2)
//            .distinctUntilChanged()
//            .drive(onNext: {value in
//                dataContext.filterBy.onNext(value)
//            })
//            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}

extension HackTeamListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataContext = dataContext  else {
            return
        }
        let team = dataContext.teams[indexPath.row]
        dataContext.teamSelected.onNext(team)
    }
}
