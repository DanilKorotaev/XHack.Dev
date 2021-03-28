//
//  PageItemView.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class PageItemView: UIView {
    private var itemButton: UIButton!
    private var dividerSelectedView: UIView!
    
    private lazy var dividerSelectedLayer: CAGradientLayer = {
        let layer2 = CAGradientLayer()
        layer2.colors = [
            UIColor(red: 1, green: 0, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 0.962, green: 0.346, blue: 0, alpha: 1).cgColor
        ]
        layer2.locations = [0, 1]
        layer2.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer2.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer2.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.92, b: 1.28, c: -1.28, d: -19.9, tx: 1.6, ty: 9.86))
        layer2.bounds = dividerSelectedView.bounds
        layer2.position = dividerSelectedView.center
        dividerSelectedView.layer.insertSublayer(layer2, at: 0)
        return layer2
    }()
    
    var didSelectedItem = PublishSubject<Int>()
    var index = BehaviorSubject<Int>(value: 0)
    
    var title: String  = "" {
        didSet {
            itemButton.setTitle(title, for: .normal)
        }
    }
    
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        loadNib()
        setupRx()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dividerSelectedLayer.frame = CGRect(origin: .zero, size: dividerSelectedView.bounds.size)
        dividerSelectedLayer.bounds = dividerSelectedView.bounds
    }
    
    private func loadNib() {
        itemButton = UIButton()
        itemButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        itemButton.setTitleColor(.black, for: .normal)
        self.addSubview(itemButton)
        itemButton.joinToSuperView()
        dividerSelectedView = UIView()
        dividerSelectedView.backgroundColor = .clear
        self.addSubview(dividerSelectedView)
        dividerSelectedView.joinToSuperView(left: 0, top: nil, right: 0, bottom: 0)
        dividerSelectedView.joinHeight(constant: 2)
        self.backgroundColor = UIColor.clear
    }
    
    private func setupRx() {
        itemButton.rx
            .tap
            .asObservable()
            .flatMapLatest { _ -> Observable<Int> in
                return Observable.just(self.index.value)
            }
            .bind(to: self.didSelectedItem)
            .disposed(by: bag)
    }
    
    
    func updateItemView(selected: Bool = false) {
        dividerSelectedView.isHidden = !selected
    }
}
