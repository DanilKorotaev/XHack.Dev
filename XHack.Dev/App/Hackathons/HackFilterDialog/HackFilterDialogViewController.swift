//
//  HackFilterDialogViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class HackFilterDialogViewController: BaseViewController<HackFilterDialogViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.hackFilterDialog

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        skipButton.rx.tap.bind(to: dataContext.skipRequest).disposed(by: disposeBag)
        backButton.rx.tap.bind(to: dataContext.backRequest).disposed(by: disposeBag)
    }
}
