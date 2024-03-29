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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stubView: UIView!
    
    var tableHeaderView: HackListHeaderView!
    var refreshHandler: RefreshHandler!
    
    lazy var pageLoadingBehavior: PageLoadingBehaviour = {
        return PageLoadingBehaviour(TableViewLoadingTarget(tableView))
    }()
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
//        setupHeaderView()
        refreshHandler = RefreshHandler(view: tableView)
        tableView.register(HackathonViewCell.self)
    }
    
    func setupHeaderView() {
        tableView.register(HackListHeaderView.nib, forHeaderFooterViewReuseIdentifier: HackListHeaderView.reuseIdentifier)
        tableHeaderView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: HackListHeaderView.reuseIdentifier) as! HackListHeaderView)
        tableView.tableHeaderView = tableHeaderView
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        
        searchButton.rx.tap
            .bind(to: dataContext.seachRequsted)
            .disposed(by: disposeBag)
        
//        tableHeaderView.dataContext = dataContext
        dataContext.hackathons
            .bind(to: tableView.rx.items(cellIdentifier: HackathonViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? HackathonViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        dataContext.hackathons.bind { [weak self] hacks in
            self?.stubView.isHidden = !hacks.isEmpty
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
        
        pageLoadingBehavior.command = dataContext.loadNext
        dataContext.isPageLoading
            .bind(to: pageLoadingBehavior.isLoading)
            .disposed(by: disposeBag)
    }
}
