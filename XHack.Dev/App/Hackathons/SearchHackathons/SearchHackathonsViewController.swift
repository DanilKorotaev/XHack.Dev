//
//  HackathonsListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class SearchHackathonsViewController: BaseViewController<SearchHackathonsViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.searchHackathons
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: CustomShadowTextField!
    
    override func completeUi() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "HackathonViewCell", bundle: nil), forCellReuseIdentifier: "HackathonViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.hackathons
            .bind(to: tableView.rx.items(cellIdentifier: "HackathonViewCell")) { row, model, cell in
                guard let cell = cell as? HackathonViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .asDriver()
            .debounce(2)
            .distinctUntilChanged()
            .drive(onNext: {value in
                dataContext.filterBy.onNext(value)
            })
            .disposed(by: disposeBag)
    }
}
