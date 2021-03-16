//
//  MemberListCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackMemberListCoordinator: BaseCoordinator<Void> {
    let viewModel: HackMemberListViewModel
    
    init(viewModel: HackMemberListViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackMemberListViewController.instantiate()
        viewController.dataContext = viewModel
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
    
    private func applyBindings() {
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.memberSelected.bind { member in
            self.toMemberProfile(member)
        }.disposed(by: disposeBag)
    }
    
    private func toMemberProfile(_ member: ShortUser) {
        self.toUserDetails(for: member.id)
    }
}
