//
//  HackathonsListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackathonsListViewController: BaseViewController<HackathonsListViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.hackathonsList
    
    @IBOutlet weak var tableView: UITableView!
        
    override func completeUi() {
        tableView.tableFooterView = UIView()
    }
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.hackathons
            .bind(to: tableView.rx.items(cellIdentifier: "hackViewCell")) { row, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.description
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
    }
}
