//
//  RefreshHandler.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class RefreshHandler: NSObject {
    let refresh = PublishSubject<Void>()
    let refreshControl = UIRefreshControl()
    let isRefreshing = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    
    init(view: UIScrollView) {
        super.init()
        view.refreshControl = refreshControl
        if view is UICollectionView {
            view.alwaysBounceVertical = true
        }
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_: )), for: .valueChanged)
        setBinding()
    }
    
    func setBinding() {
        isRefreshing.bind { (value) in
            if !value {
                self.end()
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        refresh.onNext(())
    }
    
    func end() {
        if refreshControl.isRefreshing {
            if Thread.isMainThread {
                refreshControl.endRefreshing()
            } else {
                DispatchQueue.main.sync {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}
