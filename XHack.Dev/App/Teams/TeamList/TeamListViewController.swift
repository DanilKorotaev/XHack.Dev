//
//  TeamListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class TeamListViewController: BaseViewController<TeamListViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.teamList
    
    @IBOutlet weak var tableView: UITableView!
        
    override func completeUi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: nil)
        tableView.tableFooterView = UIView()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        navigationItem.leftBarButtonItem!.rx.tap
            .bind(to: dataContext.createTask)
            .disposed(by: disposeBag)
        
        dataContext.teams
            .bind(to: tableView.rx.items(cellIdentifier: "teamViewCell")) { row, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.description
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
}
