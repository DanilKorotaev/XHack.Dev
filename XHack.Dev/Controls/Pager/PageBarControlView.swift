//
//  PageBarControlView.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class PageBarControlView: UIView {

    private lazy var itemsStackView: UIStackView = {
       let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.joinToSuperView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    var items = PublishSubject<[InnerPage]>()
    var didSelectSegmentCallback = PublishSubject<Int>()
    private var bag = DisposeBag()
    var indexSelected = BehaviorSubject<Int>(value: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        setupRx()
    }
    
    private func commonInit(items: [InnerPage]) {
        guard items.count > 0 else { return }
        let widthItem = self.bounds.width / CGFloat(items.count)
        for (index, item) in items.enumerated() {
            let pageItemView = PageItemView()
            
            let frame = CGRect(x: CGFloat(index) * widthItem, y: 0, width: widthItem, height: self.bounds.height)
            pageItemView.frame = frame
            pageItemView.index.onNext(index)
            pageItemView.title = item.title
            if index == self.indexSelected.value  {
                pageItemView.updateItemView(selected: true)
            }
            self.itemsStackView.addSubview(pageItemView)

            pageItemView
                .didSelectedItem
                .subscribe(onNext: { index in
                    self.didSelectSegmentCallback.onNext(index)
                    self.indexSelected.onNext(index)
                })
                .disposed(by: bag)
        }
    }

    private func setupRx() {
        items.subscribe(onNext: { arrSegment in
            self.commonInit(items: arrSegment)
        }).disposed(by: bag)

        indexSelected.subscribe(onNext: { index in
            self.updateSelected(index: index)
        }).disposed(by: bag)
    }

    private func updateSelected(index: Int) {
        for (i, item) in self.itemsStackView.subviews.enumerated() {
            let subView = item as! PageItemView
            subView.updateItemView(selected: i == index)
        }
    }
}
