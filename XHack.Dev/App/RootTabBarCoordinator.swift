import Foundation
import UIKit
import RxSwift
import Swinject

class RootTabBarCoordinator : BaseCoordinator<Void> {
    
    var tabBarController: RootTabBarViewController!
    
    override func start() -> Observable<Void> {
        tabBarController = tabBarController ?? RootTabBarViewController()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [tabBarController]
        let homeCoordinator = AppDelegate.container.resolve(HomeCoordinator.self)!

        start(coordinator: homeCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        let homeViewController = homeCoordinator.navigationController
       
        let profileCoordinator = AppDelegate.container.resolve(ProfileCoordinator.self)!
        
        start(coordinator: profileCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let profileViewController = profileCoordinator.navigationController
        
        let chatListCoordinator = AppDelegate.container.resolve(ChatListCoordinator.self)!
        
        start(coordinator: chatListCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let chatListViewController = chatListCoordinator.navigationController
        
        let hacksCoordinator = AppDelegate.container.resolve(HackathonListCoordinator.self)!
        
        start(coordinator: hacksCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let hacksViewController = hacksCoordinator.navigationController
        
        tabBarController.setViewControllers([homeViewController, hacksViewController, UIViewController(), chatListViewController, profileViewController], animated: true)
        
        self.tabBarController.tabBar.items![2].isEnabled = false

        tabBarController.middleButtonTap = {
            let chooseCoordinator =  Container.resolve(ChooseSearchCategoryCoordinator.self)
            chooseCoordinator.navigationController = self.navigationController
            self.start(coordinator: chooseCoordinator)
                .subscribe()
                .disposed(by: self.disposeBag)
        }
        
        return Observable.empty()
    }
}
