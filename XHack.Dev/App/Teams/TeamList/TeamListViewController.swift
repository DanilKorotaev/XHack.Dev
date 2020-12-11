//
//  TeamListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class TeamListViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.teamList
    
    var viewModel: TeamListViewModel?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: nil)
        setupBinding()
        viewModel?.fetchTeams()
        tableView.tableFooterView = UIView()
    }
    
    func setupBinding() {
        navigationItem.leftBarButtonItem!.rx.tap
            .bind(to: viewModel!.createTask)
            .disposed(by: disposeBag)
        
        viewModel?.teams
            .bind(to: tableView.rx.items(cellIdentifier: "teamViewCell")) { row, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.description
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
}
