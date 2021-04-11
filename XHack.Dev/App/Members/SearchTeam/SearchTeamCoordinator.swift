//
//  SearchTeamCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 10.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SearchTeamCoordinator: BaseCoordinator<Void> {
    private let viewModel: SearchTeamViewModel
    
    var hackId = 0
    
    init(viewModel: SearchTeamViewModel){
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = SearchTeamViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.hackId = hackId
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
    
    func applyBindings() {
        viewModel.back.bind { _ in
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.teamSelect.bind { team in
            self.toTeamProfile(for: team.id)
        }.disposed(by: disposeBag)
    }
}
