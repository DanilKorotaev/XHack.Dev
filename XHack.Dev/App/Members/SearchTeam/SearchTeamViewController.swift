//
//  SearchTeamViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 10.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class SearchTeamViewController: BaseViewController<SearchTeamViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.searchTeam
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    lazy var refreshHandler: RefreshHandler = {
        RefreshHandler(view: tableView)
    }()
    
    lazy var pageLoadingBehavior: PageLoadingBehaviour = {
        return PageLoadingBehaviour(TableViewLoadingTarget(tableView))
    }()
    
    override func completeUi() {
        tableView.register(HackTeamViewCell.self)
//        configureDismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageLoadingBehavior.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageLoadingBehavior.deinitialize()
    }
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        dataContext.teams.rx_elements().bind(to: tableView.rx.items(cellIdentifier: HackTeamViewCell.reuseIdentifier)) { row, model, cell in
            guard let cell = cell as? HackTeamViewCell else { return }
            cell.set(model)
        }
        .disposed(by: disposeBag)
        
        (dataContext.teamSelect <- tableView.rx.modelSelected(Team.self))
            .disposed(by: disposeBag)
        
        (dataContext.back <- backButton.rx.tap)
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
        
        dataContext.isRefreshing
            .bind(to: refreshHandler.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshHandler.refresh
            .bind(to: dataContext.refresh)
            .disposed(by: disposeBag)
        
        pageLoadingBehavior.command = dataContext.loadNext
        dataContext.isPageLoading
            .bind(to: pageLoadingBehavior.isLoading)
            .disposed(by: disposeBag)
    }
}
