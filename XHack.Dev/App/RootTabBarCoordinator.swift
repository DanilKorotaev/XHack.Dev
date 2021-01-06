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
        homeViewController.tabBarItem = UITabBarItem(title: "home", image: #imageLiteral(resourceName: "Burger"), selectedImage: #imageLiteral(resourceName: "Burger_tap").withRenderingMode(.alwaysOriginal))
        homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:.selected)
        let profileCoordinator = AppDelegate.container.resolve(ProfileCoordinator.self)!
        
        start(coordinator: profileCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let profileViewController = profileCoordinator.navigationController
        
        profileViewController.tabBarItem = UITabBarItem(title: "profile", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile_tap").withRenderingMode(.alwaysOriginal))
        profileViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:.selected)
        
        let chatListCoordinator = AppDelegate.container.resolve(ChatListCoordinator.self)!
        
        start(coordinator: chatListCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let chatListViewController = chatListCoordinator.navigationController
        chatListViewController.tabBarItem = UITabBarItem(title: "messanger", image: #imageLiteral(resourceName: "Messanger"), selectedImage: #imageLiteral(resourceName: "Messanger_tap").withRenderingMode(.alwaysOriginal))
        chatListViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:.selected)
        
        let hacksCoordinator = AppDelegate.container.resolve(HackathonListCoordinator.self)!
        
        start(coordinator: hacksCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        let hacksViewController = hacksCoordinator.navigationController
        hacksViewController.tabBarItem = UITabBarItem(title: "hacks", image: #imageLiteral(resourceName: "Calendar"), selectedImage: #imageLiteral(resourceName: "Calendar_tap").withRenderingMode(.alwaysOriginal))
        hacksViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:.selected)
        tabBarController.setViewControllers([homeViewController, hacksViewController, UIViewController(), chatListViewController, profileViewController], animated: true)
        
        self.tabBarController.tabBar.items![2].isEnabled = false

        let chooseCoordinator =  Container.resolve(ChooseSearchCategoryCoordinator.self)
        start(coordinator: chooseCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        tabBarController.middleButtonTap = {
            chooseCoordinator.viewController.dismissRequested = {
                UIView.animate(withDuration: 0.2) {
                    chooseCoordinator.viewController.view.alpha = 0
                } completion: { _ in
                    chooseCoordinator.viewController.view.removeFromSuperview()
                }
            }
            
            guard let window = UIApplication.shared.windows.first else { return }

            chooseCoordinator.viewController.view.alpha = 0
            window.addSubview(chooseCoordinator.viewController.view)
            UIView.animate(withDuration: 0.2) {
                chooseCoordinator.viewController.view.alpha = 1
            }
//            self.navigationController.present(chooseCoordinator.viewController, animated: true, completion: nil)
        }
        
        return Observable.empty()
    }
}
