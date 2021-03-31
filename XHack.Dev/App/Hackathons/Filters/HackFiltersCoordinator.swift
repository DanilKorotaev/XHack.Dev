//
//  HackFiltersCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 31.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum HackFiltersResult {
    case rejected
    case successfull(filters: HackFilters)
}

struct HackFiltersParameter {
    let filters: HackFilters?
}

class HackFiltersCoordinator: BaseCoordinator<HackFiltersResult> {
    
    private let result = PublishSubject<HackFiltersResult>()
    private let viewModel: HackFiltersViewModel
    
    var parameter: HackFiltersParameter?
    
    init(viewModel: HackFiltersViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<HackFiltersResult> {
        let viewController = HackFiltersViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.parameter = parameter
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return result
    }
    
    private func applyBindings() {
        viewModel.back.bind { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.result.onNext(.rejected)
        }.disposed(by: disposeBag)
        
        viewModel.selectTags.bind { [weak self]  in
            guard let self = self else { return }
            self.selectTags(self.viewModel.filters.tags ?? []).done { [weak self] result in
                guard let self = self else { return }
                switch (result) {
                case .successfull(let selectedTags):
                    self.viewModel.tagsSelected.onNext(selectedTags)
                default:
                    return
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.save.bind { [weak self] in
            guard let self = self else { return }
            self.navigationController.popViewController(animated: true)
            self.result.onNext(.successfull(filters: self.viewModel.filters))
        }.disposed(by: disposeBag)
    }
}
