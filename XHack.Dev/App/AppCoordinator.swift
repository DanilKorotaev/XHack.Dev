import Foundation
import RxSwift
import SideMenu


class AppCoordinator: BaseCoordinator<Void> {
    private let sessionService: SessionService
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    private var drawerMenu: SideMenuNavigationController? {
        return SideMenuManager.default.leftMenuNavigationController
    }
        
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        window.makeKeyAndVisible()
        
        sessionService.sessionState == nil
            ? showSignIn()
            : showRootTabBar()
        
        subscribeToSessionChanges()
        return Observable.empty()
    }
    
    private func subscribeToSessionChanges() {
        sessionService.didSignIn
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.showRootTabBar() })
            .disposed(by: disposeBag)
        
        sessionService.didSignOut
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if self.drawerMenu?.isHidden ?? true {
                    self.showSignIn()
                } else {
                    self.drawerMenu?.dismiss(animated: true, completion: self.showSignIn)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showSignIn() {
//        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(SignInCoordinator.self)!
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
    
    private func showRootTabBar() {
//        removeChildCoordinators()
        let coordinator = AppDelegate.container.resolve(RootTabBarCoordinator.self)!
        start(coordinator: coordinator)
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
    
    
    private func showDashboard() {
//        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(DrawerMenuCoordinator.self)!
        coordinator.navigationController = BaseNavigationController()
        start(coordinator: coordinator).subscribe().disposed(by: disposeBag)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
}
