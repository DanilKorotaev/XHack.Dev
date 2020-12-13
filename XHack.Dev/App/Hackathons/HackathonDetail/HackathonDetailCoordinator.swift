//
//  HackathonDetailCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonDetailCoordinator: BaseCoordinator<Void> {
    let hackathonApi: IHackathonsApi
    let viewModel: HackathonDetailViewModel
    
    init(viewModel: HackathonDetailViewModel, hackathonApi: IHackathonsApi) {
        self.hackathonApi = hackathonApi
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackathonDetailViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
}
