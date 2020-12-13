//
//  HackathonDetailViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class HackathonDetailViewController: BaseViewController<HackathonDetailViewModel>, Storyboarded {
    
    static var storyboard = AppStoryboard.hackathonDetail
    
    @IBOutlet weak var hackDescriptionLabel: UILabel!
    
    override func completeUi() {
        
    }
    
    override func applyBinding() {
        dataContext?.hackathon
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](hackDetail) in
                guard let self = self, let hackDetail = hackDetail else { return }
                self.title = hackDetail.name
                self.hackDescriptionLabel.text = hackDetail.description
            }).disposed(by: disposeBag)
    }
}
