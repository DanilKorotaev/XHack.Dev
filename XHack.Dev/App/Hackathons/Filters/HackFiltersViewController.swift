//
//  HackFiltersViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 31.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackFiltersViewController: BaseViewController<HackFiltersViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.hackFilters
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tagsButtons: UIButton!
    @IBOutlet weak var isOnlineSwitch: UISwitch!
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        (dataContext.back <- backButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.save <- saveButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.selectTags <- tagsButtons.rx.tap)
            .disposed(by: disposeBag)
        
        (isOnlineSwitch.rx.isOn <-> dataContext.isOnline)
            .disposed(by: disposeBag)
    }
}
