
import Foundation

class HomeCoordinator: BaseCoordinator {
    
    let homeViewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        homeViewModel = viewModel
    }
    
    override func start() {
        let viewController = HomeViewController.instantiate()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [viewController]
        viewController.viewModel = homeViewModel
    }
}
