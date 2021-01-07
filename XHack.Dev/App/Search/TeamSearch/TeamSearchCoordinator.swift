//
//  TeamSearchCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class TeamSearchCoordinator: BaseCoordinator<Void> {
    
    var viewModel: TeamSearchViewModel
    
    init(viewModel: TeamSearchViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        
        let controller = TeamSearchViewController.instantiate()
        controller.dataContext = viewModel
        navigationController.pushViewController(controller, animated: true)
        
        return Observable.empty()
    }
}
