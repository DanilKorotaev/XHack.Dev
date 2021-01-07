import Foundation
import RxSwift

class HomeCoordinator: BaseCoordinator<Void> {
    
    let homeViewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        homeViewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HomeViewController.instantiate()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: "home", image: #imageLiteral(resourceName: "Burger"), selectedImage: #imageLiteral(resourceName: "Burger_tap").withRenderingMode(.alwaysOriginal))
        viewController.viewModel = homeViewModel
        
        return Observable.empty()
    }
}
