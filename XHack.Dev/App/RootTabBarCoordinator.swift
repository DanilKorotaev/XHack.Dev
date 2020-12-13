import Foundation
import UIKit
import RxSwift

class RootTabBarCoordinator : BaseCoordinator<Void> {
    
    var tabBarController: UITabBarController!
    
    override func start() -> Observable<Void> {
        tabBarController = tabBarController ?? UITabBarController()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [tabBarController]
        let homeCoordinator = AppDelegate.container.resolve(HomeCoordinator.self)!

        start(coordinator: homeCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        let homeViewController = homeCoordinator.navigationController
        homeViewController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        
        let profileCoordinator = AppDelegate.container.resolve(ProfileCoordinator.self)!
        
        start(coordinator: profileCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let profileViewController = profileCoordinator.navigationController
        
        profileViewController.tabBarItem = UITabBarItem(title: "profile", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile"))
        
        let teamsCoordinator = AppDelegate.container.resolve(TeamListCoordonator.self)!
        
        start(coordinator: teamsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let teamViewController = teamsCoordinator.navigationController
        teamViewController.tabBarItem = UITabBarItem(title: "teams", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile"))
        
        let hacksCoordinator = AppDelegate.container.resolve(HackathonsListCoordinator.self)!
        
        start(coordinator: hacksCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let hacksViewController = hacksCoordinator.navigationController
        hacksViewController.tabBarItem = UITabBarItem(title: "hacks", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile"))
        
        tabBarController.setViewControllers([homeViewController, teamViewController, hacksViewController, profileViewController], animated: true)
        
        return Observable.empty()
    }
}
