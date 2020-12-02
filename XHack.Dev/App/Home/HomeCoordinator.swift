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
        viewController.viewModel = homeViewModel
        
        return Observable.empty()
    }
}
