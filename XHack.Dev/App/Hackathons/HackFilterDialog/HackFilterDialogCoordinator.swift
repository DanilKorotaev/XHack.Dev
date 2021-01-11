//
//  HackFilterDialogCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum HackFilterResult {
    case rejected
    case success
    case skip
}

class HackFilterDialogCoordinator: BaseCoordinator<HackFilterResult> {
    
    let viewModel: HackFilterDialogViewModel
    let result = PublishSubject<HackFilterResult>()
    
//    let currectQuestion: BehaviorSubject<HackFilterItem>
//    let questions: [HackFilterItem] = {
//
//    }
    
    init(viewModel: HackFilterDialogViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<HackFilterResult> {
        let controller = HackFilterDialogViewController.instantiate()
        controller.dataContext = viewModel
        navigationController.pushViewController(controller, animated: true)
        applyBindings()
        return result
    }
    
    func applyBindings() {
        viewModel.backRequest
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
            self?.dismiss()
            self?.result.onNext(.rejected)
        }).disposed(by: disposeBag)
        
        viewModel.skipRequest
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
            self?.dismiss()
            self?.result.onNext(.skip)
        }).disposed(by: disposeBag)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
