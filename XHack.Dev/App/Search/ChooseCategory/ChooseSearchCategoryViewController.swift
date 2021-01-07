//
//  ChooseSearchCategoryViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class ChooseSearchCategoryViewController: BaseViewController<ChooseSearchCategoryViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.chooseSearchCategory
    
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var teammateView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        teammateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamMateTap)))
        teamView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamTap)))
    }
    
    
    @objc func teamMateTap(_ gesture: UITapGestureRecognizer) {
        dataContext?.didTeammateSearchRequested.onNext(())
    }
    
    
    @objc func teamTap(_ gesture: UITapGestureRecognizer) {
        dataContext?.didTeamSearchRequested.onNext(())
    }
    
    
    @objc func handleDismiss(_ gesture: UITapGestureRecognizer) {
        dataContext?.dismissRequested.onNext(())
    }
}
