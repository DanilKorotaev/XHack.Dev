//
//  BaseViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController<TViewModel>: UIViewController where TViewModel:BaseViewModel {

    private(set) var disposeBag = DisposeBag()
    
    var dataContext: TViewModel? {
        didSet {
            guard isViewLoaded else { return }
            disposeBag = DisposeBag()
            applyBinding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeUi()
        applyBinding()
        dataContext?.initialize()
    }
    
    func completeUi() { }
        
    func applyBinding() { }
}
