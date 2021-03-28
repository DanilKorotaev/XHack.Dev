//
//  BookmarkedHacksViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class BookmarkedHacksViewController: BaseViewController<BookmarkedHacksViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.bookmarkedHacks
    
    @IBOutlet weak var tableView: UITableView!

    override func completeUi() {
        tableView.register(HackathonViewCell.self)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        dataContext.hackathons.rx_elements()
            .bind(to: tableView.rx.items(cellIdentifier: HackathonViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? HackathonViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.hackSelect)
            .disposed(by: disposeBag)
    }
}

