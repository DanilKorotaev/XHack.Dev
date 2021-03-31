//
//  BookmarkedUsersViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class BookmarkedUsersViewController: BaseViewController<BookmarkedUsersViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.bookmarkedUsers
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func completeUi() {
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
        
        dataContext.users.rx_elements()
            .bind(to: collectionView.rx.items(cellIdentifier: ShortUserViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? ShortUserViewCell else { return }
                cell.set(for: model)
            }.disposed(by: disposeBag)
        
        (dataContext.memberSelected <- collectionView.rx.modelSelected(ShortUser.self))
            .disposed(by: disposeBag)
    }
}
