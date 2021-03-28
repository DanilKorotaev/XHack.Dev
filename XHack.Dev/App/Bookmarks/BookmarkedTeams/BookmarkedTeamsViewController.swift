//
//  BookmarkedTeamsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class BookmarkedTeamsViewController: BaseViewController<BookmarkedTeamsViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.bookmarkedTeams
    
    @IBOutlet weak var tableView: UITableView!

    override func completeUi() {
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
        
        tableView.rx.modelSelected(Team.self)
            .bind(to: dataContext.teamSelected)
            .disposed(by: disposeBag)
    }
}
