//
//  SelectTeamCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum SelectTeamResult {
    case rejected
    case noTeams
    case successful(ShortTeam)
}

struct SelectTeamParameter {
    let teams: [ShortTeam]
}

class SelectTeamCoordinator: BaseCoordinator<SelectTeamResult> {
    private let result = PublishSubject<SelectTeamResult>()
    private let viewModel: SelectTeamViewModel
    private var viewController: SelectTeamViewController!
    var parameter : SelectTeamParameter!
    
    init(viewModel: SelectTeamViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<SelectTeamResult> {
        viewController = SelectTeamViewController.instantiate()
        viewModel.parameter = parameter
        viewController.dataContext = viewModel
        applyBindings()
        navigationController.present(viewController, animated: true, completion: nil)
        
        return result
    }
    
    func applyBindings() {
        viewModel.close.subscribe(onNext: { _ in
            self.viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        viewModel.teamSelect.subscribe(onNext: { team in
            self.result.onNext(.successful(team))
            self.viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
