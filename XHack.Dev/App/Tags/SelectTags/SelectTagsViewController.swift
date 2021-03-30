//
//  SelectTagsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class SelectTagsViewController: BaseViewController<SelectTagsViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.selectTags
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    
    override func completeUi() {
        tableView.register(SelectedTagViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        (dataContext.back <- backButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.save <- saveButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.selectAll <- selectAllButton.rx.tap)
            .disposed(by: disposeBag)
        
        dataContext.tags.rx_elements()
            .bind(to: self.tableView.rx.items(cellIdentifier: SelectedTagViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? SelectedTagViewCell else { return }
                cell.set(model)
            }
            .disposed(by: self.disposeBag)
    }
}
