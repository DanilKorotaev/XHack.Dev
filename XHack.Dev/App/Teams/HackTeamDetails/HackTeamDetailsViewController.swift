//
//  HackTeamDetailsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackTeamDetailsViewController: BaseViewController<HackTeamDetailsViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.hackTeamDetails

    @IBOutlet weak var backButton: UIButton!
    
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}
