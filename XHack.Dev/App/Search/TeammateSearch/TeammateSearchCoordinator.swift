//
//  TeammateSearchCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class TeammateSearchCoordinator: BaseCoordinator<Void> {
    
    var viewModel: TeammateSearchViewModel
    
    init(viewModel: TeammateSearchViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        
        let controller = TeammateSearchViewController.instantiate()
        controller.dataContext = viewModel
        navigationController.pushViewController(controller, animated: true)
        
        return Observable.empty()
    }
}
