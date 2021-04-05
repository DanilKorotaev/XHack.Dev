//
//  MemberListCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

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
        
        viewModel.selectFilters.bind { [weak self] hack in
            self?.setFilters()
        }.disposed(by: disposeBag)
        
        viewModel.memberSelected.bind { member in
            self.toMemberProfile(member)
        }.disposed(by: disposeBag)
    }
    
    private func toMemberProfile(_ member: ShortUser) {
        self.toUserDetails(for: member.id)
    }
    
    func setFilters() {
        self.selectTags(self.viewModel.filters.tags ?? []).done { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .successfull(let selectedTags):
                self.viewModel.filtersSelected.onNext(HackMemberFilters(tags:selectedTags))
            default:
                return
            }
        }
    }
}
