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
        collectionView.register(ShortUserViewCell.nib, forCellWithReuseIdentifier: ShortUserViewCell.reuseIdentifier)
        let sideInset: CGFloat = 20
        collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        let cellSize = CGSize(width: 95, height: 126)
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = cellSize
            layout.minimumLineSpacing = 15
            layout.minimumInteritemSpacing = 10
        collectionView.setCollectionViewLayout(layout, animated: true)
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
        
//        collectionView.rx.modelSelected(Any.self)
//            .asDriver()
//            .drive(onNext: { [unowned self] user in
//                print(user)
////                dataContext.memberSelected.onNext(user)
//            })
//            .disposed(by: disposeBag)
        
//        collectionView.rx.modelSelected(ShortUser.self)
//            .subscribe(onNext: { user in
//                print("\(user.name)")
//            })
////            .bind(to: dataContext.memberSelected)
//            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.bind { index in
            print(index)
        }.disposed(by: disposeBag)
        
        dataContext.members
            .bind(to: collectionView.rx.items(cellIdentifier: ShortUserViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? ShortUserViewCell else { return }
                cell.set(for: model)
            }.disposed(by: disposeBag)
        
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}
