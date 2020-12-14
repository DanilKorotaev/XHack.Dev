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
    @IBOutlet weak var willGoSwitch: UISwitch!
    
    override func completeUi() {
        
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.hackathon
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](hackDetail) in
                guard let self = self, let hackDetail = hackDetail else { return }
                hackDetail.name.subscribe(onNext: { self.title = $0 }).disposed(by: self.disposeBag)
                hackDetail.description.subscribe(onNext: { self.hackDescriptionLabel.text = $0 }).disposed(by: self.disposeBag)
                hackDetail.currentUserWillGo.subscribe(onNext: { self.willGoSwitch.isOn = $0 }).disposed(by: self.disposeBag)
                self.willGoSwitch.rx.isOn.bind(to: dataContext.didWillGoChanged).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
