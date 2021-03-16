//
//  UserRequestsCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 14.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum UserRequestsResult {
    case rejected
    case changed
}

class UserRequestsCoordinator: BaseCoordinator<UserRequestsResult> {
    private var viewController: UserRequestsViewController!
    
    private let result = PublishSubject<UserRequestsResult>()
    private let viewModel: UserRequestsViewModel
    private var contentChanged: Bool = false
    
    var requests: [TeamRequest]!
    
    init(viewModel: UserRequestsViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<UserRequestsResult> {
        viewController = UserRequestsViewController.instantiate()
        viewController.dataContext = viewModel
        viewController.delegate = self
        viewModel.requests.onNext(requests)
        applyBindings()
        navigationController.present(viewController, animated: true, completion: nil)
        return result
    }
    
    
    func applyBindings() {
        viewModel.close.subscribe(onNext: { _ in
            self.viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        viewModel.requestChanged.subscribe(onNext: { _ in
            self.contentChanged = true
            self.viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}

extension UserRequestsCoordinator: ModalHandler {
    func modalDismissed() {
        self.result.onNext(contentChanged ? .changed : .rejected)
    }
}
