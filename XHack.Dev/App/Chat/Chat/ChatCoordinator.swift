//
//  ChatCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum ChatResult {
    case changed
    case chatCreated
    case nothingChanged
    case removed
}

class ChatCoordinator: BaseCoordinator<ChatResult> {
    let viewModel: ChatViewModel
    let context: IAppContext
    var shortChat: ShortChat? = .none
    
    let result = PublishSubject<ChatResult>()
    
    init(viewModel: ChatViewModel, context: IAppContext) {
        self.viewModel = viewModel
        self.context = context
    }
    
    override func start() -> Observable<ChatResult> {
        let viewController = ChatViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.shortChat = shortChat
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        
        return result
    }
    
    
    private func applyBindings() {
        viewModel.back.bind { _ in
            self.result.onNext(self.viewModel.resultStatus)
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.information.bind { _ in
            self.toInformation()
        }.disposed(by: disposeBag)
        
        viewModel.chatLeaved.bind { _ in
            self.result.onNext(.removed)
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.chatRemoved.bind { _ in
            self.result.onNext(.removed)
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func toInformation() {
        guard let type = shortChat?.type  else {
            return
        }
        switch type {
        case .p2p:
            guard let firstId = shortChat?.firstUser?.id, let secondId = shortChat?.secondUser?.id, let currentId = context.currentUser?.id
 else { return }
            if firstId == currentId {
                self.toUserDetails(for: secondId)
            } else {
                self.toUserDetails(for: firstId)
            }
        case .group:
            guard let teamId = shortChat?.team?.id else {
                return
            }
            self.toTeamProfile(for: teamId)
        }
    }
}
