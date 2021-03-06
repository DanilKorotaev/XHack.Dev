//
//  StartUpScreenCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class StartUpScreenCoordinator: BaseCoordinator<Void> {
    private let viewModel: StartUpScreenViewModel
    private let sessionService: SessionService
    private var window = UIWindow(frame: UIScreen.main.bounds)
    private let context: IAppContext
    
    init(sessionService: SessionService, context: IAppContext, viewModel: StartUpScreenViewModel) {
        self.sessionService = sessionService
        self.context = context
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        window.makeKeyAndVisible()
        let viewController = StartUpScreenViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: false)
        navigationController.navigationBar.isHidden = true
        applyBindings()
        subscribeToSessionChanges()
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: navigationController,
            withAnimation: false)
        
        sessionService.sessionState == nil
            ? showSignIn()
            : showRootTabBar()
        
        return Observable.empty()
    }
    
    func applyBindings() {
        
    }
    
    
    private func subscribeToSessionChanges() {
        sessionService.didSignIn
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.showRootTabBar() })
            .disposed(by: disposeBag)
        
        sessionService.didSignOut
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showSignIn()
            })
            .disposed(by: disposeBag)
    }
    
    private func showSignIn() {
        let coordinator = AppDelegate.container.resolve(SignInCoordinator.self)!
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
    
    private func showRootTabBar() {
        context.updateUserData().done { (result) in
            let coordinator = AppDelegate.container.resolve(RootTabBarCoordinator.self)!
            self.start(coordinator: coordinator)
            ViewControllerUtils.setRootViewController(
                window: self.window,
                viewController: coordinator.navigationController,
                withAnimation: true)
        }
    }
}
