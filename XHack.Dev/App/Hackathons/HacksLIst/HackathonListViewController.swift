//
//  HackathonsListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackathonListViewController: BaseViewController<HackathonListViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.hackathonList
    
    @IBOutlet weak var tableView: UITableView!
    var tableHeaderView: HackListHeaderView!
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
        setupHeaderView()
        tableView.register(UINib(nibName: "HackathonViewCell", bundle: nil), forCellReuseIdentifier: "HackathonViewCell")
    }
    
    func setupHeaderView() {
        tableView.register(UINib(nibName: "HackListHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HackListHeaderView")
        tableHeaderView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: "HackListHeaderView") as! HackListHeaderView)
        tableView.tableHeaderView = tableHeaderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        tableHeaderView.dataContext = dataContext
        dataContext.hackathons
            .bind(to: tableView.rx.items(cellIdentifier: "HackathonViewCell")) { row, model, cell in
                guard let cell = cell as? HackathonViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
    }
}
