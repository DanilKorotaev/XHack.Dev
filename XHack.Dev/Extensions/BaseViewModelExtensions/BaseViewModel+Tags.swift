//
//  BaseViewModel+Tags.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
import Swinject

fileprivate var disposedBags: [DisposeBag] = []

extension BaseCoordinator {
    func selectTags(_ alreadySelected: [Tag] = []) -> Promise<SelectTagsResult> {
        return Promise() { promise in
            let coordinator = Container.resolve(SelectTagsCoordinator.self)
            coordinator.navigationController = self.navigationController
            if !alreadySelected.isEmpty {
                coordinator.parameter = SelectTagsParameter(selectedTag: alreadySelected)
            }
            start(coordinator: coordinator).subscribe(onNext: { result in
                promise.fulfill(result)
            }).disposed(by: self.disposeBag)
        }
    }
}
