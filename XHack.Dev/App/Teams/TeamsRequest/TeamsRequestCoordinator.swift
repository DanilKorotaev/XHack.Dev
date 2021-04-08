//
//  TeamsRequestCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum TeamRequestsResult {
    case rejected
    case changed
}

class TeamRequestCoordinator: BaseCoordinator<TeamRequestsResult> {
    private var viewController: TeamRequestViewController!
    
    private let result = PublishSubject<TeamRequestsResult>()
    private let viewModel: TeamRequestViewModel
    private var contentChanged: Bool = false
    
    var requests: [TeamRequest]!
    
    init(viewModel: TeamRequestViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<TeamRequestsResult> {
        viewController = TeamRequestViewController.instantiate()
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

extension TeamRequestCoordinator: ModalHandler {
    func modalDismissed() {
        self.result.onNext(contentChanged ? .changed : .rejected)
    }
}
