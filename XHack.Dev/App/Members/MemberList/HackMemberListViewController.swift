//
//  MemberListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackMemberListViewController: BaseViewController<HackMemberListViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.hackMemberList
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: CustomShadowTextField!
    @IBOutlet weak var backButton: UIButton!
    
    override func completeUi() {
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        searchTextField.rx.text.orEmpty
            .asDriver()
            .skip(3)
            .debounce(2)
            .distinctUntilChanged()
            .drive(onNext: {value in
                dataContext.filterBy.onNext(value)
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}
