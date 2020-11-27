
import Foundation
import UIKit

class RootTabBarCoordinator : BaseCoordinator {
    
    var tabBarController: UITabBarController!
    
    override func start() {
        tabBarController = tabBarController ?? UITabBarController()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [tabBarController]
        let homeCoordinator = AppDelegate.container.resolve(HomeCoordinator.self)!
        homeCoordinator.start()
        let homeViewController = homeCoordinator.navigationController
        homeViewController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        
        let profileCoordinator = AppDelegate.container.resolve(ProfileCoordinator.self)!
        profileCoordinator.start()
        let profileViewController = profileCoordinator.navigationController
        profileViewController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile"))
        tabBarController.setViewControllers([homeViewController, profileViewController], animated: true)
    }
}
