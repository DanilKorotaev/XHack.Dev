//
//  SelectTagsCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum SelectTagsResult {
    case rejected
    case successfull(tags: [Tag])
}

struct SelectTagsParameter {
    let selectedTag: [Tag]
}

class SelectTagsCoordinator: BaseCoordinator<SelectTagsResult> {
    
    let viewModel: SelectTagsViewModel
    private let result = PublishSubject<SelectTagsResult>()
    
    var parameter: SelectTagsParameter?
    
    init(viewModel: SelectTagsViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<SelectTagsResult> {
        let viewController = SelectTagsViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.parameter = parameter
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return result
    }
    
    private func applyBindings() {
        viewModel.back.bind {  [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.result.onNext(.rejected)
        }.disposed(by: disposeBag)
        
        viewModel.save.bind { [weak self] in
            guard let self = self else { return }
            self.result.onNext(.successfull(tags: self.viewModel.tags.filter { $0.isSelected.value }))
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
